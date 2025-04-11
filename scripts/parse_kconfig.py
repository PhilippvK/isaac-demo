import sys
from pathlib import Path
from kconfiglib import Kconfig
import pandas as pd

def parse_kconfig(file_path):
    kconf = Kconfig(file_path)

    results = []
    for sym in kconf.syms.values():
        if sym.name.startswith("SG_") and "_SOL_IDX_" in sym.name:
            config_name = sym.name
            sol_idx = int(config_name.rsplit("_", 1)[1])
            # print("config_name", config_name)
            # print("sym", sym, dir(sym))
            # 'assignable', 'choice', 'config_string', 'custom_str', 'defaults', 'direct_dep', 'env_var', 'implies', 'is_allnoconfig_y', 'is_constant', 'kconfig', 'name', 'name_and_loc', 'nodes', 'orig_defaults', 'orig_implies', 'orig_ranges', 'orig_selects', 'orig_type', 'ranges', 'referenced', 'rev_dep', 'selects', 'set_value', 'str_value', 'tri_value', 'type', 'unset_value', 'user_value', 'visibility', 'weak_rev_dep
            # print("sym.choice", sym.choice)
            # print("sym.config_string", sym.config_string)
            # print("sym.custom_str", sym.custom_str)
            # print("sym.defaults", sym.defaults)
            # print("sym.kconfig", sym.kconfig)
            # print("sym.nodes", sym.nodes)
            # Extract II from the prompt if it exists
            ii = None
            assert len(sym.nodes) == 1
            if sym.nodes and sym.nodes[0].prompt:
                prompt_text = sym.nodes[0].prompt[0]
                if "II=" in prompt_text:
                    ii = int(prompt_text.split("=")[-1].strip())
            # print("ii", ii)

            # ii = int(sym.orig_type == "bool" and sym.prompt[0].split("=")[-1]) if sym.prompt else None

            # Extract values from help text
            instr_latencies = {}
            op_allocs = {}
            overall_latency = None
            area = None
            area_ = None
            total_lifetime = None
            total_decoupled_ops = None
            is_fallback = False
            if sym.nodes and sym.nodes[0].help:
                help_text = sym.nodes[0].help
                for line in help_text.split("\n"):
                    # print(f"line '{line}'")
                    if line.startswith("  "):
                        line = line[2:]
                        op, count = line.split(": ")
                        count = int(count)
                        assert op not in op_allocs
                        op_allocs[op] = count
                    if "latency = " in line:
                        instr = line.split(" latency", 1)[0]
                        latency = int(line.split("=")[-1].strip())
                        instr_latencies[instr] = latency
                    elif "Overall latency:" in line:
                        overall_latency = float(line.split(":")[-1].strip())
                    elif "Area estimate w/o lifetimes:" in line:
                        area = float(line.split(":")[-1].strip())
                    elif "Area estimate w/ lifetimes:" in line:
                        area_ = float(line.split(":")[-1].strip())
                    elif "Total lifetime:" in line:
                        total_lifetime = float(line.split(":")[-1].strip())
                    elif "Total decoupled ops:" in line:
                        total_decoupled_ops = float(line.split(":")[-1].strip())
                    elif "heuristic fallback solution" in line:
                        is_fallback = True

            if is_fallback:
                assert sol_idx == 0
            results.append({
                "config": config_name,
                "idx": sol_idx,
                "II": ii,
                "Fallback": is_fallback,
                "Instruction latencies": instr_latencies,
                "Allocation": op_allocs,
                "Overall latency": overall_latency,
                "Area estimate w/o lifetimes": area,
                "Area estimate w/ lifetimes": area_,
                "Total lifetime": total_lifetime,
                "Total decoupled ops": total_decoupled_ops,
            })

    return results

# Example usage
# file_path = "/work/git/tuda/isax-tools-integration5/nailgun/outputs/run_24/Kconfig"
assert len(sys.argv) in [2, 3]
file_path = Path(sys.argv[1])
assert file_path.is_file()
parsed_data = parse_kconfig(file_path)
# for entry in parsed_data:
#     print(entry)
df = pd.DataFrame(parsed_data)
print(df)
if len(sys.argv) == 3:
    out_file = Path(sys.argv[2])
    df.to_csv(out_file, index=True)
