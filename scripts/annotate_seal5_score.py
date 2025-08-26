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
    parser.add_argument("--seal5-score-csv", required=True, help="TODO")
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
    candidates = combined_index_data["candidates"]
    # print("candidates", candidates)

    scores_df = pd.read_csv(args.seal5_score_csv)
    # print("scores_df", scores_df)
    assert len(candidates) == len(scores_df)

    for i, candidate in enumerate(candidates):
        # print("i", i)
        name = candidate["properties"]["InstrName"]
        instr_row = scores_df[scores_df["instr"] == name]
        assert len(instr_row) == 1
        seal5_score = float(instr_row["seal5_score"].iloc[0])
        metrics = candidate.get("metrics", {})
        # print("metrics", metrics)
        metrics["seal5_score"] = seal5_score
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
