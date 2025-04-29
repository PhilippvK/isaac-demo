import pickle
import argparse
from pathlib import Path

import networkx as nx
from networkx.drawing.nx_agraph import write_dot
import pandas as pd


def graph_to_file(graph, dest, fmt="auto"):
    if not isinstance(dest, Path):
        dest = Path(dest)
    if fmt == "auto":
        fmt = dest.suffix[1:].upper()
    prog = "dot"
    # TODO: support pkl
    if fmt == "PKL":
        with open(dest, "wb") as f:
            pickle.dump(graph, f)
    elif fmt == "DOT":
        write_dot(graph, dest)
    elif fmt in ["PDF", "PNG"]:
        graph = nx.nx_agraph.to_agraph(graph)
        graph.draw(str(dest), prog=prog)
        graph.close()
    else:
        raise ValueError(f"Unsupported fmt: {fmt}")


def main():
    parser = argparse.ArgumentParser(description="TODO")
    parser.add_argument("report", help="Report CSV file")
    parser.add_argument("--names-csv", default=None, help="ISAX names CSV")
    parser.add_argument("--sess-dir", default=None, help="Sessions base dir")
    parser.add_argument("--progs-graph", default=None, help="TODO")
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
            "used_instrs": set(),
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
            if not sess_prog.is_dir():
                continue
            ise_util_pkl = sess_prog / "table" / "ise_util.pkl"
            if not ise_util_pkl.is_file():
                continue
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
            progs_metrics[prog]["used_instrs"].update(used_instr_names)

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

            # break

        for prog in prog_names:
            progs_metrics[prog]["n_used_instrs"] = len(progs_metrics[prog]["used_instrs"])
            progs_metrics[prog]["n_used_instrs_rel"] = progs_metrics[prog]["n_used_instrs"] / num_instrs

        for instr in instr_names:
            instrs_metrics[instr]["n_used_by_progs"] = len(instrs_metrics[instr]["used_by_progs"])
            instrs_metrics[instr]["n_used_by_progs_rel"] = instrs_metrics[instr]["n_used_by_progs"] / num_progs

        progs_df = pd.DataFrame(progs_metrics).T.sort_values("n_used_instrs", ascending=False)
        progs_agg_data = {
            "runtime_reduction": progs_df["runtime_reduction"].sum(),
            "dyn_custom_count": progs_df["dyn_custom_count"].sum(),
            "dyn_custom_count_rel": progs_df["dyn_custom_count_rel"].sum(),
            "used_instrs": set.union(*list(progs_df["used_instrs"].values)),
            "n_used_instrs": len(set.union(*list(progs_df["used_instrs"].values))),
            "n_used_instrs_rel": len(set.union(*list(progs_df["used_instrs"].values))) / num_instrs,
        }
        progs_agg_df = pd.DataFrame({None: progs_agg_data}).T
        progs_agg_df["avg_n_used_instrs"] = progs_df["n_used_instrs"].mean()
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
        val_counts = (
            instrs_df["n_used_by_progs"]
            .value_counts()
            .reset_index()
            .sort_values("n_used_by_progs", ascending=False)
            .set_index("n_used_by_progs")
        )
        instrs_agg_df["avg_n_used_by_progs"] = instrs_df["n_used_by_progs"].mean()
        num_instrs_used_by_multiple_progs = len(instrs_df[instrs_df["n_used_by_progs"] > 1])
        instrs_agg_df["chance_used_by_multiple"] = num_instrs_used_by_multiple_progs / num_instrs
        instrs_df = pd.concat([instrs_agg_df, instrs_df])
        print("val_counts", val_counts)

        with pd.option_context("display.max_rows", None, "display.max_columns", None, "display.width", 0):
            print("progs_metrics")
            print(progs_df)
            TOPK = 20
            print(
                "\n".join(
                    map(
                        lambda x: f"{x} \\\\",
                        progs_df.rename_axis("prog")
                        .reset_index()
                        .iloc[:TOPK][["prog", "n_used_instrs"]]
                        .dropna()
                        .to_csv(sep="&", index=False)
                        .replace("&", " & ")
                        .splitlines(),
                    )
                ).replace("embench/", "")
            )
            print(",".join(progs_df.iloc[:TOPK].index.dropna()).replace("embench/", ""))
            progs_df = progs_df.sort_values("runtime_reduction", ascending=False)
            TOPK = 20
            print(
                "\n".join(
                    map(
                        lambda x: f"{x} \\\\",
                        progs_df.rename_axis("prog")
                        .reset_index()
                        .iloc[:TOPK][["prog", "runtime_reduction"]]
                        .dropna()
                        .to_csv(sep="&", index=False)
                        .replace("&", " & ")
                        .splitlines(),
                    )
                ).replace("embench/", "")
            )
            print(",".join(progs_df.iloc[:TOPK].index.dropna()).replace("embench/", ""))
            progs_df = progs_df.sort_values("dyn_custom_count_rel", ascending=False)
            TOPK = 20
            print(
                "\n".join(
                    map(
                        lambda x: f"{x} \\\\",
                        progs_df.rename_axis("prog")
                        .reset_index()
                        .iloc[:TOPK][["prog", "dyn_custom_count_rel"]]
                        .dropna()
                        .to_csv(sep="&", index=False)
                        .replace("&", " & ")
                        .splitlines(),
                    )
                ).replace("embench/", "")
            )
            print(",".join(progs_df.iloc[:TOPK].index.dropna()).replace("embench/", ""))
            progs_df = progs_df.sort_values("dyn_custom_count", ascending=False)
            TOPK = 20
            print(
                "\n".join(
                    map(
                        lambda x: f"{x} \\\\",
                        progs_df.rename_axis("prog")
                        .reset_index()
                        .iloc[:TOPK][["prog", "dyn_custom_count"]]
                        .dropna()
                        .to_csv(sep="&", index=False)
                        .replace("&", " & ")
                        .splitlines(),
                    )
                ).replace("embench/", "")
            )
            print(",".join(progs_df.iloc[:TOPK].index.dropna()).replace("embench/", ""))
            print("instrs_metrics")
            print(instrs_df)
            TOPK = 10
            print(
                "\n".join(
                    map(
                        lambda x: f"{x} \\\\",
                        instrs_df.rename_axis("instr")
                        .reset_index()
                        .iloc[:TOPK][["instr", "n_used_by_progs"]]
                        .dropna()
                        .to_csv(sep="&", index=False)
                        .replace("&", " & ")
                        .splitlines(),
                    )
                )
            )
            print(",".join(instrs_df.iloc[:TOPK].index.dropna()))
            instrs_df = instrs_df.sort_values("dyn_count_rel", ascending=False)
            TOPK = 10
            print(
                "\n".join(
                    map(
                        lambda x: f"{x} \\\\",
                        instrs_df.rename_axis("instr")
                        .reset_index()
                        .iloc[:TOPK][["instr", "dyn_count_rel"]]
                        .dropna()
                        .to_csv(sep="&", index=False)
                        .replace("&", " & ")
                        .splitlines(),
                    )
                )
            )
            print(",".join(instrs_df.iloc[:TOPK].index.dropna()))
            instrs_df = instrs_df.sort_values("dyn_count", ascending=False)
            TOPK = 10
            print(
                "\n".join(
                    map(
                        lambda x: f"{x} \\\\",
                        instrs_df.rename_axis("instr")
                        .reset_index()
                        .iloc[:TOPK][["instr", "dyn_count"]]
                        .dropna()
                        .to_csv(sep="&", index=False)
                        .replace("&", " & ")
                        .splitlines(),
                    )
                )
            )
            print(",".join(instrs_df.iloc[:TOPK].index.dropna()))

    if args.progs_graph is not None:
        graph = nx.MultiGraph()
        for i, prog in enumerate(prog_names):
            graph.add_node(i, label=prog)
        from collections import defaultdict

        counts = defaultdict(int)
        for instr, row in instrs_df.iterrows():
            if instr is None:
                continue
            # print("instr", instr)
            used_by_progs = row["used_by_progs"]
            # print("used_by_progs", used_by_progs)
            import itertools

            combs = itertools.combinations(used_by_progs, 2)
            # print("combs", list(combs))
            # print("A", len(combs))
            for prog, prog_ in combs:
                i = prog_names.index(prog)
                j = prog_names.index(prog_)
                # print("i,j", i, j)
                graph.add_edge(i, j, label=instr)
                counts[(i, j)] += 1
            # print("counts", counts)
        multi_graph = graph
        MULTI = False
        # MULTI = True
        if not MULTI:
            graph_ = nx.Graph()
            graph_.add_nodes_from(graph.nodes)
            temp = [(*key, count) for key, count in counts.items()]
            graph_.add_weighted_edges_from(temp, "label")
            graph = graph_
        colors = ["red", "blue", "green", "orange", "yellow"]
        c = nx.community.greedy_modularity_communities(graph, weight="label" if not MULTI else None)
        # c = nx.connected_components(graph)
        c = [[prog_names[x] for x in y] for y in c]
        assert len(c) <= len(colors)
        print("c", c, len(c))
        c_instrs = [{instr for prog in comm for instr in progs_metrics[prog]["used_instrs"]} for comm in c]
        print("c_instrs", c_instrs, len(c_instrs))
        c_instrs_overlaps = {
            (i, j): instrs & instrs_
            for i, instrs in enumerate(c_instrs)
            for j, instrs_ in enumerate(c_instrs)
            if j > i and len(instrs & instrs_) > 0
        }
        print("c_instrs_overlaps", c_instrs_overlaps)
        for i, comm in enumerate(c):
            color = colors[i]
            for prog in comm:
                node = prog_names.index(prog)
                graph.nodes[node].update({"style": "filled", "fillcolor": color})

        print("graph", graph, graph.nodes, graph.edges)
        graph_to_file(graph, args.progs_graph)

    if args.output:
        out_df.to_csv(args.output, index=False)


if __name__ == "__main__":
    main()
