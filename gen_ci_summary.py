import sys
# import re
import argparse
from pathlib import Path

import pandas as pd

parser = argparse.ArgumentParser()

parser.add_argument("exp")
parser.add_argument("--output", "-o", default=None)
parser.add_argument("--fmt", default="auto", choices=["auto", "markdown", "md"])

args = parser.parse_args()
# print("args", args)

exp = Path(args.exp)

if exp.is_file():
    assert exp.name == "experiment.ini"
    exp_dir = exp.parent
else:
    assert exp.is_dir()
    exp_dir = exp

run_dir = exp_dir / "run"
sess_dir = exp_dir / "sess"
work_dir = exp_dir / "work"

exp_ini = exp_dir / "experiment.ini"
vars_env = exp_dir / "vars.env"
times_csv = exp_dir / "times.csv"
compare_csv = exp_dir / "compare.csv"

with open(exp_ini, "r") as f:
    exp_text = f.read()

with open(vars_env, "r") as f:
    vars_text = f.read()

fmt = args.fmt
out_path = Path(args.output) if args.output is not None else None
if args.fmt == "auto":
    assert out_path is not None
    suffix = out_path.suffix
    assert len(suffix) > 1
    fmt = suffix[1:]

compare_df = pd.read_csv(compare_csv, index_col=0)
times_df = pd.read_csv(times_csv)
times_df.drop(columns=["t0", "t1"], inplace=True)
times_df.rename(columns={"label": "Stage", "td": "Diff [s]"}, inplace=True)

content = ""
if fmt in ["md", "markdown"]:
    content += "## Summary\n\n"
    content += f"Directory: `{exp_dir}`\n\n"
    content += "### Experiment\n"
    content += "```ini\n"
    content += exp_text
    content += "```\n\n"
    content += "### Environment/Config\n"
    content += "<details>\n"
    content += "<summary>Vars</summary>\n\n"
    content += "```sh\n"
    content += vars_text
    content += "```\n\n"
    content += "</details>\n\n"
    content += "### Times\n"
    content += "<details>\n"
    content += "<summary>Stages</summary>\n\n"
    times_text = times_df.to_markdown(index=False)
    content += times_text + "\n\n"
    content += "</details>\n\n"
    content += "### Compare DF\n"
    compare_text = compare_df.to_markdown(index=False)
    content += compare_text + "\n\n"
else:
    raise RuntimeError(f"Unsupported format: {fmt}")

if out_path is None:
    print(content)
else:
    with open(out_path, "w") as f:
        f.write(content)
