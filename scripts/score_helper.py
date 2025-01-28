import argparse
from typing import Union, List, Optional
from pathlib import Path

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
        combined_score_df = combined_score_df.merge(seal5_score_df)
    return combined_score_df


def main():
    parser = argparse.ArgumentParser(description="Combine scores into single CSV")
    parser.add_argument("-o", "--output", default=None, help="Output CSV file")
    parser.add_argument("--names-csv", default=None, help="Names csv file")
    parser.add_argument("--seal5-score-csv", default=None, help="Seal5 score csv file")
    args = parser.parse_args()

    names_df = pd.read_csv(args.names_csv) if args.names_csv is not None else None
    seal5_score_df = pd.read_csv(args.seal5_score_csv) if args.seal5_score_csv is not None else None

    combined_score_df = get_combined_score_df(
        names_df=names_df,
        seal5_score_df=seal5_score_df,
    )
    print("Combined Score DF:")

    if args.output is None:
        print(combined_score_df)
    else:
        combined_score_df.to_csv(args.output, index=False)


if __name__ == "__main__":
    main()
