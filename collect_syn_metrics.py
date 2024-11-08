import argparse
from pathlib import Path

import yaml
import pandas as pd

KEEP = [
    "design__instance__count",  # 17957
    "design__instance__area",  # 146790
    "power__internal__total",  # 0.006111983675509691
    "power__switching__total",  # 0.005473536439239979
    "power__leakage__total",  # 1.789739911828292e-07
    "power__total",  # 0.011585699394345284
    "design__io",  # 308
    "design__die__area",  # 414115
    "design__core__area",  # 392239
    "design__instance__utilization",  # 0.374235
    "route__wirelength__estimated",  # 468479
]

MAPPING = {
    "design__instance__count": "Instance Count",
    "design__instance__area": "Instance Area",
    "power__internal__total": "Internal Power",
    "power__switching__total": "Switching Power",
    "power__leakage__total": "Leakage Power",
    "power__total": "Total Power",
    "design__io": "IOs",
    "design__die__area": "Die Area",
    "design__core__area": "Core Area",
    "design__instance__utilization": "Instance Utilization",
    "route__wirelength__estimated": "Est. Wire Length",
    # ...
    "prj_name": "Project",
    "period_s": "Clock Period [s]",
    "period_ns": "Clock Period [ns]",
    "fclk_hz": "Clock Freq [Hz]",
    "fclk_mhz": "Clock Freq [MHz]",
}

parser = argparse.ArgumentParser(description="Collect metrics from High-level-Synthesis")
parser.add_argument("directory", help="Input directory")
parser.add_argument("-r", "--run", default="auto", help="Run name")
parser.add_argument("-o", "--output", default=None, help="Output file")
parser.add_argument("--fmt", type=str, choices=["auto", "csv", "pkl", "md"], default="auto", help="Output file format")
parser.add_argument("--print-df", action="store_true", help="Print DataFrame")
parser.add_argument("--min", action="store_true", help="Only keep relevant cols")
parser.add_argument("--rename", action="store_true", help="Rename cols using MAPPING")
args = parser.parse_args()

directory = Path(args.directory)

assert directory.is_dir()

# print("directory", directory)

name = directory.name


def parse_properties(name):
    assert "LEGACY" in name
    prj_name, rest = name.split("_LEGACY_", 1)
    assert rest.count("_") == 1
    period_ns, util = rest.split("ns_", 1)
    period_s = float(period_ns) * 1e-9
    fclk_hz = 1 / period_s
    fclk_mhz = fclk_hz / 1e6
    assert util[-1] == "%"
    util = float(util[:-1]) / 100
    ret = {
        "prj_name": prj_name,
        "period_s": period_s,
        "period_ns": period_ns,
        "fclk_hz": fclk_hz,
        "fclk_mhz": fclk_mhz,
    }
    return ret


properties = parse_properties(name)
# print("properties", properties)


runs_dir = directory / "runs"

# print("runs_dir", runs_dir)

run = args.run

if run == "auto":
    runs = [f.name for f in runs_dir.iterdir() if f.is_dir()]
    # print("runs", runs)
    assert len(runs) > 0, "No runs found."
    runs_str = ",".join(runs)
    assert len(runs) == 1, f"Found more than one ISAX ({runs_str}). Use --run=NAME to specify the correct one."
    run = runs[0]
    # print("run", run)


run_dir = runs_dir / run
# print("run_dir", run_dir)

assert run_dir.is_dir()

final_dir = run_dir / "final"
# print("final_dir", final_dir)

assert final_dir.is_dir()

json_file = final_dir / "metrics.json"
# print("json_file", json_file)

assert json_file.is_file()

df = pd.read_json(json_file, typ="series")

properties_df = pd.DataFrame([properties])
# print("propeties_df", properties_df)

df = df.to_frame().T

if args.min:
    df = df[KEEP]

df = pd.concat([properties_df, df], axis=1)

if args.rename:
    df.rename(columns=MAPPING, inplace=True)


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
