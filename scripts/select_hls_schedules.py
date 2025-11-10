#!/usr/bin/env python3
import argparse
import csv
import re
import yaml
from collections import defaultdict

def parse_args():
    parser = argparse.ArgumentParser(description="Select HLS schedules per sharing group.")
    parser.add_argument("csv_file", help="Input schedules CSV file")
    parser.add_argument("--output", required=True, help="Output YAML file")
    parser.add_argument("--prefer-ii", nargs="+", type=int, required=True,
                        help="Preferred II values in order of priority")
    parser.add_argument("--allow-fallback", action="store_true",
                        help="Allow heuristic fallback solutions if no preferred II match is found")
    return parser.parse_args()

def extract_sharing_group(config):
    match = re.search(r"SG_(\d+)_SOL_IDX_(\d+)", config)
    if not match:
        raise ValueError(f"Cannot parse sharing group from config: {config}")
    sharing_group = int(match.group(1))
    solution_idx = int(match.group(2))
    return sharing_group, solution_idx

def select_solutions(rows, prefer_ii, allow_fallback):
    grouped = defaultdict(list)
    for row in rows:
        sg, sol_idx = extract_sharing_group(row["config"])
        grouped[sg].append({
            "sharing_group": sg,
            "solution_idx": sol_idx,
            "II": int(row["II"]),
            "Fallback": row["Fallback"].strip().lower() == "true"
        })

    selected = []
    for sg, solutions in sorted(grouped.items()):
        chosen = None

        # Try to match preferred II order
        for ii in prefer_ii:
            match = next((s for s in solutions if s["II"] == ii and not s["Fallback"]), None)
            if match:
                chosen = match
                break

        # If still nothing found
        if not chosen:
            if allow_fallback:
                chosen = next((s for s in solutions if s["Fallback"]), None)
            if not chosen:
                # Default to solution_idx = 0 if exists
                chosen = next((s for s in solutions if s["solution_idx"] == 0), None)

        if not chosen:
            raise RuntimeError(f"No valid solution found for sharing group {sg}")

        selected.append({
            "sharing_group": sg,
            "solution_idx": chosen["solution_idx"]
        })

    return selected

def main():
    args = parse_args()

    with open(args.csv_file, newline="") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    selected = select_solutions(rows, args.prefer_ii, args.allow_fallback)

    with open(args.output, "w") as f:
        yaml.dump(selected, f, sort_keys=False)

if __name__ == "__main__":
    main()

