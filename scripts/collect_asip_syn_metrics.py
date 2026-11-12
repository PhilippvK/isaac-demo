import argparse
import json
from pathlib import Path

import pandas as pd

parser = argparse.ArgumentParser(description="Collect metrics from Vivado Reports")
parser.add_argument("-o", "--output", default=None, help="Output file")
parser.add_argument("--fmt", type=str, choices=["auto", "csv", "pkl", "md"], default="auto", help="Output file format")
parser.add_argument("--print-df", action="store_true", help="Print DataFrame")
parser.add_argument("--baseline-dir", default=None, help="Baseline Syn Dir")
parser.add_argument("--default-dir", default=None, help="Baseline Syn Dir")
parser.add_argument("--shared-dir", default=None, help="Baseline Syn Dir")
parser.add_argument("--expected-tool")
parser.add_argument("--expected-pdk")
parser.add_argument("--expected-clock-ns", type=float)
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


def canonical_tool(value):
    return {"dc": "synopsys", "ol2": "openlane", "openlane2": "openlane"}.get(value, value)


# Preserve backend identity and timing in the normal full-flow report.
for label, directory in (("baseline", args.baseline_dir), ("default", args.default_dir), ("shared", args.shared_dir)):
    if directory is None:
        continue
    report = Path(directory) / "execution.json"
    if report.is_file():
        meta = json.loads(report.read_text())
        if not meta.get("passed"):
            raise ValueError(f"Cannot collect a failed synthesis run: {directory}")
        tool = canonical_tool(meta.get("tool", "synopsys"))
        if args.expected_tool and tool != canonical_tool(args.expected_tool):
            raise ValueError(f"Baseline/variant backend does not match requested tool: {directory}")
        if args.expected_pdk:
            aliases = (
                {"sky130": "sky130A", "sky130hd": "sky130A"}
                if tool != "synopsys"
                else {"sky130": "sky130hd", "NangateOpenCellLibrary": "nangate45"}
            )
            expected_pdk = aliases.get(args.expected_pdk, args.expected_pdk)
            if meta.get("pdk") != expected_pdk:
                raise ValueError(f"Baseline/variant PDK does not match requested PDK: {directory}")
        if args.expected_clock_ns is not None and meta.get("clock_period_ns") != args.expected_clock_ns:
            raise ValueError(f"Baseline/variant clock does not match requested clock: {directory}")
        data[label].update(
            tool=meta.get("tool", "synopsys"),
            pdk=meta.get("pdk"),
            clock_period_ns=meta.get("clock_period_ns"),
            setup_slack_ns=meta.get("metrics", {}).get("setup_slack_ns"),
            hold_wns_ns=meta.get("hold_wns_ns"),
            setup_timing_met=meta.get("setup_timing_met"),
            hold_timing_met=meta.get("hold_timing_met"),
            timing_met=meta.get("timing_met"),
        )
    elif args.expected_tool:
        raise ValueError(f"Reusable baseline requires execution metadata: {directory}")
for field in ("tool", "pdk", "clock_period_ns"):
    values = {row[field] for row in data.values() if row.get(field) is not None}
    if len(values) > 1:
        raise ValueError(f"Incompatible {field} across synthesis variants: {values}")

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
