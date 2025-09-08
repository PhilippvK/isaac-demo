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
    parser.add_argument("--multi", action="store_true", help="Multi-benchmark flag")
    parser.add_argument(
        "--multi-agg-func", default="sum", choices=["sum", "mean", "max", "min"], help="Multi-benchmark agg func"
    )
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
    candidates = combined_index_data["candidates"]
    # print("candidates", candidates)

    report_df = pd.read_csv(args.report)
    # print("report_df", report_df)
    run_instrs_rel_col = "Run Instructions (rel.)"
    rom_code_rel_col = "ROM code (rel.)"
    has_mem = rom_code_rel_col in report_df.columns
    report_df["runtime_reduction_rel"] = (report_df[run_instrs_rel_col] * -1) + 1
    if has_mem:
        report_df["code_size_reduction_rel"] = (report_df[rom_code_rel_col] * -1) + 1
    if args.multi:
        progs = list(report_df["Model"].unique())
        # print("progs", progs)
        assert ((len(candidates) + 1) * len(progs)) == len(report_df)
        for i, candidate in enumerate(candidates):
            # print("i", i)
            candidate_rows = report_df.iloc[1 + i :: (len(candidates) + 1)]
            # print("candidate_rows", candidate_rows)
            metrics = candidate.get("metrics", {})
            # print("metrics", metrics)
            # metrics["runtime_reduction_rel"] = 1 - run_instrs_rel
            # metrics["code_size_reduction_rel"] = 1 - rom_code_rel
            metrics["multi_runtime_reduction_rel"] = float(
                candidate_rows["runtime_reduction_rel"].agg(args.multi_agg_func)
            )
            if has_mem:
                metrics["multi_code_size_reduction_rel"] = float(
                    candidate_rows["code_size_reduction_rel"].agg(args.multi_agg_func)
                )
            # print("metrics2", metrics)
            candidate["metrics"] = metrics
            # input("!!!")
    else:
        assert len(candidates) == (len(report_df) - 1)

        for i, candidate in enumerate(candidates):
            # print("i", i)
            # run_instrs_rel = float(report_df[run_instrs_rel_col].iloc[i + 1])
            # rom_code_rel = float(report_df[rom_code_rel_col].iloc[i + 1])
            metrics = candidate.get("metrics", {})
            # print("metrics", metrics)
            # metrics["runtime_reduction_rel"] = 1 - run_instrs_rel
            # metrics["code_size_reduction_rel"] = 1 - rom_code_rel
            metrics["runtime_reduction_rel"] = float(report_df["runtime_reduction_rel"].iloc[i + 1])
            if has_mem:
                metrics["code_size_reduction_rel"] = float(report_df["code_size_reduction_rel"].iloc[i + 1])
            # print("metrics2", metrics)
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
