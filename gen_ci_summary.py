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
times_csv_md = exp_dir / "times.csv.md"
compare_csv = exp_dir / "compare.csv"
ise_potential_pkl = sess_dir / "table" / "ise_potential.pkl"
choices_summary_min_html = exp_dir / "choices_summary_min.html"
sankey_md = work_dir / "sankey.md"
sankey_filtered_md = work_dir / "sankey_filtered.md"
combined_query_metrics_csv = work_dir / "combined_query_metrics.csv"

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

compare_df = None
if compare_csv.is_file():
    compare_df = pd.read_csv(compare_csv, index_col=0)

ise_potential_df = None
if ise_potential_pkl.is_file():
    ise_potential_df = pd.read_pickle(ise_potential_pkl)


choices_summary = None
if choices_summary_min_html.is_file():
    with open(choices_summary_min_html, "r") as f:
        choices_summary = f.read()

combined_query_metrics_df = None
if combined_query_metrics_csv.is_file():
    combined_query_metrics_df = pd.read_csv(combined_query_metrics_csv)

sankey = None
if sankey_md.is_file():
    with open(sankey_md, "r") as f:
        sankey = f.read()

sankey_filtered = None
if sankey_filtered_md.is_file():
    with open(sankey_filtered_md, "r") as f:
        sankey_filtered = f.read()

times_df = pd.read_csv(times_csv)
times_df.drop(columns=["t0", "t1"], inplace=True)
times_df.rename(columns={"label": "Stage", "td": "Diff [s]"}, inplace=True)

gantt = None
if times_csv_md.is_file():
    with open(times_csv_md, "r") as f:
        gantt = f.read()

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
    if gantt is not None:
        content += "<details>\n"
        content += "<summary>Gantt</summary>\n\n"
        content += "```mermaid\n"
        content += gantt + "\n\n"
        content += "```\n"
        content += "</details>\n\n"
    if ise_potential_df is not None:
        content += "### ISE Potential\n"
        content += ise_potential_df.to_markdown(index=False) + "\n\n"
    if choices_summary is not None:
        content += "### Choices\n"
        content += "<details>\n"
        content += "<summary>Summary</summary>\n\n"
        content += choices_summary + "\n\n"
        content += "</details>\n\n"
    if combined_query_metrics_df is not None:
        content += "### Queries\n"
        content += "<details>\n"
        content += "<summary>Metrics</summary>\n\n"
        content += combined_query_metrics_df.to_markdown(index=False) + "\n\n"
        content += "</details>\n\n"
    if choices_summary is not None:
        content += "### Sankeys\n"
        content += "<details>\n"
        content += "<summary>Merge Query Results</summary>\n\n"
        content += sankey + "\n\n"
        content += "</details>\n\n"
        content += "<details>\n"
        content += "<summary>Filtered Candidates</summary>\n\n"
        content += sankey_filtered + "\n\n"
        content += "</details>\n\n"
    if compare_df is not None:
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
