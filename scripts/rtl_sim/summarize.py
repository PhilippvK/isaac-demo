#!/usr/bin/env python3
"""Collect benchmark checks and MLIF measurement regions from RTL runs."""

import argparse
import csv
import json
from pathlib import Path
import re


def summarize(root, variants=None):
    paths = (
        [root / v / "execution.json" for v in variants]
        if variants
        else sorted(root.glob("*/execution.json"))
    )
    results = {}
    for path in paths:
        result = (
            json.loads(path.read_text())
            if path.exists()
            else {"passed": False, "error": "Missing execution report"}
        )
        uart = (
            (path.parent / "uart.log").read_text(errors="replace")
            if (path.parent / "uart.log").exists()
            else ""
        )
        result["benchmark_metrics"] = {
            name: int(value)
            for name, value in re.findall(r"^# ([^:]+): (\d+)$", uart, re.M)
        }
        result["benchmark_verified"] = bool(
            result["passed"] and "MLONMCU EXIT: 0" in uart
        )
        results[path.parent.name] = result
    summary = {
        "variants": results,
        "passed": bool(results)
        and all(x["benchmark_verified"] for x in results.values()),
    }
    if "baseline" in results:
        base = results["baseline"]["benchmark_metrics"].get("Run Cycles")
        for value in results.values():
            cycles = value["benchmark_metrics"].get("Run Cycles")
            if base and cycles:
                value["run_cycle_reduction"] = 1 - cycles / base
    (root / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    with (root / "metrics.csv").open("w") as stream:
        writer = csv.writer(stream)
        writer.writerow(
            [
                "Variant",
                "Verified",
                "Run Cycles",
                "Run Instructions",
                "Run Cycle Reduction",
            ]
        )
        for name, result in results.items():
            metrics = result["benchmark_metrics"]
            writer.writerow(
                [
                    name,
                    result["benchmark_verified"],
                    metrics.get("Run Cycles"),
                    metrics.get("Run Instructions"),
                    result.get("run_cycle_reduction"),
                ]
            )
    print(
        json.dumps(
            {
                k: {
                    "verified": v["benchmark_verified"],
                    "metrics": v["benchmark_metrics"],
                }
                for k, v in results.items()
            },
            indent=2,
        )
    )
    return summary["passed"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=Path)
    parser.add_argument("--variants", nargs="+")
    args = parser.parse_args()
    raise SystemExit(0 if summarize(args.root, args.variants) else 1)


if __name__ == "__main__":
    main()
