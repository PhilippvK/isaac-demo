import argparse
from pathlib import Path

import pandas as pd


def main():
    parser = argparse.ArgumentParser(description="TODO")
    parser.add_argument("input", help="Input pkl file")
    parser.add_argument("--output", "-o", help="Output pkl file")
    parser.add_argument("--names-csv", required=True, help="Output pkl file")
    args = parser.parse_args()

    assert Path(args.input).is_file()
    ise_instrs_df_old = pd.read_pickle(args.input)
    # print("ise_instrs_df_old", ise_instrs_df_old)

    assert Path(args.names_csv).is_file()
    names_df = pd.read_csv(args.names_csv)
    # print("names_df", names_df)

    assert args.output is not None
    out_file = args.output

    ise_instrs_df_new = pd.merge(names_df, ise_instrs_df_old, how="inner", on="instr", suffixes=("_", ""))
    # print("ise_instrs_df_new", ise_instrs_df_new)

    ise_instrs_df_new.to_pickle(out_file)


if __name__ == "__main__":
    main()
