#!/usr/bin/env python3
"""Extract measured Vivado resource use and routed timing for Arty builds."""

import argparse
import hashlib
import json
from pathlib import Path
import re


def extract(build):
    gateware = build / "gateware"
    utilization = gateware / "digilent_arty_utilization_place.rpt"
    timing = gateware / "digilent_arty_timing.rpt"
    hierarchy = gateware / "digilent_arty_utilization_hierarchical_place.rpt"
    text = utilization.read_text()
    result = {}
    for label, name in (("Slice LUTs", "luts"), ("Slice Registers", "flip_flops"),
                        ("Block RAM Tile", "bram_tiles"), ("DSPs", "dsps")):
        match = re.search(r"^\|\s*" + re.escape(label) + r"\s*\|\s*([0-9.]+)\s*\|", text, re.MULTILINE)
        if not match:
            raise ValueError(f"Missing {label} in {utilization}")
        result[name] = float(match[1])
    timing_text = timing.read_text()
    summary = re.search(r"WNS\(ns\)[^\n]*\n[^\n]*\n\s*([^\n]+)", timing_text)
    if not summary:
        raise ValueError("Missing routed timing summary")
    fields = summary[1].split()
    result.update(wns_ns=float(fields[0]), tns_ns=float(fields[1]),
                  whs_ns=float(fields[4]), timing_met="All user specified timing constraints are met." in timing_text)
    clock = re.search(r"^\s*main_crg_clkout0\s+\{[^}]+\}\s+([0-9.]+)\s+([0-9.]+)", timing_text, re.MULTILINE)
    if not clock:
        raise ValueError("Missing implemented system clock constraint")
    result.update(system_period_ns=float(clock[1]), constrained_frequency_mhz=float(clock[2]))
    cfu = re.search(r"^\|\s*Cfu\s*\|\s*Cfu\s*\|([^\n]+)", hierarchy.read_text(), re.MULTILINE)
    if cfu:
        cells = [float(value.strip()) for value in cfu[1].split("|") if value.strip()]
        result["cfu_hierarchy_attribution"] = dict(zip(
            ("luts", "logic_luts", "lutram", "srl", "flip_flops", "ramb36", "ramb18", "dsps"), cells))
    result["report_sha256"] = {str(path.resolve()): hashlib.sha256(path.read_bytes()).hexdigest()
                               for path in (utilization, timing, hierarchy)}
    result["resource_stage"] = "post-placement"
    result["timing_stage"] = "post-route"
    result["frequency_note"] = "Verified constrained frequency when timing_met; no Fmax claim"
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline", type=Path, required=True)
    parser.add_argument("--extended", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    baseline, extended = extract(args.baseline), extract(args.extended)
    if baseline["constrained_frequency_mhz"] != extended["constrained_frequency_mhz"]:
        raise ValueError("Baseline and extended clock constraints differ")
    report = {"baseline": baseline, "extended": extended,
              "extended_minus_baseline": {key: extended[key] - baseline[key]
                   for key in ("luts", "flip_flops", "bram_tiles", "dsps")},
              "hierarchy_note": "Vivado hierarchy attribution can move or combine logic across module boundaries; not standalone CFU cost"}
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report["extended_minus_baseline"], indent=2))
