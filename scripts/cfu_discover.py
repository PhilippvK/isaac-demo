#!/usr/bin/env python3
"""Benchmark/trace baseline firmware on VexRiscv for ISAAC candidate discovery."""

import argparse
import json
from pathlib import Path
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--compiler", type=Path, required=True)
    parser.add_argument("--gnu", type=Path, required=True)
    parser.add_argument("--benchmark-dir", type=Path, required=True)
    parser.add_argument("--support-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--trace", action="store_true")
    parser.add_argument("--timeout", type=int, default=600)
    args = parser.parse_args()
    output = args.output.resolve()
    scripts = Path(__file__).resolve().parent
    rtl = scripts.parent / "cfg/cfu_playground/baseline.sv"
    def python(script, *options):
        subprocess.run(list(map(str, [sys.executable, scripts / script, *options])), check=True)
    python("cfu_playground_sim.py", "--root", args.root, "--cfu", rtl, "--output", output / "soc")
    python("cfu_build_embench.py", "--compiler", args.compiler, "--gnu", args.gnu,
           "--benchmark-dir", args.benchmark_dir, "--support-dir", args.support_dir,
           "--soc-json", output / "soc/csr.json", "--output", output, "--discovery")
    with (output / "firmware.dump").open("w") as dump:
        subprocess.run([str(args.gnu.resolve() / "bin/riscv32-unknown-elf-objdump"),
                        "-d", str(output / "firmware.elf")], check=True, stdout=dump)
    trace_args = ["--instruction-trace"] if args.trace else []
    python("cfu_playground_sim.py", "--root", args.root, "--cfu", rtl, "--output", output / "sim",
           "--run", "--rom-boot", "--firmware", output / "firmware.bin",
           "--success-token", "ISAAC_CFU_BENCH_PASS", "--timeout", args.timeout, *trace_args)
    if args.trace:
        metadata = {"schema": 1, "runner": "verilator", "start_func": "benchmark",
                    "end_func": "cfu_benchmark_end", "operand_values": "not captured"}
        (output / "cfu_discovery.json").write_text(json.dumps(metadata, indent=2) + "\n")


if __name__ == "__main__":
    main()
