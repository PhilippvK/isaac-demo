#!/usr/bin/env python3
"""Independent OpenLane2/LibreLane core synthesis and pre-PnR STA backend."""

import argparse
import csv
import hashlib
import json
import math
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import time

STEPS = [
    "Yosys.JsonHeader",
    "Yosys.Synthesis",
    "Checker.YosysUnmappedCells",
    "Checker.YosysSynthChecks",
    "OpenROAD.CheckSDCFiles",
    "OpenROAD.STAPrePNR",
]
LIBRELANE_IMAGE = "ghcr.io/librelane/librelane@sha256:4bc9042ba177f73f275b5b39e7d372a07d3f4043f548a0ba7f640097b7205051"


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def rtl_sources(rtl, core):
    rtl = rtl.resolve()
    child = {"CVA5": "CVA5", "VEX_5S": "VexRiscv_5s", "VEX_4S": "VexRiscv_4s"}[core]
    if (rtl / child / "files.txt").exists():
        rtl /= child
    sources = [
        (rtl / line.strip()).resolve()
        for line in (rtl / "files.txt").read_text().splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    ]
    sources += sorted(rtl.parent.glob("ISAX_*.sv"))
    return list(dict.fromkeys(sources))


def stage_sources(sources, out):
    staged, includes, headers = [], [], {}
    parents = list(dict.fromkeys(p.parent for p in sources))
    for i, parent in enumerate(parents):
        directory = out / "rtl" / str(i)
        directory.mkdir(parents=True)
        includes.append(str(directory))
        for pattern in ("*.vh", "*.svh"):
            for header in parent.rglob(pattern):
                target = directory / header.relative_to(parent)
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(header, target)
                headers[str(header)] = sha(header)
        for source in sources:
            if source.parent == parent:
                target = directory / source.name
                shutil.copyfile(source, target)
                staged.append(str(target))
    return staged, includes, headers


def finite_metric(metrics, key):
    value = metrics.get(key)
    if isinstance(value, bool) or not isinstance(value, (int, float)) or not math.isfinite(value):
        raise ValueError(f"Missing/non-finite required OpenLane metric: {key}")
    return value


def collect_results(out, meta):
    run = out / "runs/asip"
    final = run / "final"
    metrics = json.loads((final / "metrics.json").read_text())
    # A synthesis-only result must never masquerade as a completed STA run.
    sta = list(run.glob("*-openroad-staprepnr/state_out.json"))
    if len(sta) != 1 or not (run / "resolved.json").is_file():
        raise ValueError("Missing completed pre-PnR STA state/resolved configuration")
    json.loads(sta[0].read_text())
    resolved = json.loads((run / "resolved.json").read_text())

    def library_paths(value):
        if isinstance(value, str):
            yield Path(value)
        elif isinstance(value, dict):
            for entry in value.values():
                yield from library_paths(entry)
        elif isinstance(value, list):
            for entry in value:
                yield from library_paths(entry)

    libraries = {str(path): sha(path) for path in library_paths(resolved.get("LIB", {})) if path.is_file()}
    if meta.get("library_files_sha256") and meta["library_files_sha256"] != libraries:
        raise ValueError("OpenLane library hash mismatch")
    meta["library_files_sha256"] = libraries
    for key in ("design__instance_unmapped__count", "synthesis__check_error__count"):
        if finite_metric(metrics, key) != 0:
            raise ValueError(f"Synthesis check failed: {key}")
    area = finite_metric(metrics, "design__instance__area")
    setup = finite_metric(metrics, "timing__setup__ws")
    hold = finite_metric(metrics, "timing__hold__ws")
    if area <= 0:
        raise ValueError("Empty mapped design")
    netlists = [p for p in final.rglob("*.v") if p.is_file()]
    if not netlists:
        raise ValueError("Final mapped netlist missing")
    artifacts = {
        str(p.relative_to(out)): sha(p) for p in [*netlists, final / "metrics.json", sta[0], run / "resolved.json"]
    }
    if meta.get("artifacts_sha256") and meta["artifacts_sha256"] != artifacts:
        raise ValueError("OpenLane artifact hash mismatch")
    meta.update(
        passed=True,
        status="complete",
        artifacts_sha256=artifacts,
        metrics={"cell_area": area, "clock_period_ns": meta["clock_period_ns"], "setup_slack_ns": setup},
        setup_timing_met=setup >= 0,
        hold_timing_met=hold >= 0,
        timing_met=setup >= 0 and hold >= 0,
        hold_wns_ns=min(0, hold),
        raw_metrics=metrics,
        sta_state=str(sta[0].relative_to(out)),
        completed_steps=STEPS,
    )
    for metric, name in (
        ("timing__hold_vio__count", "hold_violating_paths"),
        ("timing__setup_vio__count", "setup_violating_paths"),
    ):
        if metric in metrics:
            meta[name] = finite_metric(metrics, metric)
    meta.pop("error", None)
    (out / "metrics.json").write_text(json.dumps(meta["metrics"], indent=2) + "\n")
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
        writer.writerow([area, "", "", "", "", meta["clock_period_ns"], "MET" if setup >= 0 else "VIOLATED", setup])
    return meta


