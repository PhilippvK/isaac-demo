import sys
# import re
import argparse
import tempfile
import subprocess
from pathlib import Path

import pandas as pd

parser = argparse.ArgumentParser()

parser.add_argument("exp_dir")
parser.add_argument("-sess", default="sess_new_filtered_selected")  # TODO: auto
parser.add_argument("--base-sess", default="sess")
parser.add_argument("--fancy", action="store_true", help="Use diff-so-fancy")

args = parser.parse_args()
# print("args", args)

exp_dir = Path(args.exp_dir)
assert exp_dir.is_dir()

run_dir = exp_dir / "run"
base_sess_dir = exp_dir / args.base_sess
sess_dir = exp_dir / args.sess

compare_runtime_per_llvm_bb_pkl = sess_dir / "table" / "compare_runtime_per_llvm_bb.pkl"
assert compare_runtime_per_llvm_bb_pkl.is_file()

disass_pkl = sess_dir / "table" / "disass.pkl"
assert disass_pkl.is_file()

base_disass_pkl = base_sess_dir / "table" / "disass.pkl"
assert base_disass_pkl.is_file()

llvm_bbs_new_pkl = sess_dir / "table" / "llvm_bbs_new.pkl"
assert llvm_bbs_new_pkl.is_file()

base_llvm_bbs_new_pkl = base_sess_dir / "table" / "llvm_bbs_new.pkl"
assert base_llvm_bbs_new_pkl.is_file()

choices_pkl = base_sess_dir / "table" / "choices.pkl"
assert choices_pkl.is_file()


choices_df = pd.read_pickle(choices_pkl)
if len(choices_df) == 0:
    print("NO CHOICES. Aborting...")
    sys.exit(1)

choices_df.drop(columns=["file", "num_instrs"], inplace=True)

llvm_bbs_df = pd.read_pickle(llvm_bbs_new_pkl)
llvm_bbs_df = llvm_bbs_df[["func_name", "bb_name", "start", "end", "num_instrs"]]

base_llvm_bbs_df = pd.read_pickle(base_llvm_bbs_new_pkl)
base_llvm_bbs_df = base_llvm_bbs_df[["func_name", "bb_name", "start", "end", "num_instrs"]]

disass_df = pd.read_pickle(disass_pkl)
disass_df.drop(columns=["bytecode"], inplace=True)

base_disass_df = pd.read_pickle(base_disass_pkl)
base_disass_df.drop(columns=["bytecode"], inplace=True)

merged_df = pd.merge(
    choices_df, llvm_bbs_df, left_on=["func_name", "bb_name"], right_on=["func_name", "bb_name"], how="left"
)
base_merged_df = pd.merge(
    choices_df, base_llvm_bbs_df, left_on=["func_name", "bb_name"], right_on=["func_name", "bb_name"], how="left"
)

compare_runtime_per_llvm_bb_df = pd.read_pickle(compare_runtime_per_llvm_bb_pkl)

print("=== DIFFS ===")

def find_disass_snippet(disass_df, start, end, count=None):
    temp_df = disass_df[disass_df["pc"] >= start]
    assert len(temp_df) > 0
    temp_df = temp_df[temp_df["pc"] < end]
    assert len(temp_df) > 0
    # print("temp_df", temp_df)
    if count:
        assert len(temp_df) == count
    temp_df.drop(columns=["pc"], inplace=True)
    temp_df.reset_index(inplace=True, drop=True)
    return temp_df


