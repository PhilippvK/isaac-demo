import argparse
from pathlib import Path

import yaml
import pandas as pd

parser = argparse.ArgumentParser(description="Collect reuse metrics from MLonMCU Report")
parser.add_argument("report", help="Report CSV file")
parser.add_argument("--mem-report", default=None, help="Memory report CSV file")
# parser.add_argument("--mem", action="store_true", help="Compare mem instead of Runtime")
# parser.add_argument("-i", "--isax", default="auto", help="ISAX name")
parser.add_argument("-o", "--output", default=None, help="Output file")
parser.add_argument("--print-df", action="store_true", help="Print DataFrame")
args = parser.parse_args()

COLS = ["Model", "Arch", "Run Instructions", "Run Instructions (rel.)"]
MEM_COLS = ["Model", "Arch", "Total ROM", "Total RAM", "ROM code", "ROM code (rel.)"]
COMMON_COLS = list(set(COLS) & set(MEM_COLS))

report_file = Path(args.report)
assert report_file.is_file()
report_df = pd.read_csv(report_file)[COLS]
# print(report_df, report_df.columns)

if args.mem_report:
    mem_report_file = Path(args.mem_report)
    assert mem_report_file.is_file()
    mem_report_df = pd.read_csv(mem_report_file)[MEM_COLS]
    # print(mem_report_df, mem_report_df.columns)
    report_df = report_df.merge(mem_report_df, on=COMMON_COLS)

# print(report_df, report_df.columns)

df = report_df

assert args.print_df or args.output is not None

if args.print_df:
    with pd.option_context("display.max_columns", None):
        print(df)

if args.output is not None:
    # TODO: assert csv suffix?
    df.to_csv(args.output)
