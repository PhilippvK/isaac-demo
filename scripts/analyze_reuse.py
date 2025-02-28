import argparse
from pathlib import Path

import pandas as pd

parser = argparse.ArgumentParser(description="Collect reuse metrics from MLonMCU Report")
parser.add_argument("report", help="Report CSV file")
parser.add_argument("--mem", action="store_true", help="Compare mem instead of Runtime")
# parser.add_argument("-i", "--isax", default="auto", help="ISAX name")
parser.add_argument("-o", "--output", default=None, help="Output file")
parser.add_argument("--print-df", action="store_true", help="Print DataFrame")
args = parser.parse_args()

report_file = Path(args.report)

COL = "Run Instructions (rel.)" if not args.mem else "ROM code (rel.)"

assert report_file.is_file()

report_df = pd.read_csv(report_file)

# print(report_df, report_df.columns)

report_len = len(report_df)

assert report_len % 2 == 0

num_progs = report_len // 2
# print("num_progs", num_progs)

isax_report_df = report_df.iloc[1::2]

isax_report_df[f"{COL}2"] = 1 - isax_report_df[COL]
# print(isax_report_df[["Model", COL, f"{COL}2"]])

isax_progs_df = isax_report_df[isax_report_df[COL] != 1.0]
isax_progs_df_good = isax_report_df[isax_report_df[COL] < 1.0]
isax_progs_df_bad = isax_report_df[isax_report_df[COL] > 1.0]
isax_progs = isax_progs_df["Model"].unique()
isax_progs_good = isax_progs_df_good["Model"].unique()
isax_progs_bad = isax_progs_df_bad["Model"].unique()
num_isax_progs = len(isax_progs)
num_isax_progs_rel = num_isax_progs / num_progs
num_isax_progs_good = len(isax_progs_good)
num_isax_progs_good_rel = num_isax_progs_good / num_progs
num_isax_progs_bad = len(isax_progs_bad)
num_isax_progs_bad_rel = num_isax_progs_bad / num_progs
# print("isax_progs", isax_progs, num_isax_progs, num_isax_progs_rel)
# print("isax_progs_good", isax_progs_good, num_isax_progs_good, num_isax_progs_good_rel)
# print("isax_progs_bad", isax_progs_bad, num_isax_progs_bad, num_isax_progs_bad_rel)

if args.mem:
    total_code_reduction = isax_progs_df_good[f"{COL}2"].sum()
    avg_code_reduction = isax_progs_df_good[f"{COL}2"].mean()
    max_code_reduction = isax_progs_df_good[f"{COL}2"].max()
    # print("total_code_reduction", total_code_reduction)
    # print("avg_code_reduction", avg_code_reduction)
    # print("max_code_reduction", max_code_reduction)
    extra_metrics = {
        "total_code_reduction": total_code_reduction,
        "avg_code_reduction": avg_code_reduction,
        "max_code_reduction": max_code_reduction,
    }
else:
    total_speedup = isax_progs_df_good[f"{COL}2"].sum()
    avg_speedup = isax_progs_df_good[f"{COL}2"].mean()
    max_speedup = isax_progs_df_good[f"{COL}2"].max()
    # print("total_speedup", total_speedup)
    # print("avg_speedup", avg_speedup)
    # print("max_speedup", max_speedup)
    extra_metrics = {"total_speedup": total_speedup, "avg_speedup": avg_speedup, "max_speedup": max_speedup}

data = {
    "num_progs": num_progs,
    "num_isax_progs": num_isax_progs,
    "num_isax_progs_rel": num_isax_progs_rel,
    "num_isax_progs_good": num_isax_progs_good,
    "num_isax_progs_good_rel": num_isax_progs_good_rel,
    "num_isax_progs_bad": num_isax_progs_bad,
    "num_isax_progs_bad_rel": num_isax_progs_bad_rel,
    **extra_metrics,
}

df = pd.DataFrame([data])

assert args.print_df or args.output is not None

if args.print_df:
    with pd.option_context("display.max_columns", None):
        print(df)

if args.output is not None:
    # TODO: assert csv suffix?
    df.to_csv(args.output)
