import argparse
import subprocess
import yaml
import shutil
from pathlib import Path
from collections import defaultdict

import pandas as pd
from combine_tables import read_experiment_ini, read_env_file
from analyze_encoding import analyze_encoding

parser = argparse.ArgumentParser(description="TODO")
parser.add_argument("experiments", nargs="+", help="INI files or directories")
parser.add_argument("-o", "--output", default=None, help="Destination")
# parser.add_argument("--fmt", type=str, choices=["auto", "csv", "pkl", "md"], default="auto", help="Output file format")
# parser.add_argument("--print-df", action="store_true", help="Print DataFrame")
parser.add_argument("--allow-multiple", action="store_true", help="Allow more than one experiment per benchmark")
parser.add_argument("--allow-missmatch", action="store_true", help="Allow config missmatches")
parser.add_argument(
    "--stage", default="combined", choices=["combined", "filtered", "prelim", "final"], help="Output file"
)
args = parser.parse_args()

multi_metrics = {}

all_exp_names = set()
all_bench_names = set()
all_configs = set()
all_data = {}
index_files = []
exp_num_instrs = {}
exp_enc_weight = {}

speedups_per_bench = defaultdict(list)
asip_overheads_per_bench = defaultdict(list)

exp2set = {}
set2index = {}

LETTERS = [chr(i) for i in range(ord("A"), ord("Z") + 1)]

assert len(args.experiments) < len(LETTERS)

for i, experiment in enumerate(args.experiments):
    experiment = Path(experiment)
    if experiment.is_dir():
        ini_path = experiment / "experiment.ini"
        exp_dir = experiment
    elif experiment.is_file():
        ini_path = experiment
        exp_dir = ini_path.parent
    else:
        assert False, f"Not found: {experiment}"
    # TODO: get abs dir from ini file!
    exp_name, bench_name, datetime, comment, is_ignored = read_experiment_ini(ini_path)
    assert exp_name not in all_exp_names
    set_letter = LETTERS[i]
    set_name = f"XIsaacSet{set_letter}"
    exp2set[exp_name] = set_name
    all_exp_names.add(exp_name)
    if bench_name in all_bench_names:
        assert args.allow_multiple
    all_bench_names.add(bench_name)
    env_file = exp_dir / "vars.env"
    cfg = read_env_file(env_file)
    cfg_str = str(cfg)
    if len(all_configs) > 0 and cfg_str not in all_configs:
        assert args.allow_missmatch
    all_configs.add(cfg_str)
    combined_index_yaml = exp_dir / "work" / f"{args.stage}_index.yml"
    set2index[set_name] = combined_index_yaml
    index_files.append(combined_index_yaml)
    assert combined_index_yaml.is_file(), f"File not found: {combined_index_yaml}"
    with open(combined_index_yaml, "r") as f:
        combined_index_data = yaml.safe_load(f)
    candidates = combined_index_data["candidates"]
    num_combined_candidates = len(candidates)
    exp_num_instrs[exp_name] = num_combined_candidates  # TODO: filter unused before!

    enc_metrics_df, enc_weights_df = analyze_encoding(
        combined_index_yaml,
        enc_size=32,
        major_count=1,  # TODO: do not hardcode?
    )
    total_weight = enc_metrics_df["total_weight"].iloc[0]
    # suffix = "" if args.stage == "combined" else f"_{args.stage}"
    # enc_metrics_csv = exp_dir / "work" / f"total_encoding_metrics{suffix}.csv"
    # assert enc_metrics_csv.is_file()
    # enc_metrics_df = pd.read_csv(enc_metrics_csv)
    # assert len(enc_metrics_df) == 1
    # total_weight = enc_metrics_df["total_weight"].iloc[0]
    exp_enc_weight[exp_name] = total_weight
    compare_final_csv = exp_dir / "compare_final.csv"
    assert compare_final_csv.is_file()
    compare_final_df = pd.read_csv(compare_final_csv)
    assert len(compare_final_df) == 2
    speedup = 1 - compare_final_df["Run Instructions (rel.)"].iloc[1]
    speedups_per_bench[bench_name].append(speedup)
    asip_syn_metrics_csv = exp_dir / "work" / "docker" / "asip_syn" / "metrics.csv"
    if asip_syn_metrics_csv.is_file():
        asip_syn_metrics_df = pd.read_csv(asip_syn_metrics_csv)
        assert len(asip_syn_metrics_df) >= 1
        asip_syn_default_metrics_df = asip_syn_metrics_df[asip_syn_metrics_df["variant"] == "default"]
        assert len(asip_syn_default_metrics_df) == 1
        # print("asip_syn_default_metrics_df", asip_syn_default_metrics_df, asip_syn_default_metrics_df.columns)
        area_total_overhead_rel = asip_syn_default_metrics_df["area_total_overhead_rel"].iloc[0]
        asip_overheads_per_bench[bench_name].append(area_total_overhead_rel)