def run(args):
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=True)
    if (out / "execution.json").exists() or (out / "config.json").exists():
        raise ValueError("Use a fresh output directory for each synthesis run")
    pdk_root = args.pdk_root.resolve()
    pdk = {"sky130": "sky130A", "sky130hd": "sky130A"}.get(args.pdk, args.pdk)
    scl = args.scl or ("sky130_fd_sc_hd" if pdk.startswith("sky130") else None)
    if not scl:
        raise ValueError("Set --scl for a custom/non-Sky130 PDK")
    pdk_config = pdk_root / pdk / "libs.tech/openlane/config.tcl"
    scl_config = pdk_root / pdk / "libs.tech/openlane" / scl / "config.tcl"
    if not pdk_config.is_file() or not scl_config.is_file():
        raise ValueError(f"Missing complete OpenLane PDK configuration: {pdk_config}; install a PDK, not just Liberty")
    sources = rtl_sources(args.rtl, args.core)
    staged, includes, headers = stage_sources(sources, out)
    config = {
        "meta": {"version": 2, "flow": STEPS},
        "DESIGN_NAME": "cva5_top" if args.core == "CVA5" else "top",
        "VERILOG_FILES": staged,
        "VERILOG_INCLUDE_DIRS": includes,
        "CLOCK_PORT": "clk",
        "CLOCK_PERIOD": args.clock_ns,
        "PDK": pdk,
        "STD_CELL_LIBRARY": scl,
        "SYNTH_STRATEGY": args.strategy,
        "IO_DELAY_CONSTRAINT": 20,
        "CLOCK_UNCERTAINTY_CONSTRAINT": 0.25,
        "CLOCK_TRANSITION_CONSTRAINT": 0.15,
        "OUTPUT_CAP_LOAD": 33.4,
    }
    corner = args.corner or ("nom_tt_025C_1v80" if pdk.startswith("sky130") else None)
    if corner:
        config.update(DEFAULT_CORNER=corner, STA_CORNERS=[corner])
    if args.constraints:
        shutil.copyfile(args.constraints, out / "constraints.sdc")
        config.update(PNR_SDC_FILE=str(out / "constraints.sdc"), SIGNOFF_SDC_FILE=str(out / "constraints.sdc"))
    (out / "config.json").write_text(json.dumps(config, indent=2) + "\n")
    meta = {
        "passed": False,
        "status": "running",
        "tool": args.engine,
        "core": args.core,
        "pdk": pdk,
        "scl": scl,
        "clock_period_ns": args.clock_ns,
        "boundary": "core and extension; external RAM excluded",
        "physical_design": False,
        "rtl_sha256": {str(p): sha(p) for p in sources},
        "headers_sha256": headers,
        "config_sha256": sha(out / "config.json"),
        "pdk_root": str(pdk_root),
        "pdk_resolved": str((pdk_root / pdk).resolve()),
        "pdk_config_sha256": {str(p): sha(p) for p in (pdk_config, scl_config)},
        "runner_sha256": sha(Path(__file__)),
        "requested_steps": STEPS,
    }
    container_name = "isaac-asip-" + hashlib.sha256(str(out).encode()).hexdigest()[:16]
    if args.docker_image:
        command = [
            "docker",
            "run",
            "--rm",
            "--name",
            container_name,
            "--network",
            "none",
            "--user",
            f"{os.getuid()}:{os.getgid()}",
            "-e",
            "HOME=/tmp",
            "--mount",
            f"type=bind,source={out},target={out}",
            "--mount",
            f"type=bind,source={args.pdk_mount_source or pdk_root},target={pdk_root},readonly",
            "-w",
            str(out),
            "--entrypoint",
            args.engine,
            args.docker_image,
        ]
        meta["docker_image"] = args.docker_image
    else:
        command = shlex.split(args.command or args.engine)
    version_command = command + ["--version"]
    command += [
        "--manual-pdk",
        "--pdk-root",
        str(pdk_root),
        "--pdk",
        pdk,
        "--scl",
        scl,
        "--run-tag",
        "asip",
        "--jobs",
        str(args.jobs),
        str(out / "config.json"),
    ]
    meta["command"] = command
    (out / "execution.json").write_text(json.dumps(meta, indent=2) + "\n")
    started = time.monotonic()
    try:
        version = subprocess.run(
            version_command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, cwd=out, timeout=60
        )
        (out / "version.log").write_text(version.stdout)
        if version.returncode:
            raise RuntimeError(f"Tool version probe failed ({version.returncode}): {version.stdout}")
        meta["tool_version"] = version.stdout.strip()
        with (out / "tool.log").open("w") as log:
            subprocess.run(command, cwd=out, stdout=log, stderr=subprocess.STDOUT, timeout=args.timeout, check=True)
        collect_results(out, meta)
    except (OSError, ValueError, RuntimeError, subprocess.SubprocessError) as exc:
        meta.update(status="failed", error=str(exc))
        if isinstance(exc, subprocess.TimeoutExpired) and args.docker_image:
            subprocess.run(["docker", "stop", "--time", "5", container_name], capture_output=True, check=False)
    finally:
        meta["elapsed_seconds"] = time.monotonic() - started
        (out / "execution.json").write_text(json.dumps(meta, indent=2) + "\n")
    print(json.dumps({k: v for k, v in meta.items() if k != "raw_metrics"}, indent=2))
    return meta["passed"]


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--rtl", type=Path, required=True)
    p.add_argument("--output", type=Path, required=True)
    p.add_argument("--core", choices=["VEX_5S", "VEX_4S", "CVA5"], default="VEX_5S")
    p.add_argument("--engine", choices=["openlane", "librelane"], default="librelane")
    p.add_argument("--pdk", default="sky130A")
    p.add_argument("--pdk-root", type=Path, required=True)
    p.add_argument("--pdk-mount-source", help="Docker-daemon path alias for the PDK root, if different")
    p.add_argument("--scl")
    p.add_argument("--corner", help="Defaults to Sky130 typical; otherwise uses the installed PDK defaults")
    p.add_argument("--strategy", default="AREA 0")
    p.add_argument("--clock-ns", type=float, default=10)
    p.add_argument("--jobs", type=int, default=4)
    p.add_argument("--timeout", type=float, default=3600)
    p.add_argument("--command", help="Native launcher, e.g. /path/to/python -m openlane")
    p.add_argument("--docker-image", help="Pinned runtime image; executes engine directly inside the image")
    p.add_argument("--constraints", type=Path)
    a = p.parse_args()
    if a.clock_ns <= 0 or a.jobs <= 0 or a.timeout <= 0:
        p.error("Clock, jobs and timeout must be positive")
    if a.command and a.docker_image:
        p.error("Choose a native command or a Docker image")
    raise SystemExit(0 if run(a) else 1)


if __name__ == "__main__":
    main()
