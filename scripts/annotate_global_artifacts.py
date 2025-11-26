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
    parser.add_argument("--data", action="append", help="TODO")
    args = parser.parse_args()

    # print("data", args.data)
    mapping = dict([tuple(x.split("=", 1)) for x in args.data])
    # print("mapping", mapping)

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
    # candidates = combined_index_data["candidates"]
    # print("candidates", candidates)
    if isinstance(combined_index_data["global"]["artifacts"], list):
        assert len(combined_index_data["global"]["artifacts"]) == 0
        combined_index_data["global"]["artifacts"] = {}
    combined_index_data["global"]["artifacts"].update(mapping)

    if args.inplace:
        assert args.output is None
        out_file = args.index
    else:
        assert args.output is not None
        out_file = args.output

    with open(out_file, "w") as f:
        yaml.dump(combined_index_data, f)


if __name__ == "__main__":
    main()
