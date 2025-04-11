import argparse
from typing import Dict, Optional

import matplotlib.pyplot as plt
import pandas as pd
import yaml


def main():
    parser = argparse.ArgumentParser(description="TODO")
    parser.add_argument("-o", "--output", default=None, help="Output csv file")
    parser.add_argument("--dynamic-counts-custom-pkl", required=True, help="TODO")
    parser.add_argument("--static-counts-custom-pkl", required=True, help="TODO")
    parser.add_argument("--dynamic-weight", type=float, default=1.0, help="TODO")
    parser.add_argument("--static-weight", type=float, default=1.0, help="TODO")
    args = parser.parse_args()

    dynamic_counts_custom_df = pd.read_pickle(args.dynamic_counts_custom_pkl)
    print("dynamic_counts_custom_df", dynamic_counts_custom_df)
    static_counts_custom_df = pd.read_pickle(args.static_counts_custom_pkl)
    print("static_counts_custom_df", static_counts_custom_df)

    merged_df = pd.merge(
        dynamic_counts_custom_df, static_counts_custom_df, how="inner", on="instr", suffixes=("_dynamic", "_static")
    )
    merged_df["dynamic_util_score"] = merged_df["estimated_reduction_rel_dynamic"]
    merged_df["static_util_score"] = merged_df["estimated_reduction_rel_static"]
    merged_df["util_score"] = (
        merged_df["dynamic_util_score"] * args.dynamic_weight + merged_df["static_util_score"] * args.static_weight
    )
    merged_df = merged_df[~pd.isna(merged_df["instr"])]
    print("merged_df", merged_df)

    assert args.output is not None
    out_file = args.output

    score_df = merged_df[["instr", "dynamic_util_score", "static_util_score", "util_score"]].fillna(0)
    print("score_df", score_df)
    score_df.to_csv(out_file, index=False)


if __name__ == "__main__":
    main()
