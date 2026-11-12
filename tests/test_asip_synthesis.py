"""Exercise synthesis provenance and fail-closed report handling without a license."""

import importlib.util
import json
from pathlib import Path
from types import SimpleNamespace

import pytest

ROOT = Path(__file__).resolve().parents[1]


def load(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / f"scripts/asip_syn/{name}.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def arguments(tmp_path):
    rtl = tmp_path / "rtl"
    core = rtl / "VexRiscv_5s"
    core.mkdir(parents=True)
    (core / "files.txt").write_text("core.sv\n")
    (core / "core.sv").write_text("module top; endmodule")
    (rtl / "ISAX_test.sv").write_text("module ISAX_test; endmodule")
    library = tmp_path / "test.db"
    library.write_bytes(b"library")
    return SimpleNamespace(
        output=tmp_path / "out",
        rtl=rtl,
        core="VEX_5S",
        pdk="nangate45",
        library=library,
        constraints=None,
        clock_ns=10,
        jobs=1,
        timeout=10,
        dc_shell="dc_shell",
    )


@pytest.mark.parametrize("log", ["No completion\n", "Error: Library missing\nASIP_SYNTHESIS_COMPLETE\n"])
def test_zero_exit_does_not_imply_success(tmp_path, monkeypatch, log):
    module = load("run")
    args = arguments(tmp_path)

    def invoke(*a, **kw):
        kw["stdout"].write(log)
        return SimpleNamespace(returncode=0)

    monkeypatch.setattr(module.subprocess, "run", invoke)
    assert not module.run(args)
    assert not json.loads((args.output / "execution.json").read_text())["passed"]
    assert not (args.output / "metrics.csv").exists()


@pytest.mark.parametrize("slack,hold_paths", [(-1, 0), (1, 2), (1, 0)])
def test_stages_sibling_extension_and_reports_timing_violation(tmp_path, monkeypatch, slack, hold_paths):
    module = load("run")
    args = arguments(tmp_path)

    def invoke(*a, **kw):
        kw["stdout"].write("ASIP_SYNTHESIS_COMPLETE\n")
        (args.output / "log/report_area_hier.log").write_text("Total cell area: 100\n")
        (args.output / "log/units.rpt").write_text("Second(ns) Farad(fF)\n")
        (args.output / "log/report_timing.log").write_text(f"slack (MET) {slack}\n")
        (args.output / "log/qor.rpt").write_text(
            f"Design (Hold) WNS: {0.16 if hold_paths else 0} TNS: 0 Number of Violating Paths: {hold_paths}\n"
        )
        for suffix in ("v", "ddc", "sdf", "sdc"):
            (args.output / "out" / f"top.{suffix}").write_text("artifact")
        return SimpleNamespace(returncode=0)

    monkeypatch.setattr(module.subprocess, "run", invoke)
    assert module.run(args)
    meta = json.loads((args.output / "execution.json").read_text())
    assert meta["passed"] and meta["timing_met"] == (slack >= 0 and hold_paths == 0)
    assert meta["setup_timing_met"] == (slack >= 0)
    assert meta["hold_timing_met"] == (hold_paths == 0)
    assert any(Path(p).name == "ISAX_test.sv" for p in meta["rtl_sha256"])
    assert ("VIOLATED" if slack < 0 else "MET") in (args.output / "metrics.csv").read_text()
    with pytest.raises(ValueError, match="fresh output"):
        module.run(args)
    (args.output / "out/top.v").write_text("changed netlist")
    with pytest.raises(RuntimeError, match="artifact hash mismatch"):
        module.collect_results(args.output, meta)


def test_library_hash_mismatch_never_runs_compiler(tmp_path, monkeypatch):
    module = load("prepare_libraries")
    directory = tmp_path / "nangate45"
    directory.mkdir()
    (directory / module.LIBRARIES["nangate45"][0]).write_text("untrusted data")

    def forbidden(*a, **kw):
        pytest.fail("Compiler must not consume an unverified download")

    monkeypatch.setattr(module.subprocess, "run", forbidden)
    with pytest.raises(ValueError, match="checksum mismatch"):
        module.prepare("nangate45", tmp_path, "lc_shell")