print("speedups_per_bench", speedups_per_bench)
max_speedup_per_bench = {bench: max(speedups) for bench, speedups in speedups_per_bench.items()}
print("max_speedup_per_bench", max_speedup_per_bench)
total_speedup = sum(max_speedup_per_bench.values())
print("total_speedup", total_speedup)
print("asip_overheads_per_bench", asip_overheads_per_bench)
max_asip_overhead_per_bench = {bench: max(overheads) for bench, overheads in asip_overheads_per_bench.items()}
print("asip_max_overhead_per_bench", max_asip_overhead_per_bench)
total_asip_overhead = sum(max_asip_overhead_per_bench.values())
print("total_asip_overhead", total_asip_overhead)
# input(">")

# print("exp2set", exp2set)
# print("set2index", set2index)
# input("!@")

print("all_exp_names", all_exp_names, len(all_exp_names))
print("all_bench_names", all_bench_names, len(all_bench_names))
print("all_configs", all_configs, len(all_configs))
multi_metrics["num_exps"] = len(all_exp_names)
multi_metrics["num_progs"] = len(all_bench_names)
multi_metrics["num_configs"] = len(all_configs)

num_instrs_total = sum(exp_num_instrs.values())
num_instrs_max = max(exp_num_instrs.values())

print("num_instrs_total", num_instrs_total)
print("num_instrs_max", num_instrs_max)
multi_metrics["num_instrs_total"] = num_instrs_total
multi_metrics["num_instrs_max"] = num_instrs_max

enc_weight_total = sum(exp_enc_weight.values())
enc_weight_max = max(exp_enc_weight.values())

print("enc_weight_total", enc_weight_total)
print("enc_weight_max", enc_weight_max)
multi_metrics["enc_weight_total"] = enc_weight_total
multi_metrics["enc_weight_max"] = enc_weight_max

assert args.output is not None
out_dir = Path(args.output)

set_names_txt = out_dir / "set_names.txt"
with open(set_names_txt, "w") as f:
    set_names = list(set2index.keys())
    content = "\n".join(set_names)
    f.write(content)

bench_names_txt = out_dir / "bench_names.txt"
with open(bench_names_txt, "w") as f:
    content = "\n".join(all_bench_names)
    f.write(content)

stop_benefit_txt = out_dir / "stop_benefit.txt"
with open(stop_benefit_txt, "w") as f:
    f.write(str(total_speedup))

for set_name, index_yaml in set2index.items():
    set_index_yaml = out_dir / f"{set_name}_index.yml"

    shutil.copyfile(index_yaml, set_index_yaml)


sort_by = None
topk = None

union_index_file = out_dir / "union_index.yml"
union_args = [
    "python3",
    "-m",
    "tool.combine_index",
    *index_files,
    # "--drop",
    *(["--sort-by", sort_by] if sort_by is not None else []),
    *(["--topk", str(topk)] if topk is not None else []),
    "--out",
    union_index_file,
]
if len(index_files) in [2, 3]:
    union_venn_diagram_file = out_dir / "venn_union.jpg"
    union_args += ["--venn", union_venn_diagram_file]
union_sankey_diagram_file = out_dir / "sankey_union.md"
union_args += ["--sankey", union_sankey_diagram_file]
union_overlaps_file = out_dir / "overlaps_union.csv"
union_args += ["--overlaps", union_overlaps_file]
# print("combine_args", combine_args)
subprocess.run(union_args, check=True)

merged_index_file = out_dir / "merged_index.yml"
combine_args = [
    "python3",
    "-m",
    "tool.combine_index",
    *index_files,
    "--drop-duplicates",
    "--drop-name-isos",
    *(["--sort-by", sort_by] if sort_by is not None else []),
    *(["--topk", str(topk)] if topk is not None else []),
    "--out",
    merged_index_file,
]
if len(index_files) in [2, 3]:
    venn_diagram_file = out_dir / "venn.jpg"
    combine_args += ["--venn", venn_diagram_file]
sankey_diagram_file = out_dir / "sankey.md"
combine_args += ["--sankey", sankey_diagram_file]
overlaps_file = out_dir / "overlaps.csv"
combine_args += ["--overlaps", overlaps_file]
# print("combine_args", combine_args)
subprocess.run(combine_args, check=True)

assert merged_index_file.is_file(), f"File not found: {merged_index_file}"
with open(merged_index_file, "r") as f:
    merged_index_data = yaml.safe_load(f)
candidates = merged_index_data["candidates"]
num_merged_instrs = len(candidates)
num_merged_instrs_rel = num_merged_instrs / num_instrs_total
num_duplicate_instrs = num_instrs_total - num_merged_instrs
num_merged_duplicates_rel = 1 - num_merged_instrs_rel

print("num_merged_instrs", num_merged_instrs)
print("num_duplicate_instrs", num_duplicate_instrs)
print("num_merged_instrs_rel", num_merged_instrs_rel)
print("num_merged_duplicates_rel", num_merged_duplicates_rel)
multi_metrics["num_merged_instrs"] = num_merged_instrs
multi_metrics["num_duplicate_instrs"] = num_duplicate_instrs
multi_metrics["num_merged_instrs_rel"] = num_merged_instrs_rel
multi_metrics["num_merged_duplicates_rel"] = num_merged_duplicates_rel

