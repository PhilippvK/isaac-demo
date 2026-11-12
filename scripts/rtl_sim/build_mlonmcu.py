#!/usr/bin/env python3
"""Build an arbitrary MLonMCU workload using the native Nailgun MLIF target."""

import argparse
import hashlib
import json
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys

root = Path(__file__).resolve().parents[2]
p = argparse.ArgumentParser(description=__doc__)
p.add_argument("--run", action="store_true")
p.add_argument("--execution", choices=["rtl", "fpga"], default="rtl")
p.add_argument("--fpga-uart-container")
p.add_argument("--fpga-vivado", default="/nfs/tools/xilinx/Vivado/2024.1/bin/vivado")
p.add_argument("--fpga-board-serial", default="210319C08AE1")
p.add_argument("--fpga-port", default="/dev/serial/by-id/usb-Digilent_Digilent_USB_Device_210319C08AE1-if01-port0")
p.add_argument("--core", choices=["vex", "cva5"], default="cva5")
p.add_argument("--rtl", type=Path)
p.add_argument("--verilator", default="verilator")
p.add_argument("--max-cycles", type=int, default=100000000)
p.add_argument("--timeout", type=int, default=600)
p.add_argument("--jobs", type=int, default=4)
p.add_argument("--data-wait", type=int, default=0)
p.add_argument("benchmark")
p.add_argument("output", type=Path)
p.add_argument("--compiler", type=Path, required=True)
p.add_argument("--gnu", type=Path, required=True)
p.add_argument("--arch", required=True)
p.add_argument("--abi", default="ilp32")
p.add_argument("--isel", choices=["dag", "gisel"], default="dag")
p.add_argument("--backend", default="none")
p.add_argument("--optimize", default="3")
p.add_argument("--unroll", default="auto")
p.add_argument("--extra-args", default="")
p.add_argument("--ram-size", type=int, default=262144)
p.add_argument("--stack-size", type=int, default=8192)
p.add_argument("--heap-size", type=int, default=4096)
a = p.parse_args()
out = a.output.resolve()
out.mkdir(parents=True, exist_ok=True)
(out / "build.json").write_text(json.dumps({"status": "incomplete"}) + "\n")
command = [
    sys.executable,
    "-m",
    "mlonmcu.cli.main",
    "flow",
    "run" if a.run else "compile",
    a.benchmark,
    "--target",
    "nailgun",
    "--backend",
    a.backend,
    "-c",
    f"llvm.install_dir={a.compiler.resolve().parent.parent}",
    "-c",
    "mlif.toolchain=llvm",
    "-c",
    f'mlif.global_isel={int(a.isel=="gisel")}',
    "-c",
    f"mlif.optimize={a.optimize}",
    "-c",
    f"mlif.unroll_loops={a.unroll}",
    "-c",
    "run.export_optional=1",
    "-c",
    f"nailgun.arch={a.arch}",
    "-c",
    f"nailgun.abi={a.abi}",
    "-c",
    f"riscv_gcc_rv32.install_dir={a.gnu.resolve()}",
    "-c",
    "riscv_gcc_rv32.name=riscv32-unknown-elf",
    "-c",
    f"nailgun.ram_size={a.ram_size}",
    "-c",
    f"nailgun.stack_size={a.stack_size}",
    "-c",
    f"nailgun.heap_size={a.heap_size}",
    *shlex.split(a.extra_args),
]
if a.run:
    if not a.rtl:
        raise ValueError("--run requires --rtl")
    runtime = {
        "execution": a.execution,
        "runner": root / "scripts/rtl_sim/run.py",
        "fpga_runner": root / "scripts/fpga_syn/run.py",
        "rtl_dir": a.rtl.resolve(),
        "core": a.core,
        "verilator": a.verilator,
        "max_cycles": a.max_cycles,
        "timeout": a.timeout,
        "jobs": a.jobs,
        "data_wait": a.data_wait,
    }
    if a.execution == "fpga":
        runtime.update(fpga_vivado=a.fpga_vivado, fpga_board_serial=a.fpga_board_serial,
                       fpga_port=a.fpga_port)
        if a.fpga_uart_container:
            runtime["fpga_uart_container"] = a.fpga_uart_container
    for name, value in runtime.items():
        command += ["-c", f"nailgun.{name}={value}"]
    command += ["-c", "mlif.fail_on_error=1"]
result = subprocess.run(
    command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
)
print(result.stdout, end="")
if result.returncode:
    raise SystemExit(result.returncode)
sessions = re.findall(r"\[session-(\d+)\]", result.stdout)
if not sessions:
    raise RuntimeError("MLonMCU did not report a session id")
export = out / "mlonmcu"
subprocess.run(
    [
        sys.executable,
        "-m",
        "mlonmcu.cli.main",
        "export",
        "--session",
        sessions[-1],
        "--run",
        "0",
        "-f",
        "--",
        str(export),
    ],
    check=True,
)
elf = export / "generic_mlonmcu"
if not elf.is_file():
    raise RuntimeError("MLIF executable was not exported")
shutil.copyfile(elf, out / "benchmark.elf")
subprocess.run(
    [
        str(a.gnu.resolve() / "bin/riscv32-unknown-elf-objcopy"),
        "-O",
        "binary",
        str(elf),
        str(out / "benchmark.bin"),
    ],
    check=True,
)
commands = json.loads((export / "compile_commands.json").read_text())
exceptions = [
    x["file"]
    for x in commands
    if x["file"].endswith("/lib/bench/bench.c") and a.isel == "gisel"
]
manifest = {
    "status": "complete",
    "build_mode": "native_mlonmcu",
    "command": command,
    "session": int(sessions[-1]),
    "instruction_selector": a.isel,
    "selector_exceptions": exceptions,
    "elf_sha256": hashlib.sha256(elf.read_bytes()).hexdigest(),
    "compile_commands_sha256": hashlib.sha256(
        (export / "compile_commands.json").read_bytes()
    ).hexdigest(),
    "memory": {
        "ram_size": a.ram_size,
        "stack_size": a.stack_size,
        "heap_size": a.heap_size,
    },
}
(out / "build.json").write_text(json.dumps(manifest, indent=2) + "\n")

if a.run:
    for name in ("execution.json", "uart.log", "compile.log", "uart.bin"):
        shutil.copyfile(export / ("nailgun_" + name), out.parent / name)
    for path in export.glob("nailgun_fpga_*"):
        shutil.copyfile(path, out.parent / path.name.removeprefix("nailgun_"))
    import csv

    with (export / "report.csv").open() as stream:
        for row in csv.DictReader(stream):
            if any(
                name.startswith("Validation") and value.strip().lower() == "false"
                for name, value in row.items()
            ):
                metadata = json.loads((out.parent / "execution.json").read_text())
                metadata.update(passed=False, error="MLonMCU validation failed")
                (out.parent / "execution.json").write_text(
                    json.dumps(metadata, indent=2) + "\n"
                )
                raise RuntimeError("MLonMCU reports failed validation")
