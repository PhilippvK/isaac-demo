#!/usr/bin/env python3
"""Evaluate an ISAAC Embench run on CFU-Playground's VexRiscv Verilator SoC."""

import argparse
import csv
import json
from pathlib import Path
import subprocess
import sys

import yaml


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-dir", type=Path, required=True)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--benchmark-dir", type=Path, required=True)
    parser.add_argument("--support-dir", type=Path, required=True)
    parser.add_argument("--gnu", type=Path, required=True)
    parser.add_argument("--selection", choices=("combined", "filtered_selected"), default="filtered_selected")
    parser.add_argument("--timeout", type=int, default=600)
    parser.add_argument("--instruction-trace", action="store_true")
    parser.add_argument("--runner", choices=("verilator", "renode", "fpga"), default="verilator")
    parser.add_argument("--renode", type=Path)
    parser.add_argument("--vil-dir", type=Path)
    parser.add_argument("--vivado", type=Path)
    parser.add_argument("--board-serial")
    parser.add_argument("--serial-port")
    parser.add_argument("--synthesize-only", action="store_true")
    args = parser.parse_args()
    work = args.run_dir.resolve() / "work"
    if args.runner == "renode" and (args.renode is None or args.vil_dir is None or args.instruction_trace):
        parser.error("Renode requires --renode and --vil-dir; instruction tracing is currently Verilator-only")
    if args.runner == "fpga" and (args.vivado is None or args.instruction_trace):
        parser.error("FPGA requires --vivado; instruction tracing is currently Verilator-only")
    if args.runner == "fpga" and not args.synthesize_only and (not args.board_serial or not args.serial_port):
        parser.error("FPGA execution requires --board-serial and --serial-port")
    if args.synthesize_only and args.runner != "fpga":
        parser.error("--synthesize-only requires --runner fpga")
    output = work / ("cfu_evaluation_" + args.selection + ("_" + args.runner if args.runner != "verilator" else ""))
    index = work / (args.selection + "_index.yml")
    manifest = work / "cfu_manifest.json"
    candidates = yaml.safe_load(index.read_text())["candidates"]
    names = [candidate["properties"]["InstrName"] for candidate in candidates]
    extended_arch = "rv32im_zicsr_zifencei" + (
        "_xisaac" if args.selection == "combined" else
        "".join("_xisaac" + name.lower() + "single" for name in names))
    scripts = Path(__file__).resolve().parent
    compiler = work / "local/seal5/llvm_install/bin/clang"
    def execute(command, stdout=None):
        subprocess.run(list(map(str, command)), check=True, stdout=stdout)
    def python(script, *options):
        execute([sys.executable, scripts / script, *options])
    execute([sys.executable, "-m", "isaac_toolkit.generate.hardware.cfu", "--index", index,
             "--manifest", manifest, "--output", output / "rtl"])
    rtl = output / "rtl/cfu.sv"
    if args.runner == "fpga":
        python("cfu_arty.py", "--root", args.root, "--cfu", rtl, "--output", output / "soc")
    else:
        python("cfu_playground_sim.py", "--root", args.root, "--cfu", rtl,
               "--output", output / "soc")
    if args.runner == "renode":
        bridge = output / "renode_bridge"
        execute(["cmake", "-S", scripts.parent / "cfg/cfu_playground/renode", "-B", bridge,
                 "-DCFU_ROOT=" + str(args.root.resolve()), "-DVIL_DIR=" + str(args.vil_dir.resolve()),
                 "-DCFU_RTL=" + str(rtl)])
        execute(["cmake", "--build", bridge, "-j", "4"])
    rows = []
    for variant, arch in (("baseline", "rv32im_zicsr_zifencei"), ("extended", extended_arch)):
        firmware = output / variant
        python("cfu_build_embench.py", "--compiler", compiler, "--gnu", args.gnu,
               "--benchmark-dir", args.benchmark_dir, "--support-dir", args.support_dir,
               "--soc-json", output / "soc/csr.json", "--arch", arch, "--output", firmware)
        with (firmware / "firmware.dump").open("w") as dump:
            execute([args.gnu.resolve() / "bin/riscv32-unknown-elf-objdump", "-d",
                     firmware / "firmware.elf"], stdout=dump)
        audit_args = ["--baseline"] if variant == "baseline" else []
        python("verify_cfu_disassembly.py", "--dump", firmware / "firmware.dump",
               "--manifest", manifest, "--output", firmware / "encoding_validation.json", *audit_args)
        trace_args = ["--instruction-trace"] if args.instruction_trace else []
        if args.runner == "verilator":
            python("cfu_playground_sim.py", "--root", args.root, "--cfu", rtl,
                   "--output", firmware / "sim", "--run", "--rom-boot",
                   "--firmware", firmware / "firmware.bin", "--success-token", "ISAAC_CFU_BENCH_PASS",
                   "--timeout", args.timeout, *trace_args)
        elif args.runner == "renode":
            python("cfu_renode.py", "--renode", args.renode, "--library", bridge / "libVtop.so",
                   "--firmware", firmware / "firmware.elf", "--soc-json", output / "soc/csr.json",
                   "--output", firmware / "sim", "--timeout", args.timeout)
        else:
            build_args = ["--baseline"] if variant == "baseline" else []
            python("cfu_arty.py", "--root", args.root, "--cfu", rtl,
                   "--firmware", firmware / "firmware.bin", "--output", firmware / "gateware_build",
                   "--vivado", args.vivado, "--build", *build_args)
            if args.synthesize_only:
                continue
            python("cfu_fpga_run.py", "--root", args.root, "--vivado", args.vivado,
                   "--bitstream", firmware / "gateware_build/gateware/digilent_arty.bit",
                   "--board-serial", args.board_serial, "--port", args.serial_port,
                   "--output", firmware / "sim", "--timeout", args.timeout)
        if args.instruction_trace:
            from isaac_toolkit.session import Session
            from isaac_toolkit.frontend.instr_trace.cfu import load_instr_trace
            session_dir = firmware / "trace_session"
            session = Session.from_dir(session_dir) if session_dir.exists() else Session.create(session_dir)
            load_instr_trace(session, firmware / "sim/instruction_trace.csv",
                             firmware / "firmware.dump", manifest, force=True)
            session.save()
        metrics = json.loads((firmware / "sim/benchmark_metrics.json").read_text())
        cycle_field = "model_cycles" if args.runner == "renode" else "cycles"
        if not metrics["validation"] or metrics[cycle_field] <= 0 or metrics["instructions"] <= 0:
            raise ValueError(f"Invalid benchmark metrics: {variant}")
        rows.append({"variant": variant, "arch": arch, "runner": args.runner, "validation": metrics["validation"],
                     cycle_field: metrics[cycle_field], "instructions": metrics["instructions"]})
    if args.runner == "fpga":
        python("cfu_fpga_report.py", "--baseline", output / "baseline/gateware_build",
               "--extended", output / "extended/gateware_build", "--output", output / "resource_comparison.json")
    if args.synthesize_only:
        return
    for row in rows:
        row[cycle_field + "_relative"] = row[cycle_field] / rows[0][cycle_field]
        row["instructions_relative"] = row["instructions"] / rows[0]["instructions"]
    with (output / "compare.csv").open("w") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    print(json.dumps(rows, indent=2))


if __name__ == "__main__":
    main()