merged_enc_metrics_df, merged_enc_weights_df = analyze_encoding(
    merged_index_file,
    enc_size=32,
    major_count=1,  # TODO: do not hardcode?
)

assert len(merged_enc_metrics_df) == 1
merged_enc_weight_total = merged_enc_metrics_df["total_weight"].iloc[0]
merged_enc_weight_total_rel = merged_enc_weight_total / enc_weight_total

print("merged_enc_weight_total", merged_enc_weight_total)
print("merged_enc_weight_total_rel", merged_enc_weight_total_rel)
multi_metrics["merged_enc_weight_total"] = merged_enc_weight_total
multi_metrics["merged_enc_weight_total_rel"] = merged_enc_weight_total_rel

# TODO: not required anymore?
dropped_index_file = out_dir / "dropped_index.yml"
drop_name_isos_args = [
    "python3",
    "-m",
    "tool.detect_name_isos",
    merged_index_file,
    "--drop",
    "-o",
    dropped_index_file,
    "--progress",
]

subprocess.run(drop_name_isos_args, check=True)

assert dropped_index_file.is_file(), f"File not found: {dropped_index_file}"
with open(dropped_index_file, "r") as f:
    dropped_index_data = yaml.safe_load(f)
candidates = dropped_index_data["candidates"]
num_non_dropped_instrs = len(candidates)
num_non_dropped_instrs_rel = num_non_dropped_instrs / num_instrs_total
num_name_iso_instrs = num_merged_instrs - num_non_dropped_instrs

print("num_non_dropped_instrs", num_non_dropped_instrs)
print("num_name_iso_instrs", num_name_iso_instrs)
multi_metrics["num_non_dropped_instrs"] = num_non_dropped_instrs
multi_metrics["num_name_iso_instrs"] = num_name_iso_instrs
# print("num_dropped_instrs_rel", num_dropped_instrs_rel)
# print("num_name_iso_instrs_rel", num_name_iso_instrs_rel)

dropped_enc_metrics_df, dropped_enc_weights_df = analyze_encoding(
    dropped_index_file,
    enc_size=32,
    major_count=1,  # TODO: do not hardcode?
)

assert len(dropped_enc_metrics_df) == 1
dropped_enc_weight_total = dropped_enc_metrics_df["total_weight"].iloc[0]
dropped_enc_weight_total_rel = dropped_enc_weight_total / enc_weight_total

print("dropped_enc_weight_total", dropped_enc_weight_total)
print("dropped_enc_weight_total_rel", dropped_enc_weight_total_rel)
multi_metrics["dropped_enc_weight_total"] = dropped_enc_weight_total
multi_metrics["dropped_enc_weight_total_rel"] = dropped_enc_weight_total_rel

# TOPK = 150
# TOPK = 200
# TOPK = 300
TOPK = 350
# SORT_BY = "runtime_reduction_rel"
SORT_BY = "util_score"
SORT_BY2 = "runtime_reduction_rel"

# TODO filter unused instrs out!

sorted_index_file = out_dir / "sorted_index.yml"
sort_args = [
    "python3",
    "-m",
    "isaac_toolkit.utils.sort_index",
    dropped_index_file,
    "-o",
    sorted_index_file,
    "--by",
    SORT_BY,
    "--by2",
    SORT_BY2,
]

subprocess.run(sort_args, check=True)

topk_index_file = out_dir / "topk_index.yml"
topk_args = [
    "python3",
    # "-m",
    # "tool.select_candidates",
    "scripts/select_candidates.py",
    sorted_index_file,
    "--topk",
    str(TOPK),
    "-o",
    topk_index_file,
]

subprocess.run(topk_args, check=True)

assert topk_index_file.is_file(), f"File not found: {topk_index_file}"
with open(topk_index_file, "r") as f:
    topk_index_data = yaml.safe_load(f)
candidates = topk_index_data["candidates"]

multi_metrics["num_topk_instrs"] = len(candidates)
topk_enc_metrics_df, dropped_enc_weights_df = analyze_encoding(
    topk_index_file,
    enc_size=32,
    major_count=1,  # TODO: do not hardcode?
)
assert len(topk_enc_metrics_df) == 1
topk_enc_weight_total = topk_enc_metrics_df["total_weight"].iloc[0]
topk_enc_weight_total_rel = topk_enc_weight_total / enc_weight_total
print("topk_enc_weight_total", topk_enc_weight_total)
print("topk_enc_weight_total_rel", topk_enc_weight_total_rel)
multi_metrics["topk_enc_weight_total"] = topk_enc_weight_total
multi_metrics["topk_enc_weight_total_rel"] = topk_enc_weight_total_rel

multi_metrics_df = pd.DataFrame([multi_metrics])
print("multi_metrics_df")
with pd.option_context("display.max_rows", None, "display.max_columns", None, "display.width", 0):
    print(multi_metrics_df)
multi_metrics_df.to_csv(out_dir / "multi_metrics.csv", index=False)


# TODO:
# collect hls estimated metrics
# collect util? per candidate
# analyze const merging
# perform const merging
# analyze specs
