import argparse
from typing import Union, List, Optional
from pathlib import Path

import yaml
import pandas as pd


def get_combined_score_df(
    names_df: pd.DataFrame,
    seal5_score_df: Optional[pd.DataFrame] = None,
    mlonmcu_score_df: Optional[pd.DataFrame] = None,
    static_counts_score_df: Optional[pd.DataFrame] = None,
    dyn_counts_score_df: Optional[pd.DataFrame] = None,
    static_enc_score_df: Optional[pd.DataFrame] = None,
):
    assert names_df is not None
    combined_score_df = names_df[["instr", "instr_lower"]]
    if seal5_score_df is not None:
        combined_score_df.merge(seal5_score_df)
    return combined_score_df


def main():
    parser = argparse.ArgumentParser(description="Extract instr names from index YAML and write to CSV")
    parser.add_argument("index", help="Index yaml file")
    parser.add_argument("-o", "--output", default=None, help="Output CSV file")
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
        # TODO: index and cdsl should use the same instruction names?
        names = [f"CUSTOM{i}" for i, candidate in enumerate(combined_index_data["candidates"])]
        # num_candidates = len(names)
        names_df = pd.DataFrame({"instr": names})
        names_df["instr_lower"] = names_df["instr"].apply(lambda x: x.lower())

    if args.output is None:
        print(names_df)
    else:
        names_df.to_csv(args.output, index=False)


if __name__ == "__main__":
    main()
