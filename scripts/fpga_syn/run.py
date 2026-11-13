#!/usr/bin/env python3
"""Synthesize and execute native Nailgun firmware on the Arty A7-100T."""

import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def run(args):
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)
    tool = getattr(args, 'tool', 'vivado')
    if tool == 'symbiflow':
        tool = 'f4pga'
    firmware = args.firmware.resolve()
    meta = {
        "passed": False,
        "status": "preparing",
        "execution": "fpga",
        "tool": tool,
        "core": args.core,
        "board": "arty_a7_100",
        "clock_hz": 20000000,
        "firmware": str(firmware),
        "firmware_sha256": sha(firmware),
    }
    (out / "execution.json").write_text(json.dumps(meta, indent=2) + "\n")
    # Remove prior UART evidence before any operation which can fail.
    (out / "uart.log").write_bytes(b"")
    for stale in (out / "board/uart.bin", out / "board/execution.json"):
        stale.unlink(missing_ok=True)
    rtl = args.rtl.resolve()
    core_dir = rtl / ("CVA5" if args.core == "cva5" else "VexRiscv_5s")
    if not core_dir.is_dir():
        core_dir = rtl
    started = time.monotonic()

    def invoke(command, log, env=None):
        remaining = args.timeout - (time.monotonic() - started)
        if remaining <= 0:
            raise TimeoutError("FPGA execution time budget exhausted")
        with log.open("w") as stream:
            subprocess.run(command, stdout=stream, stderr=subprocess.STDOUT, env=env, check=True, timeout=remaining)

    try:
        if args.core != "vex":
            raise ValueError(
                "Native FPGA execution currently requires Vex: the CVA5 board shell lacks runtime counter MMIO"
            )
        if args.ram_size != 262144:
            raise ValueError("The Arty shells currently provide exactly 256 KiB RAM")
        sources = [
            (core_dir / name.strip()).resolve()
            for name in (core_dir / "files.txt").read_text().splitlines()
            if name.strip()
        ]
        sources += sorted(core_dir.parent.glob("ISAX_*.sv"))
        meta["rtl_source_sha256"] = {str(p): sha(p) for p in sources}
        coe = out / "firmware.coe"
        invoke(
            [sys.executable, str(ROOT / "scripts/fpga_syn/firmware/bin_to_coe.py"), str(firmware), str(coe)],
            out / "image.log",
        )
        env = dict(
            os.environ,
            FPGA_SYN_BOARD="arty_a7_100",
            FPGA_SYN_INIT_COE=str(coe),
            FPGA_SYN_PYTHON=sys.executable,
            FPGA_SYN_VIVADO=args.vivado,
            FPGA_SYN_TOOL=tool,
        )
        if tool == 'f4pga':
            env.pop('FPGA_SYN_INIT_COE', None)
            env['FPGA_SYN_FIRMWARE_BIN'] = str(firmware)
        build = out / "synthesis"
        command = [
            "bash",
            str(ROOT / "scripts/fpga_syn_script.sh"),
            str(build),
            str(core_dir),
            "CVA5" if args.core == "cva5" else "VEX_5S",
            "xc7a100tcsg324-1",
            "50",
        ]
        meta["synthesis_command"] = command
        invoke(command, out / "compile.log", env=env)
        bit = build / ("cva5_arty_top.bit" if args.core == "cva5" else "vex_arty_top.bit")
        meta["bitstream_sha256"] = sha(bit)
        # Check the actual routed result before allowing hardware programming.
        if tool == 'f4pga':
            spec = importlib.util.spec_from_file_location('f4pga_backend', ROOT/'scripts/fpga_syn/f4pga/run.py')
            backend = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(backend)
            timing = backend.validate(build)
            if not timing['setup_met'] or timing['hold_met'] is not True:
                raise RuntimeError('F4PGA hardware execution requires verified setup and hold timing')
        else:
            timing = (build / "reports/timing_summary.rpt").read_text()
            if "All user specified timing constraints are met." not in timing:
                raise RuntimeError("Routed FPGA design does not meet timing")
        board = out / "board"
        command = [
            sys.executable,
            str(ROOT / "scripts/fpga_syn/firmware/run_arty.py"),
            str(bit),
            str(board),
            "--protocol",
            "mlonmcu",
            "--vivado",
            args.vivado,
            "--board-serial",
            args.board_serial,
            "--port",
            args.port,
            "--timeout",
            str(max(1, args.timeout - (time.monotonic() - started) - 10)),
        ]
        programmer = getattr(args, 'programmer', None) or ('openfpgaloader' if tool == 'f4pga' else 'vivado')
        command += ['--programmer', programmer, '--openfpgaloader', getattr(args, 'openfpgaloader', 'openFPGALoader')]
        if args.uart_container:
            command += ["--uart-container", args.uart_container]
        invoke(command, out / "board.log")
        board_meta = json.loads((board / "execution.json").read_text())
        meta.update(passed=bool(board_meta["passed"]), status="complete", board_execution=board_meta)
    except (OSError, ValueError, RuntimeError, subprocess.SubprocessError) as exc:
        meta.update(status="failed", error=str(exc))
    finally:
        raw = out / "board/uart.bin"
        if raw.is_file():
            shutil.copyfile(raw, out / "uart.log")  # Preserve binary MLIF frames.
        meta["elapsed_seconds"] = time.monotonic() - started
        (out / "execution.json").write_text(json.dumps(meta, indent=2) + "\n")
    print(json.dumps({k: v for k, v in meta.items() if k not in ("board_execution", "rtl_source_sha256")}, indent=2))
    return meta["passed"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--core", choices=["cva5", "vex"], required=True)
    parser.add_argument("--rtl", type=Path, required=True)
    parser.add_argument("--firmware", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--ram-size", type=int, default=262144)
    parser.add_argument("--timeout", type=float, default=1800)
    parser.add_argument('--tool', choices=['vivado', 'f4pga', 'symbiflow'], default=os.environ.get('FPGA_SYN_TOOL', 'vivado'))
    parser.add_argument('--programmer', choices=['vivado', 'openfpgaloader'])
    parser.add_argument('--openfpgaloader', default='openFPGALoader')
    parser.add_argument("--vivado", default="/nfs/tools/xilinx/Vivado/2024.1/bin/vivado")
    parser.add_argument("--board-serial", default="210319C08AE1")
    parser.add_argument("--port", default="/dev/serial/by-id/usb-Digilent_Digilent_USB_Device_210319C08AE1-if01-port0")
    parser.add_argument("--uart-container")
    args = parser.parse_args()
    if args.timeout <= 0:
        parser.error("timeout must be positive")
    raise SystemExit(0 if run(args) else 1)


if __name__ == "__main__":
    main()
