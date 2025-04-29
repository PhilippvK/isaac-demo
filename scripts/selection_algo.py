import os
import subprocess
import pickle
import argparse
import tempfile
from pathlib import Path

import pandas as pd
import matplotlib.pyplot as plt
import yaml

# ETISS_INSTALL_DIR = "/work/git/isaac-demo/out/embench/crc32/20250410T223344/work/docker/etiss/etiss_install"
# LLVM_INSTALL_DIR = "/work/git/isaac-demo/out/embench/crc32/20250410T223344/work/docker/seal5/llvm_install"
LABEL = "my_label"
# BENCH = "embench/crc32"

MLONMCU_WRAPPER_SCRIPT = "scripts/mlonmcu_wrapper.sh"

cached_mlonmcu_metrics = {}

# USE_MLONMCU = False
# USE_MLONMCU = True


def get_arch(nodes, spec_graph):
    archs = [spec_graph.nodes[node]["arch"] for node in nodes]
    return "_".join(archs)


def run_mlonmcu(progs, archs, global_artifacts):
    all_metrics = {}
    pending_archs = []
    # pending_progs = []
    progs_str = ";".join(progs)
    for arch_str in archs:
        metrics = cached_mlonmcu_metrics.get((progs_str, arch_str), None)
        if metrics is not None:
            all_metrics[arch_str] = metrics
        else:
            pending_archs.append(arch_str)
    # print("pending_archs", pending_archs)
    # print("all_metrics", all_metrics)
    pending_archs = [x if x.startswith("rv") or x.startswith("_") else f"_{x}" for x in pending_archs]
    if len(pending_archs) == 0:
        return all_metrics
    archs_file_content = "\n".join(pending_archs)
    # print("arch_file_conent\n", archs_file_content)
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_dir = Path(temp_dir)
        # print("temp_dir", temp_dir)
        archs_file = temp_dir / "extra_archs.txt"
        # print("archs_file", archs_file)
        with open(archs_file, "w") as f:
            f.write(archs_file_content)
        mlonmcu_wrapper_env = {
            "ETISS_INSTALL_DIR": global_artifacts["ETISS_INSTALL_DIR"],
            "LLVM_INSTALL_DIR": global_artifacts["LLVM_INSTALL_DIR"],
            "LABEL": LABEL,
            "MEM_ONLY": str(0),
            "ARCHS_FILE": archs_file,
        }
        env = os.environ.copy()
        env.update(mlonmcu_wrapper_env)
        mlonmcu_wrapper_args = [MLONMCU_WRAPPER_SCRIPT, temp_dir, *progs]
        subprocess.run(mlonmcu_wrapper_args, check=True, env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        # subprocess.run(mlonmcu_wrapper_args, check=True, env=env)
        report_file = temp_dir / "report.csv"
        report_df = pd.read_csv(report_file)
        # print("report_df")
        # print(report_df)
        COLS = ["Run Instructions"]
        # total_metrics = {arch: {col: 0} for col in COLS for arch in pending_archs}
        assert len(report_df) == len(pending_archs) * len(progs)
        # for i, row in report_df.iterrows():
        #     COLS = ["Run Instructions"]
        #     filtered_cols = row[COLS]
        #     print("filtered_cols", filtered_cols)
        #     metrics = filtered_cols.to_dict()
        #     print("metrics", metrics)
        #     key = pending[i]
        #     if key.startswith("_"):
        #         key = key[1:]
        #     all_metrics[key] = metrics
        #     cached_mlonmcu_metrics[key] = metrics
        report_df["arch"] = report_df.apply(lambda row: pending_archs[int(row.name) % len(pending_archs)], axis=1)
        report_df["prog"] = report_df.apply(lambda row: progs[int(row.name) // len(pending_archs)], axis=1)
        metrics_df = report_df[["arch", "prog", *COLS]]
        # print("metrics_df", metrics_df)
        for arch, arch_df in metrics_df.groupby("arch"):
            # print("arch", arch)
            # print("arch_df", arch_df)
            if arch.startswith("_"):
                arch = arch[1:]
            all_metrics[arch] = arch_df
            cached_mlonmcu_metrics[progs_str, arch] = metrics
    return all_metrics


def plot_progress(iters, benefits, costs, max_cost=None, stop_benefit=None, max_iters=None):

    # Create some mock data
    # t = np.arange(0.01, 10.0, 0.01)
    # data1 = np.exp(t)
    # data2 = np.sin(2 * np.pi * t)

    fig, ax1 = plt.subplots()

    color = "tab:blue"
    ax1.set_xlabel("iter")
    ax1.set_ylabel("benefit", color=color)
    ax1.plot(iters, benefits, color=color)
    ax1.tick_params(axis="y", labelcolor=color)
    if stop_benefit is not None:
        ax1.plot([iters[0], iters[-1]], [stop_benefit, stop_benefit], "--", color=color)

    ax2 = ax1.twinx()  # instantiate a second Axes that shares the same x-axis

    color = "tab:red"
    ax2.set_ylabel("cost", color=color)  # we already handled the x-label with ax1
    ax2.plot(iters, costs, color=color)
    ax2.tick_params(axis="y", labelcolor=color)
    if max_cost is not None:
        ax2.plot([iters[0], iters[-1] if max_iters is None else max_iters], [max_cost, max_cost], "--", color=color)
        ax2.set_ylim(None, max_cost * 1.1)

    if max_iters is not None:
        ax1.set_xlim(right=max_iters)

    fig.tight_layout()  # otherwise the right y-label is slightly clipped
    return fig
    # plt.show()


def main():
    parser = argparse.ArgumentParser(description="Iterative algorithm to select which candidates should be used.")
    parser.add_argument("index_file", help="Index YAML file")
    parser.add_argument("--spec-graph", default=None, help="Spec Graph PKL file")
    parser.add_argument("-o", "--output", default=None, help="Output YAML file")
    parser.add_argument("--plot", default=None, help="Plot file")
    parser.add_argument("--sankey", default=None, help="Output Sankey file")
    parser.add_argument("--benchmark", default=None, help="Program Name")
    parser.add_argument("--use-mlonmcu", action="store_true", help="Use MLonMCU")
    parser.add_argument("--max-cost", type=float, default=None, help="Maximum allowed (estimated) cost")
    parser.add_argument(
        "--stop-benefit", type=float, default=None, help="Stop selection when benefit is enough (to safe resources)"
    )
    parser.add_argument(
        "--instr-benefit-func",
        default="speedup_per_instr",
        choices=["speedup_per_instr", "multi_speedup_per_instr", "util_score_per_instr", "multi_util_score_per_instr"],
        help="Benefit Function (fast)",
    )
    parser.add_argument(
        "--total-benefit-func",
        default="speedup",
        choices=[
            "speedup",
            "util_score",
            "speedup_per_instr_sum",
            "multi_speedup_per_instr_sum",
            "util_score_per_instr_sum",
            "multi_util_score_per_instr_sum",
        ],
        help="Benefit Function (slow)",
    )
    parser.add_argument(
        "--instr-cost-func",
        default="enc_weight",
        choices=["enc_weight_per_instr", "hls_area_per_instr", "hls_shared_area_per_instr"],
        help="Cost Function (fast)",
    )
    parser.add_argument(
        "--total-cost-func",
        default="enc_weight",
        choices=[
            "enc_weight",
            "enc_weight_per_instr_sum",
            "hls_area",
            "hls_area_per_instr_sum",
            "hls_shared_area",
            "hls_shared_area_per_instr_sum",
            "asip_area",
            "asip_area",
            "asip_shared_area",
            "fpga_luts",
            "fpga_shared_luts",
        ],
        help="Cost Function (slow)",
    )
    args = parser.parse_args()

    index_file = Path(args.index_file)
    assert index_file.is_file()
    with open(index_file, "r") as f:
        index_data = yaml.safe_load(f)
    global_artifacts = index_data["global"]["artifacts"]
    if isinstance(global_artifacts, list):
        assert len(global_artifacts) == 0
        global_artifacts = {}
    candidates = index_data["candidates"]
    num_candidates = len(candidates)
    # print("num_candidates", num_candidates)

    # node_attrs = {f"c{i}": candidate["metrics"] for i, candidate in enumerate(candidates)}
    node_attrs = {i: candidate["metrics"] for i, candidate in enumerate(candidates)}
    node_instr = {i: candidate["properties"]["InstrName"] for i, candidate in enumerate(candidates)}
    # print("node_instr", node_instr)
    # input(">")

    def node_cost_func(attrs, func: str = "unknown"):
        if func == "enc_weight_per_instr":
            cost = attrs["enc_weight"]
        elif func == "hls_area_per_instr":
            cost = attrs["hls_area"]
        else:
            raise NotImplementedError(f"Instr Cost Func: {func}")
        return cost

    def node_benefit_func(attrs, func: str = "unknown"):
        if func == "speedup_per_instr":
            benefit = attrs["runtime_reduction_rel"]
        elif func == "multi_speedup_per_instr":
            benefit = attrs["multi_runtime_reduction_rel"]
        elif func == "util_score_per_instr":
            benefit = attrs["util_score"]
        elif func == "multi_util_score_per_instr":
            benefit = attrs["multi_util_score"]
        else:
            raise NotImplementedError(f"Instr Benefit Func: {func}")
        return benefit

    def node_ratio_func(attrs, func: str = "default"):
        if func == "default":
            ratio = attrs["benefit"] / attrs["cost"]
        else:
            raise NotImplementedError(f"Instr Ratio Func: {func}")
        return ratio

    for node, attrs in node_attrs.items():
        attrs["benefit"] = node_benefit_func(attrs, func=args.instr_benefit_func)
        attrs["cost"] = node_cost_func(attrs, func=args.instr_cost_func)
        attrs["ratio"] = node_ratio_func(attrs)

    for node, instr in node_instr.items():
        node_attrs[node]["instr"] = instr
        instr_lower = instr.lower()
        node_attrs[node]["arch"] = f"xisaac{instr_lower}single"

    # print("node_attrs", node_attrs)

    spec_graph = None
    if args.spec_graph is not None:
        graph_file = Path(args.spec_graph)
        assert graph_file.is_file()
        with open(graph_file, "rb") as f:
            spec_graph = pickle.load(f)
    # print("spec_graph", spec_graph)

    def annotate_nodes(graph, node_attrs):
        # print("graph.nodes", graph.nodes)
        for node, attrs in node_attrs.items():
            # print("node", node)
            assert node in graph.nodes
            graph.nodes[node].update(attrs)

    annotate_nodes(spec_graph, node_attrs)
    # print("?", {i: spec_graph.nodes[i]["arch"] for i in spec_graph.nodes})
    # input("!")

    sort_by = "ratio"
    # sort_by = "runtime_reduction_rel"  # TODO: revert
    priority_queue = list(reversed(sorted(list(spec_graph.nodes), key=lambda x: spec_graph.nodes[x][sort_by])))
    # print("priority_queue", priority_queue)

    S_cur = set()
    B_cur = 0
    C_cur = 0

    C_max = args.max_cost
    B_stop = args.stop_benefit
    iters = []
    benefits_history = []
    costs_history = []

    i = 0
    STOP_ITERS = 1000
    max_iters = min(STOP_ITERS, len(priority_queue))
    while len(priority_queue) > 0:
        if i >= STOP_ITERS:
            print("abort (stop iters reached)")
            break
        if args.plot:
            iters.append(i)
            benefits_history.append(B_cur)
            costs_history.append(C_cur)
            fig = plot_progress(
                iters, benefits_history, costs_history, max_cost=C_max, stop_benefit=B_stop, max_iters=max_iters
            )
            fig.savefig(args.plot, dpi=300)
        i += 1
        # print("LOOP")
        node = priority_queue.pop(0)
        print("node", node)
        print("remaining", len(priority_queue))
        attrs = node_attrs[node]
        print("attrs", attrs)

        def get_specs(spec_graph, node):
            return set(spec_graph.successors(node))

        specs = get_specs(spec_graph, node)
        print("specs", specs)
        S_temp = (S_cur - specs) | {node}
        print("S_temp", S_temp)

        def mlonmcu_metrics2benefits(mlonmcu_metrics, base, compare):
            # print("mlonmcu_metrics2benefits")
            # benefits = {}
            # print("mlonmcu_metrics", mlonmcu_metrics)
            base_df = mlonmcu_metrics[base].copy().reset_index()
            benefits_df = mlonmcu_metrics[compare].copy().reset_index()
            assert len(base_df) == len(benefits_df)
            benefits_df["runtime_reduction"] = base_df["Run Instructions"] - benefits_df["Run Instructions"]
            benefits_df["runtime_reduction_rel"] = benefits_df["runtime_reduction"] / base_df["Run Instructions"]
            # print("benefits_df", benefits_df)
            total_benefits_df = benefits_df[["runtime_reduction", "runtime_reduction_rel"]].sum(axis=0)
            # print("total_benefits_df", total_benefits_df)

            # benefits["runtime_reduction_rel"] = (
            #     # 1 - mlonmcu_metrics[compare]["Run Instructions"] / mlonmcu_metrics[base]["Run Instructions"]
            #     1 - mlonmcu_metrics[compare]["Run Instructions"] / mlonmcu_metrics[base]["Run Instructions"]
            # )
            benefits = {"runtime_reduction_rel": total_benefits_df["runtime_reduction_rel"]}
            # print("benefits", benefits)
            # input("!!")
            return benefits

        # def calc_total_benefit(nodes, spec_graph, use_mlonmcu: bool = False):
        def calc_total_benefit(nodes, spec_graph, func: str = "unknown"):
            if func == "speedup":
                ARCH_none = ""
                ARCH_cur = get_arch(nodes, spec_graph)
                assert args.benchmark is not None
                benchmarks = args.benchmark.split(";")
                mlonmcu_metrics = run_mlonmcu(benchmarks, [ARCH_none, ARCH_cur], global_artifacts)
                mlonmcu_benefits = mlonmcu_metrics2benefits(mlonmcu_metrics, ARCH_none, ARCH_cur)
                benefit = mlonmcu_benefits["runtime_reduction_rel"]
            elif func == "speedup_per_instr_sum":
                benefit = sum([spec_graph.nodes[node]["runtime_reduction_rel"] for node in nodes])
            elif func == "multi_speedup_per_instr_sum":
                benefit = sum([spec_graph.nodes[node]["multi_runtime_reduction_rel"] for node in nodes])
            else:
                raise NotImplementedError(f"Total Benefit Func: {func}")
            return benefit

        def calc_total_cost(nodes, spec_graph, func: str = "unknown"):
            if func == "enc_weight_per_instr_sum":
                cost = sum([spec_graph.nodes[node]["enc_weight"] for node in nodes])
            elif func == "hls_area_per_instr_sum":
                cost = sum([spec_graph.nodes[node]["hls_area"] for node in nodes])
            elif func == "asip_area_per_instr_sum":
                cost = sum([spec_graph.nodes[node]["asip_area"] for node in nodes])
            elif func == "fpga_luts_instr_sum":
                cost = sum([spec_graph.nodes[node]["fpga_luts"] for node in nodes])
            else:
                raise NotImplementedError(f"Total Cost Func: {func}")
            return cost

        # B_temp = calc_total_benefit(S_temp, spec_graph, use_mlonmcu=args.use_mlonmcu)
        B_temp = calc_total_benefit(S_temp, spec_graph, func=args.total_benefit_func)
        print("B_temp", B_temp)
        C_temp = calc_total_cost(S_temp, spec_graph, func=args.total_cost_func)
        print("C_temp", C_temp)
        if C_max is not None and C_temp > C_max:
            print("if1 (cost too high)")
            continue
            # TODO: do this step also after the final iteration
            # TODO: try to drop potential overlapping or conflicting candidates
            # conflicts = get_conflicts(conflict_graph, S_temp)
            # overlaps = get_overlaps(overlaps_graph, S_temp)
            # dropping_candidates =
            # for candidate in dropping_candidates:
            #     # try to remove candidate
            #     # S_new = ...
            #     # B_new = ...
            #     # C_new = ...
            #     # if B_new < B_temp: continue
            #     # if C_new > C_max: continue
            #     # S_temp = S_new
            #     # B_temp = B_new
            #     # C_temp = C_new
            #     # ...
        EPS = 0.001
        if B_temp >= (B_cur + EPS):
            print("if2 (benefit is higher)")
            S_cur = S_temp
            B_cur = B_temp
            C_cur = C_temp
            print("S_cur", S_cur)
            print("B_cur", B_cur)
            print("C_cur", C_cur)
            if B_stop is not None:
                if B_temp >= B_stop:
                    print("if3 (benefit stop value reached)")
                    break
            priority_queue = [node for node in priority_queue if node not in specs]
    if args.plot:
        iters.append(i)
        benefits_history.append(B_cur)
        costs_history.append(C_cur)
        fig = plot_progress(
            iters, benefits_history, costs_history, max_cost=C_max, stop_benefit=B_stop, max_iters=max_iters
        )
        fig.savefig(args.plot, dpi=300)
    print("done")
    print("S_cur", S_cur)
    print("B_cur", B_cur)
    print("C_cur", C_cur)

    S_final = S_cur
    # B_final = calc_total_benefit(S_final, spec_graph, use_mlonmcu=True)
    # C_final = calc_total_cost(S_final, spec_graph)
    # print("S_final", S_final)
    # print("B_final", B_final)
    # print("C_final", C_final)

    # S_all = set(spec_graph.nodes)
    # B_all = calc_total_benefit(S_all, spec_graph, use_mlonmcu=True)
    # C_all = calc_total_cost(S_all, spec_graph)
    # print("S_all", S_all)
    # print("B_all", B_all)
    # print("C_all", C_all)

    # ARCH_none = ""
    # ARCH_final = get_arch(S_final, spec_graph)
    # ARCH_all = get_arch(S_all, spec_graph)

    # print("ARCH_none", ARCH_none)
    # print("ARCH_final", ARCH_final)
    # print("ARCH_all", ARCH_all)

    new_index_data = index_data.copy()
    if len(S_final) < num_candidates:
        candidates = [candidate for i, candidate in enumerate(candidates) if i in S_final]
    new_index_data["candidates"] = candidates

    assert args.output is not None
    with open(args.output, "w") as f:
        yaml.dump(new_index_data, f)

    if args.sankey is not None:
        # logger.info("Exporting sankey diagram...")
        fmt = Path(args.sankey).suffix
        assert fmt in [".md"]
        content = """
```mermaid
---
config:
  sankey:
    showValues: true
---
sankey-beta

%% source,target,value
"""
        num_selected = len(S_final)
        num_dropped = num_candidates - num_selected
        content += f"Candidates,Selected,{num_selected}\n"
        content += f"Candidates,Dropped,{num_dropped}\n"
        content += """
```
"""
        with open(args.sankey, "w") as f:
            f.write(content)


if __name__ == "__main__":
    main()
