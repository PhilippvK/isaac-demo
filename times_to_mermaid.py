import sys
import argparse
from pathlib import Path
import pandas as pd


def get_parser():
    # read command line args
    parser = argparse.ArgumentParser()
    parser.add_argument("input", help="Input CSV file (times.csv)")
    parser.add_argument("--output", "-o", type=str, default=None)
    parser.add_argument("--zero", action="store_true")
    return parser


def main(argv):
    parser = get_parser()
    args = parser.parse_args(argv)
    times_csv = Path(args.input)
    out_path = Path(args.output) if args.output is not None else None
    zero = args.zero
    assert times_csv.is_file()
    times_df = pd.read_csv(times_csv)
    if zero:
        start = times_df["t0"].iloc[0]
        times_df["t0"] = times_df["t0"] - start
        times_df["t1"] = times_df["t1"] - start
    # print(times_df)

    content = ""
    content += """gantt
  title ISAAC Flow
  dateFormat x
  axisFormat %H:%M:%S
  section Steps

"""
    cur = 0
    for _, stage_data in times_df.iterrows():
        stage = stage_data.get("label", "?")
        start = stage_data.get("t0")
        end = stage_data.get("t1")
        time_s = stage_data.get("td")
        if start:
            cur = start
        else:
            start = cur

        if end:
            cur = end
        else:
            assert time_s
            cur += time_s
            end = cur
        start = int(start * 1e3)
        end = int(end * 1e3)
        content += f"    {stage} : {start}, {end}\n"
    if out_path is None:
        print(content)
    else:
        with open(out_path, "w") as f:
            f.write(content)


if __name__ == "__main__":
    main(sys.argv[1:])
