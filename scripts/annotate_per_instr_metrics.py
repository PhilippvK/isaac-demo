import argparse
from typing import Dict, Optional

import matplotlib.pyplot as plt
import pandas as pd
import yaml


def main():
    parser = argparse.ArgumentParser(description="TODO")
    parser.add_argument("index", help="Index yaml file")
    parser.add_argument("-o", "--output", default=None, help="Output yaml file")
    parser.add_argument("--inplace", action="store_true", help="TODO")
    parser.add_argument("--report", required=True, help="TODO")
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
    candidates = combined_index_data["candidates"]
    print("candidates", candidates)

    report_df = pd.read_csv(args.report)
    print("report_df", report_df)
    assert len(candidates) == (len(report_df) - 1)

    for i, candidate in enumerate(candidates):
        print("i", i)
        run_instrs_rel_col = "Run Instructions (rel.)"
        rom_code_rel_col = "ROM code (rel.)"
        run_instrs_rel = float(report_df[run_instrs_rel_col].iloc[i + 1])
        rom_code_rel = float(report_df[rom_code_rel_col].iloc[i + 1])
        metrics = candidate.get("metrics", {})
        print("metrics", metrics)
        metrics["runtime_reduction_rel"] = 1 - run_instrs_rel
        metrics["code_size_reduction_rel"] = 1 - rom_code_rel
        print("metrics2", metrics)
        candidate["metrics"] = metrics

    if args.inplace:
        assert args.output is None
        out_file = args.index
    else:
        assert args.output is not None
        out_file = args.output

    combined_index_data["candidates"] = candidates

    with open(out_file, "w") as f:
        yaml.dump(combined_index_data, f)


if __name__ == "__main__":
    main()
