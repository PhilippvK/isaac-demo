import argparse
from pathlib import Path
from collections import defaultdict
from typing import Dict, Optional

import matplotlib.pyplot as plt
import pandas as pd
import yaml


def main():
    parser = argparse.ArgumentParser(description="TODO")
    parser.add_argument("util_score_csv", nargs="+", help="CSV files")
    parser.add_argument("-o", "--output", default=None, help="Output CSV file")
    args = parser.parse_args()

    dfs = []

    for score_csv in args.util_score_csv:
        df_ = pd.read_csv(score_csv)
        dfs.append(df_)

    df = pd.concat(dfs)
    print("df", df)

    df = df.groupby("instr").sum().reset_index()
    # df = df.sort_values("util_score", ascending=False)
    df = df.sort_values("dynamic_util_score", ascending=False)
    print("df", df)

    if args.output is None:
        print(df)
    else:
        df.to_csv(args.output, index=False)


if __name__ == "__main__":
    main()