for i, row in merged_df.iterrows():
    # print(f"i={i}")
    # print("row", row)
    base_row = base_merged_df.iloc[i]
    # print("base_row", base_row)
    func_name = row.func_name
    # print("func_name", func_name)
    bb_name = row.bb_name
    # print("bb_name", bb_name)
    func_bb = func_name + "-" + bb_name
    compare_runtime_match = compare_runtime_per_llvm_bb_df[compare_runtime_per_llvm_bb_df.index == func_bb]
    # print("compare_runtime_match", compare_runtime_match)
    assert len(compare_runtime_match) == 1
    compare_runtime_match.reset_index(inplace=True, drop=True)
    # input("")
    # print(f"<>")
    # print(row.to_frame().T)
    start = row.start
    base_start = base_row.start
    # print("start", start)
    # print("base_start", base_start)
    end = row.end
    base_end = base_row.end
    # print("end", end)
    count = row.num_instrs
    base_count = base_row.num_instrs
    # print("count", count)
    # print("base_count", base_count)
    snippet_df = find_disass_snippet(disass_df, start, end, count)
    base_snippet_df = find_disass_snippet(base_disass_df, base_start, base_end, base_count)

    max_instr_len = snippet_df["instr"].apply(lambda x: len(x)).max()
    # print("max_instr_len", max_instr_len)
    base_max_instr_len = snippet_df["instr"].apply(lambda x: len(x)).max()
    # print("base_max_instr_len", base_max_instr_len)
    common_max_instr_len = max(max_instr_len, base_max_instr_len)
    # print("common_max_instr_len", common_max_instr_len)

    max_args_len = snippet_df["args"].apply(lambda x: len(x)).max()
    # print("max_args_len", max_args_len)
    base_max_args_len = snippet_df["args"].apply(lambda x: len(x)).max()
    # print("base_max_args_len", base_max_args_len)
    common_max_args_len = max(max_args_len, base_max_args_len)
    # print("common_max_args_len", common_max_args_len)

    snippet_df["instr"] = snippet_df["instr"].apply(lambda x: x.ljust(common_max_instr_len))
    base_snippet_df["instr"] = base_snippet_df["instr"].apply(lambda x: x.ljust(common_max_instr_len))
    # snippet_df["instr"] = "'" + snippet_df["instr"] + "'"
    # snippet_df["args"] = "'" + snippet_df["args"] + "'"

    snippet_df["args"] = snippet_df["args"].apply(lambda x: x.ljust(common_max_args_len))
    base_snippet_df["args"] = base_snippet_df["args"].apply(lambda x: x.ljust(common_max_args_len))
    # base_snippet_df["instr"] = "'" + base_snippet_df["instr"] + "'"
    # base_snippet_df["args"] = "'" + base_snippet_df["args"] + "'"

    snippet_df["joined"] = snippet_df["instr"] + "  " + snippet_df["args"]
    base_snippet_df["joined"] = base_snippet_df["instr"] + "  " + base_snippet_df["args"]

    num_instrs = len(snippet_df)
    base_num_instrs = len(base_snippet_df)
    num_instrs_diff = -(base_num_instrs - num_instrs)
    num_instrs_rel = (num_instrs_diff / base_num_instrs)

    rel_weight_ = compare_runtime_match["rel_weight_"].iloc[0]
    rel_weight = compare_runtime_match["rel_weight"].iloc[0]
    diff = compare_runtime_match["diff"].iloc[0]
    diff_rel = compare_runtime_match["diff_rel"].iloc[0]

    # print("snippet_df")
    snippet_txt = "\n".join(snippet_df["joined"].values) + "\n"
    # print("base_snippet_df")
    base_snippet_txt = "\n".join(base_snippet_df["joined"].values) + "\n"

    print(f"{i}) <{func_bb}>")
    # print(compare_runtime_match.to_string(index=False))
    print("rel_weight [old] :", rel_weight_)
    print("rel_weight [new] :", rel_weight)
    print("rel_weight [diff]:", diff)
    print(f"rel_weight [rel] : {diff_rel*100:.2f}%")
    print("num_instrs [old] :", base_num_instrs)
    print("num_instrs [new] :", num_instrs)
    print("num_instrs [diff]:", num_instrs_diff)
    print(f"num_instrs [rel] : {num_instrs_rel*100:.2f}%")
    with tempfile.TemporaryDirectory() as tempd:
        temppath = Path(tempd)
        # print("temppath", temppath)
        name = "new"
        base_name = "old"
        with open(temppath / name, "w") as f:
            f.write(snippet_txt)
        with open(temppath / base_name, "w") as f:
            f.write(base_snippet_txt)
        # print("temppath", temppath)
        # input("!")
        # TODO: avoid code injection!
        cmd = f"git diff --no-index -w {base_name} {name}"
        if args.fancy:
            cmd += " | diff-so-fancy"

        output = subprocess.run(cmd, cwd=tempd, shell=True, check=False, stdout=subprocess.PIPE).stdout.decode()
        # print("output")
        print(output)
    # print("=== ASM ===")
    # print(snippet)
    # print("-----------")
