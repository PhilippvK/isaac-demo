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
    metrics_csv = directory / "metrics.csv"
    assert metrics_csv.is_file()
    metrics_df = pd.read_csv(metrics_csv)
    assert len(metrics_df) == 1
    area_total = metrics_df["total_cell_area"].iloc[0]
    data["baseline"] = {
        "area_total": area_total,
    }

if args.default_dir is not None:
    directory = Path(args.default_dir)
    assert directory.is_dir()
    metrics_csv = directory / "metrics.csv"
    assert metrics_csv.is_file()
    metrics_df = pd.read_csv(metrics_csv)
    assert len(metrics_df) == 1
    area_total = metrics_df["total_cell_area"].iloc[0]
    area_isax = metrics_df["isax_area"].iloc[0]
    area_scaiev = metrics_df["scaiev_area"].iloc[0] if "scaiev_area" in metrics_df.columns else None
    data["default"] = {
        "area_total": area_total,
        "area_isax": area_isax,
        "area_scaiev": area_scaiev,
    }

if args.shared_dir is not None:
    directory = Path(args.shared_dir)
    assert directory.is_dir()
    metrics_csv = directory / "metrics.csv"
    assert metrics_csv.is_file()
    metrics_df = pd.read_csv(metrics_csv)
    assert len(metrics_df) == 1
    area_total = metrics_df["total_cell_area"].iloc[0]
    area_isax = metrics_df["isax_area"].iloc[0]
    area_scaiev = metrics_df["scaiev_area"].iloc[0] if "scaiev_area" in metrics_df.columns else None
    data["shared"] = {
        "area_total": area_total,
        "area_isax": area_isax,
        "area_scaiev": area_scaiev,
    }

assert len(data) > 0

# print("data", data)
has_baseline = "baseline" in data
has_default = "default" in data
has_shared = "shared" in data

data = [{"variant": variant, **variant_data} for variant, variant_data in data.items()]


# print("data", data)

df = pd.DataFrame(data)


if has_default or has_shared:
    for metric in ["area"]:
        for component in ["isax", "scaiev"]:
            df[f"{metric}_{component}_rel"] = df[f"{metric}_{component}"] / df[f"{metric}_total"]

if has_baseline and (has_default or has_shared):
    for component in ["total", "isax", "scaiev"]:
        for metric in ["area"]:
            df[f"{metric}_{component}_overhead"] = (
                df[f"{metric}_{component}"] - df[f"{metric}_{component}"].fillna(0).iloc[0]
            )
            df[f"{metric}_{component}_overhead_rel"] = (
                df[f"{metric}_{component}_overhead"] / df[f"{metric}_{component}"].fillna(0).iloc[0]
            )
print(df)

assert args.print_df or args.output is not None

if args.print_df:
    with pd.option_context("display.max_columns", None):
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
