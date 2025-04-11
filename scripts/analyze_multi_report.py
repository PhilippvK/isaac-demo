import argparse
from pathlib import Path
from typing import Dict, Optional
from collections import defaultdict

import matplotlib.pyplot as plt
import pandas as pd
import yaml


def main():
    parser = argparse.ArgumentParser(description="TODO")
    parser.add_argument("report", help="Report CSV file")
    parser.add_argument("--names-csv", default=None, help="ISAX names CSV")
    parser.add_argument("--sess-dir", default=None, help="Sessions base dir")
    parser.add_argument("-o", "--output", default=None, help="Output csv file")
    args = parser.parse_args()

    assert Path(args.report).is_file()
    report_df = pd.read_csv(args.report)

    # print("report_df", report_df)

    report_len = len(report_df)
    assert report_len % 2 == 0
    num_progs = report_len // 2
    # print("num_progs", num_progs)
    isax_report_df = report_df.iloc[1::2]

    COL = "Run Instructions (rel.)"

    isax_report_df["Runtime Reduction (rel.)"] = (isax_report_df[COL] * -1) + 1
    isax_report_df["Prog"] = isax_report_df["Frontend"] + "/" + isax_report_df["Model"]
    # print("isax_report_df", isax_report_df)

    prog_names = list(isax_report_df["Prog"].values)
    # print("prog_names", prog_names)

    # isax_metrics = {}
    progs_metrics = {
        prog_name: {
            "runtime_reduction": isax_report_df[isax_report_df["Prog"] == prog_name]["Runtime Reduction (rel.)"].iloc[
                0
            ],
            "dyn_custom_count": 0,
            "dyn_custom_count_rel": 0,
            "used_instr_names": set(),
        }
        for prog_name in prog_names
    }

    instrs_metrics = None
    if args.names_csv is not None:
        names_csv = Path(args.names_csv)
        assert names_csv.is_file()
        names_df = pd.read_csv(names_csv)
        # print("names_df", names_df)
        instr_names = list(names_df["instr"].unique())
        num_instrs = len(instr_names)
        instrs_metrics = {
            instr_name: {"dyn_count": 0, "dyn_count_rel": 0, "used_by_progs": set()} for instr_name in instr_names
        }

    # TODO: code size?

    out_df = isax_report_df[["Prog", "Runtime Reduction (rel.)"]]  # .to_records()
    print("out_df", out_df)

    if args.sess_dir is not None:
        sess_base = Path(args.sess_dir)
        assert sess_base.is_dir()

        assert instrs_metrics is not None

        for prog in prog_names:
            sess_prog = sess_base / prog
            # print("sess_prog", sess_prog)
            assert sess_prog.is_dir()
            ise_util_pkl = sess_prog / "table" / "ise_util.pkl"
            ise_util_df = pd.read_pickle(ise_util_pkl)
            # print("ise_util_df", ise_util_df)
            agg_util_df = ise_util_df[pd.isna(ise_util_df["instr"])]
            # print("agg_util_df", agg_util_df)
            assert len(agg_util_df) == 1
            used_instrs_df = ise_util_df[ise_util_df["used_dynamic"] == True]  # TODO: improve
            # print("used_instrs_df", used_instrs_df)
            used_instr_names = set(used_instrs_df["instr"].unique())
            for instr_name in used_instr_names:
                instrs_metrics[instr_name]["used_by_progs"].add(prog)
            progs_metrics[prog]["used_instr_names"].update(used_instr_names)

            dynamic_counts_custom_pkl = sess_prog / "table" / "dynamic_counts_custom.pkl"
            dynamic_counts_custom_df = pd.read_pickle(dynamic_counts_custom_pkl)
            agg_dynamic_counts_custom_df = dynamic_counts_custom_df[pd.isna(dynamic_counts_custom_df["instr"])]
            assert len(agg_dynamic_counts_custom_df) == 1
            agg_dyn_count = agg_dynamic_counts_custom_df["count"].iloc[0]
            agg_dyn_count_rel = agg_dynamic_counts_custom_df["rel_count"].iloc[0]
            progs_metrics[prog]["dyn_custom_count"] += agg_dyn_count
            progs_metrics[prog]["dyn_custom_count_rel"] += agg_dyn_count_rel
            # print("dynamic_counts_custom_df", dynamic_counts_custom_df)
            for _, row in dynamic_counts_custom_df.dropna().iterrows():
                instr_name = row["instr"]
                dyn_count = row["count"]
                if dyn_count < 1:
                    continue
                dyn_count_rel = row["rel_count"]
                instrs_metrics[instr_name]["dyn_count"] += dyn_count
                instrs_metrics[instr_name]["dyn_count_rel"] += dyn_count_rel

            break

        for prog in prog_names:
            progs_metrics[prog]["n_used_instr_names"] = len(progs_metrics[prog]["used_instr_names"])
            progs_metrics[prog]["n_used_instr_names_rel"] = progs_metrics[prog]["n_used_instr_names"] / num_instrs

        for instr in instr_names:
            instrs_metrics[instr]["n_used_by_progs"] = len(instrs_metrics[instr]["used_by_progs"])
            instrs_metrics[instr]["n_used_by_progs_rel"] = instrs_metrics[instr]["n_used_by_progs"] / num_progs

        progs_df = pd.DataFrame(progs_metrics).T.sort_values("n_used_instr_names", ascending=False)
        progs_agg_data = {
            "runtime_reduction": progs_df["runtime_reduction"].sum(),
            "dyn_custom_count": progs_df["dyn_custom_count"].sum(),
            "dyn_custom_count_rel": progs_df["dyn_custom_count_rel"].sum(),
            "used_instr_names": set.union(*list(progs_df["used_instr_names"].values)),
            "n_used_instr_names": len(set.union(*list(progs_df["used_instr_names"].values))),
            "n_used_instr_names_rel": len(set.union(*list(progs_df["used_instr_names"].values))) / num_instrs,
        }
        progs_agg_df = pd.DataFrame({None: progs_agg_data}).T
        progs_df = pd.concat([progs_agg_df, progs_df])

        instrs_df = pd.DataFrame(instrs_metrics).T.sort_values("n_used_by_progs", ascending=False)
        instrs_agg_data = {
            "dyn_count": instrs_df["dyn_count"].sum(),
            "dyn_count_rel": instrs_df["dyn_count_rel"].sum(),
            "used_by_progs": set.union(*list(instrs_df["used_by_progs"].values)),
            "n_used_by_progs": len(set.union(*list(instrs_df["used_by_progs"].values))),
            "n_used_by_progs_rel": len(set.union(*list(instrs_df["used_by_progs"].values))) / num_progs,
        }
        instrs_agg_df = pd.DataFrame({None: instrs_agg_data}).T
        instrs_df = pd.concat([instrs_agg_df, instrs_df])

        with pd.option_context("display.max_rows", None, "display.max_columns", None, "display.width", 0):
            print("progs_metrics")
            print(progs_df)
            print("instrs_metrics")
            print(instrs_df)

    if args.output:
        out_df.to_csv(args.output, index=False)


if __name__ == "__main__":
    main()
