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
set_cdsl = work_dir / "gen" / "XIsaac.core_desc"
set_filtered_cdsl = work_dir / "gen_filtered" / "XIsaac.core_desc"

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

func_bbs = []
func_bb_times_dfs = {}
func_bb_gantts = {}
func_bb_sankeys = {}
for _, row in combined_query_metrics_df.iterrows():
    func = row.func
    bb = row.basic_block
    rnd = 0
    func_bb = func + "_" + bb + "_" + str(rnd)
    func_bbs.append(func_bb)
    func_bb_dir = work_dir / func_bb
    assert func_bb_dir.is_dir(), f"Not found: {func_bb_dir}"
    func_bb_times_csv = func_bb_dir / "times.csv"
    if func_bb_times_csv.is_file():
        func_bb_times_df = pd.read_csv(func_bb_times_csv)
        func_bb_times_dfs[func_bb] = func_bb_times_df
    func_bb_times_gantt = func_bb_dir / "times.csv.md"
    if func_bb_times_gantt.is_file():
        with open(func_bb_times_gantt, "r") as f:
            func_bb_gantt = f.read()
        func_bb_gantts[func_bb] = func_bb_gantt
    func_bb_sankey_md = func_bb_dir / "sankey.md"
    if func_bb_sankey_md.is_file():
        with open(func_bb_sankey_md, "r") as f:
            func_bb_sankey = f.read()
        func_bb_sankeys[func_bb] = func_bb_sankey

sankey = None
if sankey_md.is_file():
    with open(sankey_md, "r") as f:
        sankey = f.read()

sankey_filtered = None
if sankey_filtered_md.is_file():
    with open(sankey_filtered_md, "r") as f:
        sankey_filtered = f.read()

set_code = None
if set_cdsl.is_file():
    with open(set_cdsl, "r") as f:
        set_code = f.read()

set_filtered_code = None
if set_filtered_cdsl.is_file():
    with open(set_filtered_cdsl, "r") as f:
        set_filtered_code = f.read()

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
    for func_bb, gantt in func_bb_gantts.items():
        content += "<details>\n"
        content += f"<summary>{func_bb}</summary>\n\n"
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
    if sankey is not None or sankey_filtered is not None or len(func_bb_gantts) > 0:
        content += "### Sankeys\n"
    if sankey is not None:
        content += "<details>\n"
        content += "<summary>Merge Query Results</summary>\n\n"
        content += sankey + "\n\n"
        content += "</details>\n\n"
    if sankey_filtered is not None:
        content += "<details>\n"
        content += "<summary>Filtered Candidates</summary>\n\n"
        content += sankey_filtered + "\n\n"
        content += "</details>\n\n"
    if len(func_bb_sankeys) > 0:
        for func_bb, sankey in func_bb_sankeys.items():
            content += "<details>\n"
            content += f"<summary>{func_bb}</summary>\n\n"
            content += sankey + "\n\n"
            content += "</details>\n\n"
    if compare_df is not None:
        content += "### Compare DF\n"
        compare_text = compare_df.to_markdown(index=False)
        content += compare_text + "\n\n"
    if set_code is not None:
        content += "### CoreDSL\n"
        content += "<details>\n"
        content += f"<summary>gen/XIsaac.core_desc</summary>\n\n"
        content += "```c\n"
        content += set_code + "\n"
        content += "```\n\n"
        content += "</details>\n\n"
    if set_filtered_code is not None:
        content += "<details>\n"
        content += f"<summary>gen_filtered/XIsaac.core_desc</summary>\n\n"
        content += "```c\n"
        content += set_filtered_code + "\n"
        content += "```\n\n"
        content += "</details>\n\n"
else:
    raise RuntimeError(f"Unsupported format: {fmt}")

if out_path is None:
    print(content)
else:
    with open(out_path, "w") as f:
        f.write(content)
