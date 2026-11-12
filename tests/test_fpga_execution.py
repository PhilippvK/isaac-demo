"""Check FPGA failure handling without requiring Vivado or a board."""

import importlib.util
import json
from pathlib import Path
from types import SimpleNamespace

import pytest

ROOT = Path(__file__).resolve().parents[1]


@pytest.fixture
def runner():
    spec = importlib.util.spec_from_file_location("fpga_run", ROOT / "scripts/fpga_syn/run.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def arguments(tmp_path):
    firmware = tmp_path / "firmware.bin"
    firmware.write_bytes(b"firmware")
    rtl = tmp_path / "rtl"
    rtl.mkdir()
    (rtl / "core.sv").write_text("module core; endmodule\n")
    (rtl / "files.txt").write_text("core.sv\n")
    return SimpleNamespace(
        output=tmp_path / "out",
        firmware=firmware,
        rtl=rtl,
        core="vex",
        ram_size=262144,
        timeout=10,
        vivado="vivado",
        board_serial="test",
        port="test",
        uart_container=None,
    )


@pytest.mark.parametrize("failure", ["timing", "synthesis", "timeout"])
def test_failure_cannot_reuse_uart_or_program_board(tmp_path, monkeypatch, runner, failure):
    args = arguments(tmp_path)
    board = args.output / "board"
    board.mkdir(parents=True)
    (board / "uart.bin").write_bytes(b"MLONMCU EXIT: 0\n")
    (board / "execution.json").write_text('{"passed": true}')
    (args.output / "uart.log").write_text("old success")
    commands = []

    def invoke(command, **kwargs):
        commands.append(command)
        if command[0] == "bash":
            if failure == "synthesis":
                raise runner.subprocess.CalledProcessError(1, command)
            if failure == "timeout":
                raise runner.subprocess.TimeoutExpired(command, 10)
            build = args.output / "synthesis"
            (build / "reports").mkdir(parents=True)
            (build / "vex_arty_top.bit").write_bytes(b"bitstream")
            (build / "reports/timing_summary.rpt").write_text("Timing constraints are not met")

    monkeypatch.setattr(runner.subprocess, "run", invoke)
    assert not runner.run(args)
    meta = json.loads((args.output / "execution.json").read_text())
    assert meta["status"] == "failed" and not meta["passed"]
    assert (args.output / "uart.log").read_bytes() == b""
    assert not (board / "execution.json").exists()
    assert not any("run_arty.py" in str(command) for command in commands)


def test_success_preserves_binary_model_frames(tmp_path, monkeypatch, runner):
    args = arguments(tmp_path)
    raw = b"-?\x00\xff\x80\x00-!-\nProgram finish.\nMLONMCU EXIT: 0\n"

    def invoke(command, **kwargs):
        if command[0] == "bash":
            build = args.output / "synthesis"
            (build / "reports").mkdir(parents=True)
            (build / "vex_arty_top.bit").write_bytes(b"bitstream")
            (build / "reports/timing_summary.rpt").write_text("All user specified timing constraints are met.")
        elif "run_arty.py" in str(command):
            board = args.output / "board"
            board.mkdir()
            (board / "execution.json").write_text('{"passed": true}')
            (board / "uart.bin").write_bytes(raw)

    monkeypatch.setattr(runner.subprocess, "run", invoke)
    assert runner.run(args)
    assert (args.output / "uart.log").read_bytes() == raw
