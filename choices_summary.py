import sys
# import re
import argparse
from pathlib import Path

import pandas as pd

parser = argparse.ArgumentParser()

parser.add_argument("exp_dir")

args = parser.parse_args()
# print("args", args)

exp_dir = Path(args.exp_dir)
assert exp_dir.is_dir()

run_dir = exp_dir / "run"
sess_dir = exp_dir / "sess"

disass_file = run_dir / "generic_mlonmcu.dump"
choices_pkl = sess_dir / "table" / "choices.pkl"
llvm_bbs_new_pkl = sess_dir / "table" / "llvm_bbs_new.pkl"

# print("choices_pkl", choices_pkl)

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
    choices_df, llvm_bbs_df, left_on=["func_name", "bb_name"], right_on=["func_name", "bb_name"], how="left"
)

print("=== CHOICES ===")
# print(choices_df)
# print(merged_df)

# print("=== LLVM BBs ===")
# print("----------------")

with open(disass_file, "r") as f:
    disass_text = f.read()


def find_disass_snippet(disass_text, start, end, count=None):
    # print("find_disass_snippet", start, end, count)
    # print("disass_text", disass_text[:1000])
    # start_match = re.compile(r"\s+1000018:\s+[0-9a-fA-F]+\s+(.*)").findall(disass_text)
    # print("start_match", start_match)
    start_match = f" {start:x}: "
    end_match = f" {end:x}: "
    # print("start_match", start_match)
    # print("end_match", end_match)
    ret_lines = []
    for line in disass_text.splitlines():
        if len(ret_lines) > 0:
            if end_match in line:
                break
            ret_lines.append(line)
        else:
            if start_match in line:
                ret_lines.append(line)
    # pre, rest = disass_text.split(start_match, 1)
    # assert len(rest) > 0
    # rest, post = disass_text.split(end_match, 1)
    # print("splitted", len(splitted))
    # print("rest", rest)
    assert len(ret_lines) > 0
    if count is not None:
        assert len(ret_lines) == count, f"{len(ret_lines)} vs. {count}"
    return "\n".join(ret_lines)


for i, row in merged_df.iterrows():
    # print(f"i={i}")
    print(f"<>")
    print(row.to_frame().T)
    start = row.start
    end = row.end
    count = row.num_instrs
    snippet = find_disass_snippet(disass_text, start, end, count)
    print("=== ASM ===")
    print(snippet)
    print("-----------")
