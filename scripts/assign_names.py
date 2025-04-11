import argparse
from pathlib import Path
from typing import Dict, Optional

import matplotlib.pyplot as plt
import pandas as pd
import yaml


def main():
    parser = argparse.ArgumentParser(description="TODO")
    parser.add_argument("index", help="Index yaml file")
    parser.add_argument("-o", "--output", default=None, help="Output yaml file")
    parser.add_argument("--inplace", action="store_true", help="TODO")
    parser.add_argument("--prefix", default="CUSTOM", help="TODO")
    parser.add_argument("--csv", default=None, help="TODO")
    parser.add_argument("--pkl", default=None, help="TODO")
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
    candidates = combined_index_data["candidates"]
    # num_candidates = len(candidates)
    print("candidates", candidates)

    names_data = []

    for i, candidate in enumerate(candidates):
        print("i", i)
        properties = candidate.get("properties", {})
        print("properties", properties)
        new_name = f"{args.prefix}{i}"
        properties["InstrName"] = new_name
        candidate["properties"] = properties
        num_fused_instrs = properties["#Instrs"]
        new_data = {"instr": new_name, "instr_lower": new_name.lower(), "idx": i, "num_fused_instrs": num_fused_instrs}
        names_data.append(new_data)

    names_df = pd.DataFrame(names_data)
    print(names_df)

    if args.csv is not None:
        names_df.to_csv(args.csv, index=False)

    if args.pkl is not None:
        names_df.to_pickle(args.pkl)

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
