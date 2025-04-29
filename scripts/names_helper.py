import argparse

import yaml
import pandas as pd


def main():
    parser = argparse.ArgumentParser(description="Extract instr names from index YAML and write to CSV")
    parser.add_argument("index", help="Index yaml file")
    parser.add_argument("-o", "--output", default=None, help="Output CSV file")
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
        # TODO: index and cdsl should use the same instruction names?
        names = [
            candidate["properties"].get("InstrName", f"CUSTOM{i}")
            for i, candidate in enumerate(combined_index_data["candidates"])
        ]
        print("names", names)
        # num_candidates = len(names)
        names_df = pd.DataFrame({"instr": names})
        names_df["instr_lower"] = names_df["instr"].apply(lambda x: x.lower())
        names_df["idx"] = names_df["instr"].apply(lambda x: names.index(x))

    if args.output is None:
        print(names_df)
    else:
        names_df.to_csv(args.output, index=False)


if __name__ == "__main__":
    main()
