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

# TODO: clock period?
# TODO: slack

if args.baseline_dir is not None:
    directory = Path(args.baseline_dir)
    assert directory.is_dir()
    util_hier_filtered_csv = directory / "reports" / "utilization_hier_impl_summary.csv"
    assert util_hier_filtered_csv.is_file()
    util_hier_filtered_df = pd.read_csv(util_hier_filtered_csv)
    total_row = util_hier_filtered_df[util_hier_filtered_df["Module"] == "(top)"]
    assert len(total_row) == 1
    luts_total = total_row["Total LUTs"].iloc[0]
    ffs_total = total_row["FFs"].iloc[0]
    brams_total = total_row[["RAMB18", "RAMB36"]].iloc[0].sum()
    dsps_total = total_row["DSP Blocks"].iloc[0]
    data["baseline"] = {
        "luts_total": luts_total,
        "ffs_total": ffs_total,
        "brams_total": brams_total,
        "dsps_total": dsps_total,
    }

if args.default_dir is not None:
    directory = Path(args.default_dir)
    assert directory.is_dir()
    util_hier_filtered_csv = directory / "reports" / "utilization_hier_impl_summary.csv"
    assert util_hier_filtered_csv.is_file()
    util_hier_filtered_df = pd.read_csv(util_hier_filtered_csv)
    total_row = util_hier_filtered_df[util_hier_filtered_df["Module"] == "(top)"]
    assert len(total_row) == 1
    isax_row = util_hier_filtered_df[util_hier_filtered_df["Module"] == "ISAX_XIsaac"]
    scaiev_row = util_hier_filtered_df[util_hier_filtered_df["Module"] == "SCAL"]
    luts_total = total_row["Total LUTs"].iloc[0]
    ffs_total = total_row["FFs"].iloc[0]
    brams_total = total_row[["RAMB18", "RAMB36"]].iloc[0].sum()
    dsps_total = total_row["DSP Blocks"].iloc[0]
    luts_isax = None
    ffs_isax = None
    brams_isax = None
    dsps_isax = None
    if len(isax_row) > 0:
        assert len(isax_row) == 1
        luts_isax = isax_row["Total LUTs"].iloc[0]
        ffs_isax = isax_row["FFs"].iloc[0]
        brams_isax = isax_row[["RAMB18", "RAMB36"]].iloc[0].sum()
        dsps_isax = isax_row["DSP Blocks"].iloc[0]
    luts_scaiev = None
    ffs_scaiev = None
    brams_scaiev = None
    dsps_scaiev = None
    if len(scaiev_row) > 0:
        assert len(scaiev_row) == 1
        luts_scaiev = scaiev_row["Total LUTs"].iloc[0]
        ffs_scaiev = scaiev_row["FFs"].iloc[0]
        brams_scaiev = scaiev_row[["RAMB18", "RAMB36"]].iloc[0].sum()
        dsps_scaiev = scaiev_row["DSP Blocks"].iloc[0]
    data["default"] = {
        "luts_total": luts_total,
        "ffs_total": ffs_total,
        "brams_total": brams_total,
        "dsps_total": dsps_total,
        "luts_isax": luts_isax,
        "ffs_isax": ffs_isax,
        "brams_isax": brams_isax,
        "dsps_isax": dsps_isax,
        "luts_scaiev": luts_scaiev,
        "ffs_scaiev": ffs_scaiev,
        "brams_scaiev": brams_scaiev,
        "dsps_scaiev": dsps_scaiev,
    }

if args.shared_dir is not None:
    directory = Path(args.shared_dir)
    assert directory.is_dir()
    util_hier_filtered_csv = directory / "reports" / "utilization_hier_impl_summary.csv"
    assert util_hier_filtered_csv.is_file()
    util_hier_filtered_df = pd.read_csv(util_hier_filtered_csv)
    total_row = util_hier_filtered_df[util_hier_filtered_df["Module"] == "(top)"]
    assert len(total_row) == 1
    isax_row = util_hier_filtered_df[util_hier_filtered_df["Module"] == "ISAX_XIsaac"]
    assert len(isax_row) == 1
    scaiev_row = util_hier_filtered_df[util_hier_filtered_df["Module"] == "SCAL"]
    luts_total = total_row["Total LUTs"].iloc[0]
    ffs_total = total_row["FFs"].iloc[0]
    brams_total = total_row[["RAMB18", "RAMB36"]].iloc[0].sum()
    dsps_total = total_row["DSP Blocks"].iloc[0]
    luts_isax = isax_row["Total LUTs"].iloc[0]
    ffs_isax = isax_row["FFs"].iloc[0]
    brams_isax = isax_row[["RAMB18", "RAMB36"]].iloc[0].sum()
    dsps_isax = isax_row["DSP Blocks"].iloc[0]
    luts_scaiev = None
    ffs_scaiev = None
    brams_scaiev = None
    dsps_scaiev = None
    if len(scaiev_row) > 0:
        assert len(scaiev_row) == 1
        luts_scaiev = scaiev_row["Total LUTs"].iloc[0]
        ffs_scaiev = scaiev_row["FFs"].iloc[0]
        brams_scaiev = scaiev_row[["RAMB18", "RAMB36"]].iloc[0].sum()
        dsps_scaiev = scaiev_row["DSP Blocks"].iloc[0]
    data["shared"] = {
        "luts_total": luts_total,
        "ffs_total": ffs_total,
        "brams_total": brams_total,
        "dsps_total": dsps_total,
        "luts_isax": luts_isax,
        "ffs_isax": ffs_isax,
        "brams_isax": brams_isax,
        "dsps_isax": dsps_isax,
        "luts_scaiev": luts_scaiev,
        "ffs_scaiev": ffs_scaiev,
        "brams_scaiev": brams_scaiev,
        "dsps_scaiev": dsps_scaiev,
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
    for metric in ["luts", "ffs", "brams", "dsps"]:
        for component in ["isax", "scaiev"]:
            df[f"{metric}_{component}_rel"] = df[f"{metric}_{component}"] / df[f"{metric}_total"]

if has_baseline and (has_default or has_shared):
    for component in ["total", "isax", "scaiev"]:
        for metric in ["luts", "ffs", "brams", "dsps"]:
            df[f"{metric}_{component}_overhead"] = (
                df[f"{metric}_{component}"] - df[f"{metric}_{component}"].fillna(0).iloc[0]
            )

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
