import sys
import argparse
from pathlib import Path

import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("exp_dir")
parser.add_argument("--out", type=Path, default=Path("choices_summary.html"),
                    help="Output HTML file (default: choices_summary.html)")
args = parser.parse_args()

exp_dir = Path(args.exp_dir)
assert exp_dir.is_dir()

run_dir = exp_dir / "run"
sess_dir = exp_dir / "sess"

disass_file = run_dir / "generic_mlonmcu.dump"
choices_pkl = sess_dir / "table" / "choices.pkl"
llvm_bbs_new_pkl = sess_dir / "table" / "llvm_bbs_new.pkl"

assert disass_file.is_file()
assert choices_pkl.is_file()
assert llvm_bbs_new_pkl.is_file()

choices_df = pd.read_pickle(choices_pkl)
if len(choices_df) == 0:
    print("NO CHOICES. Aborting...")
    sys.exit(1)

choices_df.drop(columns=["file"], inplace=True)
llvm_bbs_df = pd.read_pickle(llvm_bbs_new_pkl)
llvm_bbs_df = llvm_bbs_df[["func_name", "bb_name", "start", "end"]]

merged_df = pd.merge(
    choices_df, llvm_bbs_df,
    left_on=["func_name", "bb_name"],
    right_on=["func_name", "bb_name"],
    how="left"
)

with open(disass_file, "r") as f:
    disass_text = f.read()


def find_disass_snippet(disass_text, start, end, count=None):
    start_match = f" {start:x}: "
    end_match = f" {end:x}: "
    ret_lines = []
    for line in disass_text.splitlines():
        if ret_lines:
            if end_match in line:
                break
            ret_lines.append(line)
        else:
            if start_match in line:
                ret_lines.append(line)
    assert ret_lines, f"No snippet found for {start:x}"
    if count is not None:
        assert len(ret_lines) == count, f"{len(ret_lines)} vs. {count}"
    return "\n".join(ret_lines)


# --- HTML boilerplate ---
html_parts = []
html_parts.append("""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Choices Summary</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/default.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
<script>hljs.highlightAll();</script>
<style>
  body { font-family: sans-serif; margin: 2em; background: #fafafa; }
  h1 { border-bottom: 3px solid #ccc; padding-bottom: .2em; }
  h2 { margin-top: 2em; }
  table { border-collapse: collapse; margin: 1em 0; width: 100%; }
  th, td { border: 1px solid #ccc; padding: 0.5em 1em; text-align: left; }
  th { background: #eee; }
  pre { padding: 1em; background: #f0f0f0; border-radius: 8px; overflow-x: auto; }
</style>
</head>
<body>
<h1>Choices Summary</h1>
""")

# --- Generate sections for each choice ---
for idx, row in merged_df.iterrows():
    snippet = find_disass_snippet(disass_text, row.start, row.end, row.num_instrs)

    html_parts.append(f"<h2>Choice {idx}</h2>")
    html_parts.append("<table>")
    html_parts.append("<tr>" + "".join(f"<th>{col}</th>" for col in
                                       ["func_name", "bb_name", "rel_weight",
                                        "num_instrs", "freq", "start", "end"]) + "</tr>")
    html_parts.append("<tr>" +
                      f"<td>{row.func_name}</td>"
                      f"<td>{row.bb_name}</td>"
                      f"<td>{row.rel_weight:.6f}</td>"
                      f"<td>{row.num_instrs}</td>"
                      f"<td>{row.freq}</td>"
                      f"<td>0x{row.start:x}</td>"
                      f"<td>0x{row.end:x}</td>"
                      "</tr>")
    html_parts.append("</table>")

    html_parts.append(f"<pre><code class='asm'>\n{snippet}\n</code></pre>")

html_parts.append("</body></html>")

# --- Write output ---
args.out.write_text("\n".join(html_parts), encoding="utf-8")
print(f"HTML report written to {args.out}")

