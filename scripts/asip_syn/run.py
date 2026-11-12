#!/usr/bin/env python3
"""Run Design Compiler against an explicit open standard-cell library."""

import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import time

ROOT = Path(__file__).resolve().parents[2]
SETTINGS = {
    "nangate45": {"driver": "INV_X2", "pin": "ZN", "load": 33.4, "dont_use": "NangateOpenCellLibrary/SDFF*"},
    "sky130hd": {
        "driver": "sky130_fd_sc_hd__inv_2",
        "pin": "Y",
        "load": 0.0334,
        "dont_use": "*/sky130_fd_sc_hd__probe* */sky130_fd_sc_hd__lpflow*",
    },
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def collect_results(out, meta):
    """Validate completed tool output and derive metrics from native reports."""
    log = (out / "log/dc.log").read_text(errors="replace")
    if not re.search(r"^ASIP_SYNTHESIS_COMPLETE$", log, re.M) or re.search(r"^Error:", log, re.M):
        raise RuntimeError("Design Compiler did not complete cleanly; see log/dc.log")
    top = "cva5_top" if meta["core"] == "CVA5" else "top"
    artifacts = {}
    for suffix in ("v", "ddc", "sdf", "sdc"):
        artifact = out / "out" / f"{top}.{suffix}"
        if not artifact.is_file():
            raise RuntimeError(f"Missing synthesized artifact: {top}.{suffix}")
        artifacts[f"out/{top}.{suffix}"] = sha(artifact)
    if meta.get("artifacts_sha256") and meta["artifacts_sha256"] != artifacts:
        raise RuntimeError("Synthesized artifact hash mismatch")
    meta["artifacts_sha256"] = artifacts
    area_text = (out / "log/report_area_hier.log").read_text()
    timing_text = (out / "log/report_timing.log").read_text()
    units = (out / "log/units.rpt").read_text()
    expected_capacitance = "fF" if meta["pdk"] == "nangate45" else "pF"
    if f"Farad({expected_capacitance})" not in units or "Second(ns)" not in units:
        raise RuntimeError("Library units do not match the electrical constraint preset")
    number = r"([-+]?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)"
    areas = re.findall(r"Total cell area:\s*" + number, area_text)
    slacks = re.findall(r"slack \([^)]+\)\s*" + number, timing_text)
    if len(areas) != 1 or not slacks:
        raise RuntimeError("Missing or ambiguous area/timing measurements")
    metrics = {
        "cell_area": float(areas[0]),
        "clock_period_ns": meta["clock_period_ns"],
        "setup_slack_ns": min(float(value) for value in slacks),
    }
    qor = (out / "log/qor.rpt").read_text() if (out / "log/qor.rpt").exists() else ""
    hold = re.search(
        r"Design \(Hold\)\s+WNS:\s*" + number + r"\s+TNS:\s*" + number + r"\s+Number of Violating Paths:\s*(\d+)", qor
    )
    hold_met = None
    if hold:
        meta["hold_wns_ns"] = -float(hold[1])
        meta["hold_violating_paths"] = int(hold[3])
        hold_met = meta["hold_violating_paths"] == 0
    setup_met = metrics["setup_slack_ns"] >= 0
    meta.update(
        passed=True,
        status="complete",
        metrics=metrics,
        setup_timing_met=setup_met,
        hold_timing_met=hold_met,
        timing_met=setup_met and hold_met is True,
    )
    meta.pop("error", None)
    (out / "metrics.json").write_text(json.dumps(metrics, indent=2) + "\n")
    with (out / "metrics.csv").open("w") as stream:
        writer = csv.writer(stream)
        writer.writerow(
            [
                "total_cell_area",
                "isax_area",
                "isax_area_rel",
                "scaiev_area",
                "scaiev_area_rel",
                "clk",
                "status",
                "slack",
            ]
        )
        writer.writerow(
            [
                metrics["cell_area"],
                "",
                "",
                "",
                "",
                meta["clock_period_ns"],
                "MET" if setup_met else "VIOLATED",
                metrics["setup_slack_ns"],
            ]
        )
    return meta


def run(args):
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)
    if (out / "execution.json").exists():
        raise ValueError("Use a fresh output directory for each synthesis run")
    rtl = args.rtl.resolve()
    core = {"CVA5": "CVA5", "VEX_5S": "VexRiscv_5s", "VEX_4S": "VexRiscv_4s"}[args.core]
    if (rtl / core / "files.txt").exists():
        rtl = rtl / core
    sources = []
    for line in (rtl / "files.txt").read_text().splitlines():
        if line.strip():
            sources.append((rtl / line.strip()).resolve())
    # Nailgun's files.txt omits extension modules stored alongside the core.
    sources += sorted(rtl.parent.glob("ISAX_*.sv"))
    sources = list(dict.fromkeys(sources))
    settings = SETTINGS[args.pdk]
    db = args.library.resolve()
    script = ROOT / "scripts/asip_syn/synthesize.tcl"
    constraints = (args.constraints or ROOT / "scripts/asip_syn/constraints.tcl").resolve()
    meta = {
        "passed": False,
        "status": "running",
        "pdk": args.pdk,
        "core": args.core,
        "clock_period_ns": args.clock_ns,
        "library": str(db),
        "library_sha256": sha(db),
        "rtl_sha256": {str(p): sha(p) for p in sources},
        "constraints": str(constraints),
        "constraints_sha256": sha(constraints),
        "synthesis_script_sha256": sha(script),
        "dc_shell": args.dc_shell,
        "electrical_settings": settings,
        "boundary": "core and extension, external memory excluded",
        "physical_design": False,
    }
    (out / "execution.json").write_text(json.dumps(meta, indent=2) + "\n")
    for directory in ["work", "log", "out"]:
        (out / directory).mkdir(exist_ok=True)
    shutil.copyfile(script, out / "synthesize.tcl")
    shutil.copyfile(constraints, out / "constraints.tcl")
    source_list = out / "sources.txt"
    source_list.write_text("\n".join(str(p) for p in sources) + "\n")
    env = dict(
        os.environ,
        ASIP_DB=str(db),
        ASIP_SOURCES=str(source_list),
        TOPLEVEL="cva5_top" if args.core == "CVA5" else "top",
        CLOCK_PERIOD=str(args.clock_ns),
        ASIP_CONSTRAINTS=str(out / "constraints.tcl"),
        ASIP_CLOCK_PORT="clk",
        ASIP_DRIVING_CELL=settings["driver"],
        ASIP_DRIVING_PIN=settings["pin"],
        ASIP_OUTPUT_LOAD=str(settings["load"]),
        ASIP_DONT_USE=settings["dont_use"],
        ASIP_JOBS=str(args.jobs),
    )
    command = [args.dc_shell, "-f", str(out / "synthesize.tcl")]
    meta["command"] = command
    started = time.monotonic()
    try:
        with (out / "log/dc.log").open("w") as stream:
            result = subprocess.run(
                command, env=env, cwd=out, stdout=stream, stderr=subprocess.STDOUT, timeout=args.timeout
            )
        if result.returncode:
            raise RuntimeError(f"Design Compiler failed ({result.returncode}); see log/dc.log")
        collect_results(out, meta)
    except (OSError, ValueError, RuntimeError, subprocess.SubprocessError) as exc:
        meta.update(status="failed", error=str(exc))
    finally:
        meta["elapsed_seconds"] = time.monotonic() - started
        (out / "execution.json").write_text(json.dumps(meta, indent=2) + "\n")
    print(json.dumps(meta, indent=2))
    return meta["passed"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rtl", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--core", choices=["VEX_5S", "VEX_4S", "CVA5"], default="VEX_5S")
    parser.add_argument("--pdk", choices=SETTINGS, default="nangate45")
    parser.add_argument("--library", type=Path, required=True)
    parser.add_argument("--clock-ns", type=float, default=10)
    parser.add_argument("--jobs", type=int, default=8)
    parser.add_argument("--timeout", type=float, default=3600)
    parser.add_argument("--constraints", type=Path)
    parser.add_argument("--dc-shell", default=os.environ.get("ASIP_SYN_DC_SHELL", "dc_shell"))
    args = parser.parse_args()
    if args.clock_ns <= 0 or args.jobs <= 0 or args.timeout <= 0:
        parser.error("Clock period, jobs and timeout must be positive")
    raise SystemExit(0 if run(args) else 1)


if __name__ == "__main__":
    main()
