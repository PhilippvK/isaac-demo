import argparse
from pathlib import Path

import pandas as pd

parser = argparse.ArgumentParser(description="Collect metrics from Vivado Reports")
parser.add_argument("-o", "--output", default=None, help="Output file")
parser.add_argument("--fmt", type=str, choices=["auto", "csv", "pkl", "md"], default="auto", help="Output file format")
parser.add_argument("--print-df", action="store_true", help="Print DataFrame")
parser.add_argument("--baseline-dir", default=None, help="Baseline Syn Dir")
parser.add_argument("--default-dir", default=None, help="Baseline Syn Dir")
parser.add_argument("--shared-dir", default=None, help="Baseline Syn Dir")
args = parser.parse_args()

data = {}

if args.baseline_dir is not None:
    directory = Path(args.baseline_dir)
    assert directory.is_dir()
    util_hier_filtered_csv = directory / ""
    assert util_hier_filtered_csv.is_file()
    util_hier_filtered_df = pd.from_csv(util_hier_filtered_csv)
    print("util_hier_filtered_csv", util_hier_filtered_csv)

if args.default_dir is not None:
    directory = Path(args.default_dir)
    assert directory.is_dir()
    util_hier_filtered_csv = directory / ""
    assert util_hier_filtered_csv.is_file()
    util_hier_filtered_df = pd.from_csv(util_hier_filtered_csv)
    print("util_hier_filtered_csv", util_hier_filtered_csv)

if args.shared_dir is not None:
    directory = Path(args.shared_dir)
    assert directory.is_dir()
    util_hier_filtered_csv = directory / ""
    assert util_hier_filtered_csv.is_file()
    util_hier_filtered_df = pd.from_csv(util_hier_filtered_csv)
    print("util_hier_filtered_csv", util_hier_filtered_csv)

assert len(data) > 0

df = pd.DataFrame([data])

assert args.print_df or args.output is not None

if args.print_df:
    print(df)

if args.output is not None:
    out_path = Path(args.output)

    fmt = args.fmt

    if fmt == "auto":
        fmt = out_path.suffix
        assert len(fmt) > 1
        fmt = fmt[1:].lower()

    if fmt == "csv":
        df.to_csv(out_path, index=False)
    elif fmt == "pkl":
        df.to_pickle(out_path)
    elif fmt == "md":
        df.to_markdown(out_path, index=False)
    else:
        raise ValueError(f"Unsupported fmt: {fmt}")
