# TODO

import argparse
from pathlib import Path

import pandas as pd

parser = argparse.ArgumentParser(description="Generate Summary for multiple experiments")
parser.add_argument("sess_dir", nargs="+", help="Report CSV file")
parser.add_argument("-o", "--output", default=None, help="Output file")
parser.add_argument("--print-df", action="store_true", help="Print DataFrame")
args = parser.parse_args()

sess_dirs = args.sess_dir


def create_sess_df(sess_dir):
    sess_name = sess_dir.name
    # print("sess_name", sess_name)
    # TODO: fix this (put name in sess dir!)
    bench_name = str(sess_dir.parent).split("out/", 1)[-1]
    # print("bench_name", bench_name)
    ret = pd.DataFrame([{"benchmark": bench_name, "session": sess_name}])

    times_csv = sess_dir / "times.csv"
    times_df = pd.read_csv(times_csv)
    # print("times_df", times_df)
    times_row = times_df.groupby("label")["td"].last().to_frame("x").T.reset_index().add_prefix("time_")
    # print("times_row", times_row)
    ret = pd.concat([ret, times_row], axis=1)

    compare_csv = sess_dir / "run" / "compare.csv"  # TODO: move!
    compare_df = pd.read_csv(compare_csv)
    # print("compare_df", compare_df)
    base_row = compare_df.iloc[0]
    isaac_row = compare_df.iloc[1]
    base_run_instrs = base_row["Run Instructions"]
    isaac_run_instrs = isaac_row["Run Instructions"]
    rel_run_instrs = isaac_row["Run Instructions (rel.)"]
    base_rom_code = base_row["ROM code"]
    isaac_rom_code = isaac_row["ROM code"]
    rel_rom_code = isaac_row["ROM code (rel.)"]
    compare_row = pd.DataFrame(
        [
            {
                "base_run_instrs": base_run_instrs,
                "isaac_run_instrs": isaac_run_instrs,
                "rel_run_instrs": rel_run_instrs,
                "base_rom_code": base_rom_code,
                "isaac_run_code": isaac_rom_code,
                "rel_run_code": rel_rom_code,
            }
        ]
    )
    ret = pd.concat([ret, compare_row], axis=1)

    # TODO: choices metrics
    # TODO: query metrics
    # TODO: index metrics
    # TODO: encoding metrics

    ise_util_pkl = sess_dir / "sess_new" / "table" / "ise_util.pkl"
    ise_util_df = pd.read_pickle(ise_util_pkl)
    # print("ise_util_df", ise_util_df)
    agg_ise_util_df = ise_util_df[pd.isna(ise_util_df["instr"])].iloc[0]
    # print("agg_ise_util_df", agg_ise_util_df)
    n_ise_instrs = agg_ise_util_df["n_total"]
    n_ise_used_static = agg_ise_util_df["n_used_static"]
    n_ise_used_static_rel = agg_ise_util_df["n_used_static_rel"]
    n_ise_used_dynamic = agg_ise_util_df["n_used_dynamic"]
    n_ise_used_dynamic_rel = agg_ise_util_df["n_used_dynamic_rel"]
    util_row = pd.DataFrame(
        [
            {
                "n_ise_instrs": n_ise_instrs,
                "n_ise_used_static": n_ise_used_static,
                "n_ise_used_static_rel": n_ise_used_static_rel,
                "n_ise_used_dynamic": n_ise_used_dynamic,
                "n_ise_used_dynamic_rel": n_ise_used_dynamic_rel,
            }
        ]
    )
    ret = pd.concat([ret, util_row], axis=1)

    # TODO: encoding scores

    return ret


rows = []
for sess_dir in sess_dirs:
    sess_dir = Path(sess_dir)
    assert sess_dir.is_dir()
    sess_df = create_sess_df(sess_dir)
    rows.append(sess_df)


full_df = pd.concat(rows)

if args.print_df:
    with pd.option_context("display.max_rows", None, "display.max_columns", None):
        print(sess_df)
