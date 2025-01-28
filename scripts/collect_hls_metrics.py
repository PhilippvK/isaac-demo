import argparse
from pathlib import Path

import yaml
import pandas as pd

parser = argparse.ArgumentParser(description="Collect metrics from High-level-Synthesis")
parser.add_argument("directory", help="Input directory")
parser.add_argument("-i", "--isax", default="auto", help="ISAX name")
parser.add_argument("-o", "--output", default=None, help="Output file")
parser.add_argument("--fmt", type=str, choices=["auto", "csv", "pkl", "md"], default="auto", help="Output file format")
parser.add_argument("--print-df", action="store_true", help="Print DataFrame")
args = parser.parse_args()

directory = Path(args.directory)

assert directory.is_dir()

isax = args.isax

if isax == "auto":
    yaml_files = list(directory.glob("ISAX_*.yaml"))
    # print("yaml_files", yaml_files)
    assert len(yaml_files) > 0, "No ISAX found."
    yaml_files_str = ",".join(map(lambda x: x.name, yaml_files))
    assert (
        len(yaml_files) == 1
    ), f"Found more than one ISAX ({yaml_files_str}). Use --isax=NAME to specify the correct one."
    yaml_file = yaml_files[0]
    isax = yaml_file.stem.split("_", 1)[-1]

sv_file = directory / f"ISAX_{isax}.sv"
assert sv_file.is_file()

# print("sv_file", sv_file)

with open(sv_file, "r") as file:
    locs = file.read().count("\n")

yaml_file = directory / f"ISAX_{isax}.yaml"
assert yaml_file.is_file()

# print("yaml_file", yaml_file)

with open(yaml_file, "r") as file:
    yaml_data = yaml.safe_load(file)

# print("yaml_data", yaml_data)

df = pd.DataFrame(yaml_data)

# instructions = []
#
# for data in yaml_data:
#     instr_name = data.get("instruction")
#     if instr_name:
#         instructions.append(instr_name)
#
# print("instructions", instructions)
#
# for instruction in instructions:
#     stats_file = directory / f"PARAMS_{instruction}_II_1.dot.stats"
#     print("stats_file", stats_file)
#     assert stats_file.is_file()
#     with open(stats_file, "r") as file:
#         lines = file.readlines()
#         # stats_data = yaml.safe_load(file)
#     # print("stats_data", stats_data)
#     # print("lines", lines)
#     instr2lat = {}
#     cur_instr = None
#     for line in lines:
#         line = line.strip()
#         print("line", line)
#         if "instruction:" in line:
#             cur_instr = line.split(":")[-1].strip()
#         if "latency:" in line:
#             lat = float(line.split(":")[-1].strip())
#             assert cur_instr is not None
#             instr2lat[cur_instr] = lat
#             cur_instr = None
#     print("instr2lat", instr2lat)

instrs = df["instruction"].dropna().unique()
df["latency"] = None


for instr in instrs:
    stats_file = directory / f"PARAMS_{instr}_II_1.dot.stats"
    print("stats_file", stats_file)
    assert stats_file.is_file()
    with open(stats_file, "r") as file:
        lines = file.readlines()
        # stats_data = yaml.safe_load(file)
    # print("stats_data", stats_data)
    # print("lines", lines)
    instr2lat = {}
    cur_instr = None
    for line in lines:
        line = line.strip()
        # print("line", line)
        if "instruction:" in line:
            cur_instr = line.split(":")[-1].strip()
        if "latency:" in line:
            lat = float(line.split(":")[-1].strip())
            assert cur_instr is not None
            instr2lat[cur_instr] = lat
            cur_instr = None
    # print("instr2lat", instr2lat)

    for instr, lat in instr2lat.items():
        df.loc[df["instruction"] == instr, "latency"] = lat

df.drop(columns=["last stage"], inplace=True)
df.dropna(axis="rows", inplace=True)
locs_df = pd.DataFrame([{"locs": locs}])
df = pd.concat([df, locs_df])

assert args.print_df or args.output is not None

if args.print_df:
    print(df)

if args.output is not None:
    out_path = Path(args.output)

    fmt = args.fmt

    if fmt == "auto":
        fmt = out_path.suffix
        assert len(fmt) > 1
        fmt = fmt[1:].lower()

    if fmt == "csv":
        df.to_csv(out_path, index=False)
    elif fmt == "pkl":
        df.to_pickle(out_path)
    elif fmt == "md":
        df.to_markdown(out_path, index=False)
    else:
        raise ValueError(f"Unsupported fmt: {fmt}")
