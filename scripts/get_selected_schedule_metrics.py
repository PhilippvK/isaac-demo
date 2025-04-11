import sys
import ast
from pathlib import Path
import pandas as pd
import yaml


# Example usage
# file_path = "/work/git/tuda/isax-tools-integration5/nailgun/outputs/run_24/Kconfig"
assert len(sys.argv) in [3, 4]
schedules_csv = Path(sys.argv[1])
assert schedules_csv.is_file()
schedules_df = pd.read_csv(schedules_csv)
print("schedules_df", schedules_df, schedules_df.columns)
selected_schedules_yaml = Path(sys.argv[2])
assert selected_schedules_yaml.is_file()
with open(selected_schedules_yaml, "r") as f:
    yaml_data = yaml.safe_load(f)
print("yaml_data", yaml_data)
total_area_estimate = 0
total_area_estimate_with_lifetimes = 0
iis = []
all_lats = []
num_groups = 0
num_instrs = 0
group2instrs = {}
for row in yaml_data:
    num_groups += 1
    sharing_group = row["sharing_group"]
    idx = row["solution_idx"]
    name = f"SG_{sharing_group}_SOL_IDX_{idx}"
    schedules = schedules_df[schedules_df["config"] == name]
    assert len(schedules) == 1
    print("schedules", schedules)
    schedule = schedules.iloc[0]
    ii = schedule["II"]
    iis.append(ii)
    lats = ast.literal_eval(schedule["Instruction latencies"])
    group2instrs[idx] = list(lats.keys())
    num_instrs += len(lats)
    all_lats += list(lats.values())
    area_estimate = schedule["Area estimate w/o lifetimes"]
    total_area_estimate += area_estimate
    area_estimate_with_lifetimes = schedule["Area estimate w/ lifetimes"]
    total_area_estimate_with_lifetimes += area_estimate_with_lifetimes
    # Fallback
    # Instruction latencies
    # Allocation
    # Overall latency
    # Total lifetime
    # Total decoupled ops
max_instrs = max(map(len, group2instrs.values()))
min_instrs = min(map(len, group2instrs.values()))
avg_instrs = num_instrs/num_groups
min_ii = min(iis)
max_ii = max(iis)
avg_ii = sum(iis)/len(iis)
min_lat = min(all_lats)
max_lat = max(all_lats)
avg_lat = sum(all_lats)/len(all_lats)
data = {"num_groups": num_groups, "num_instrs": num_instrs, "max_instrs": max_instrs, "min_instrs": min_instrs, "avg_instrs": avg_instrs, "min_ii": min_ii, "max_ii": max_ii, "avg_ii": avg_ii, "min_lat": min_lat, "max_lat": max_lat, "avg_lat": avg_lat, "total_area_estimate": total_area_estimate, "total_area_estimate_with_lifetimes": total_area_estimate_with_lifetimes}
df = pd.DataFrame([data])
print(df)
if len(sys.argv) == 4:
    out_file = Path(sys.argv[3])
    df.to_csv(out_file, index=True)
