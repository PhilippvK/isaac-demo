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
    parser.add_argument("--filtered", action="store_true", help="TODO")
    parser.add_argument("--filtered2", action="store_true", help="TODO")
    parser.add_argument("--prelim", action="store_true", help="TODO")
    parser.add_argument("--final", action="store_true", help="TODO")
    # parser.add_argument("--runtime-weight", type=float, default=1.0, help="TODO")
    # parser.add_argument("--code-size-weight", type=float, default=1.0, help="TODO")
    parser.add_argument("--util-weight", type=float, default=1.0, help="TODO")
    parser.add_argument("--enc-weight", type=float, default=1.0, help="TODO")
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
    candidates = combined_index_data["candidates"]
    # print("candidates", candidates)

    score_name = "score"

    if args.filtered:
        assert not (args.final or args.filtered2 or args.prelim)
        score_name = f"filtered_{score_name}"
    if args.filtered2:
        assert not (args.final or args.filtered or args.prelim)
        score_name = f"filtered2_{score_name}"
    if args.prelim:
        assert not (args.final or args.filtered2 or args.filtered)
        score_name = f"prelim_{score_name}"
    if args.final:
        assert not (args.prelim or args.filtered2 or args.filtered)
        score_name = f"final_{score_name}"

    for i, candidate in enumerate(candidates):
        # print("i", i)
        # name = candidate["properties"]["InstrName"]
        metrics = candidate.get("metrics", {})
        # print("metrics", metrics)
        # input("!")
        # runtime_reduction_rel = metrics["runtime_reduction_rel"]
        # code_size_reduction_rel = metrics["code_size_reduction_rel"]
        benefits = []
        costs = []
        util_score = metrics.get("util_score")
        if util_score is not None:
            assert util_score >= 0
            util_score = util_score * args.util_weight
            benefits.append(util_score)

        enc_weight = metrics.get("enc_weight")
        if enc_weight is not None:
            assert enc_weight >= 0
            enc_weight = enc_weight * args.enc_weight
            costs.append(enc_weight)

        assert len(benefits) > 0
        benefits_sum = sum(benefits)

        assert len(costs) > 0
        costs_sum = sum(costs)

        score = benefits_sum / costs_sum
        metrics[score_name] = score
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
