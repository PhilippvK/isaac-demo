#!/usr/bin/env python3
"""Evaluate matched baseline/ISE RTL for each technology, Nangate first."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import csv
import json
import os
from pathlib import Path
import subprocess
import sys

from run import collect_results, sha

HERE = Path(__file__).resolve().parent
VARIANTS = {"baseline": "baseline", "crc32": "crc32-fixed", "branches": "branches", "stores": "stores-fixed"}
DB_NAMES = {"nangate45": "NangateOpenCellLibrary_typical.db", "sky130hd": "sky130_fd_sc_hd__tt_025C_1v80.db"}


def evaluate(args):
    args.output.mkdir(parents=True, exist_ok=True)
    rows = []
    for pdk in args.pdks:
        # Keep technology stages sequential: establish Nangate first.
        db = args.libraries / pdk / DB_NAMES[pdk]
        if not db.is_file():
            subprocess.run(
                [
                    sys.executable,
                    str(HERE / "prepare_libraries.py"),
                    "--pdk",
                    pdk,
                    "--output",
                    str(args.libraries),
                    "--lc-shell",
                    args.lc_shell,
                ],
                check=True,
            )

        def synthesize(variant):
            out = args.output / pdk / variant
            command = [
                sys.executable,
                str(HERE / "run.py"),
                "--rtl",
                str(args.rtl / VARIANTS[variant]),
                "--output",
                str(out),
                "--pdk",
                pdk,
                "--library",
                str(db),
                "--clock-ns",
                str(args.clock_ns),
                "--jobs",
                str(args.jobs),
                "--dc-shell",
                args.dc_shell,
            ]
            out.parent.mkdir(parents=True, exist_ok=True)
            if args.resume and (out / "execution.json").is_file():
                meta = json.loads((out / "execution.json").read_text())
                if meta["library_sha256"] != sha(db) or meta["clock_period_ns"] != args.clock_ns:
                    raise ValueError("Resume library or clock does not match")
                if any(sha(Path(path)) != digest for path, digest in meta["rtl_sha256"].items()):
                    raise ValueError("Resume RTL source hash mismatch")
                for name, key in (
                    ("synthesize.tcl", "synthesis_script_sha256"),
                    ("constraints.tcl", "constraints_sha256"),
                ):
                    if sha(out / name) != meta[key]:
                        raise ValueError(f"Resume {name} hash mismatch")
                collect_results(out, meta)
                meta["reports_revalidated"] = True
                (out / "execution.json").write_text(json.dumps(meta, indent=2) + "\n")
            else:
                with (out.parent / (variant + ".log")).open("w") as log:
                    subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)
                meta = json.loads((out / "execution.json").read_text())
            return {
                "pdk": pdk,
                "variant": variant,
                **meta["metrics"],
                "hold_wns_ns": meta.get("hold_wns_ns"),
                "hold_violating_paths": meta.get("hold_violating_paths"),
                "setup_timing_met": meta["setup_timing_met"],
                "hold_timing_met": meta["hold_timing_met"],
                "timing_met": meta["timing_met"],
            }

        with ThreadPoolExecutor(max_workers=args.parallel) as pool:
            current = list(pool.map(synthesize, args.variants))
        baseline = next((x for x in current if x["variant"] == "baseline"), None)
        for row in current:
            if baseline:
                row["area_ratio"] = row["cell_area"] / baseline["cell_area"]
        rows += current
        (args.output / "summary.json").write_text(json.dumps(rows, indent=2) + "\n")
        with (args.output / "summary.csv").open("w") as stream:
            writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
            writer.writeheader()
            writer.writerows(rows)
        print(json.dumps(current, indent=2), flush=True)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--rtl", type=Path, required=True, help="HLS root with baseline/crc32-fixed/etc.")
    p.add_argument("--output", type=Path, required=True)
    p.add_argument("--libraries", type=Path, default=Path("install/asip-libs"))
    p.add_argument("--pdks", nargs="+", choices=DB_NAMES, default=list(DB_NAMES))
    p.add_argument("--variants", nargs="+", choices=VARIANTS, default=list(VARIANTS))
    p.add_argument("--resume", action="store_true", help="Revalidate and reuse complete synthesis outputs")
    p.add_argument("--clock-ns", type=float, default=10)
    p.add_argument("--jobs", type=int, default=4)
    p.add_argument("--parallel", type=int, default=2)
    p.add_argument("--dc-shell", default=os.environ.get("ASIP_SYN_DC_SHELL", "dc_shell"))
    p.add_argument("--lc-shell", default=os.environ.get("ASIP_SYN_LC_SHELL", "lc_shell"))
    args = p.parse_args()
    if args.clock_ns <= 0 or args.parallel <= 0 or args.jobs <= 0:
        p.error("Clock period and worker counts must be positive")
    evaluate(args)


if __name__ == "__main__":
    main()
