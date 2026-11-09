#!/usr/bin/env python3
"""Compile generated Nailgun RTL and execute a benchmark with bounded runtime."""

import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import time

HERE = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def run(
    core,
    rtl,
    firmware,
    output,
    verilator="verilator",
    max_cycles=100000000,
    timeout=300,
    jobs=4,
    data_wait=0,
):
    rtl = Path(rtl).resolve()
    firmware = Path(firmware).resolve()
    output = Path(output).resolve()
    output.mkdir(parents=True, exist_ok=True)
    (output / "execution.json").write_text(
        json.dumps({"core": core, "passed": False, "status": "preparing"}) + "\n"
    )
    if data_wait < 0:
        raise ValueError("Negative wait states")
    core_dir = rtl / ("CVA5" if core == "cva5" else "VexRiscv_5s")
    if not core_dir.is_dir():
        core_dir = rtl
    sources = [
        (core_dir / x.strip()).resolve()
        for x in (core_dir / "files.txt").read_text().splitlines()
        if x.strip()
    ]
    sources += sorted(core_dir.parent.glob("ISAX_*.sv"))
    sources = list(dict.fromkeys(sources))
    if max_cycles <= 0 or timeout <= 0 or jobs <= 0:
        raise ValueError("Cycle, timeout and job limits must be positive")
    if not sources or not all(p.is_file() for p in sources):
        raise ValueError("Missing generated RTL source files")
    original = {str(p): sha(p) for p in sources}
    if core == "cva5":
        # Keep byte addresses for the simulation RAM instead of the FPGA IP word pins.
        top = next(p for p in sources if p.name == "CVA5_top.v")
        text = top.read_text()
        for name in ("instruction_bram_addr", "data_bram_addr"):
            text, n = re.subn(
                r"wire\s*\[29:0\]\s*" + name + r"\s*;", f"wire [31:0] {name};", text
            )
            if n != 1:
                raise ValueError(
                    "Unexpected CVA5 local RAM address declaration: " + name
                )
        staged = output / "CVA5_top.v"
        staged.write_text(text)
        sources[sources.index(top)] = staged
        wrapper = next(p for p in sources if p.name == "cva5_wrapper_verilog.v")
        text = wrapper.read_text()
        for name in ("instruction_bram_addr", "data_bram_addr"):
            text, n = re.subn(
                r"output wire\s*\[29:0\]\s*" + name, "output wire [31:0] " + name, text
            )
            if n != 1:
                raise ValueError("Unexpected CVA5 wrapper address declaration: " + name)
            old = name + "_long[29:0]"
            if text.count(old) != 1:
                raise ValueError("Unexpected CVA5 wrapper address truncation: " + name)
            text = text.replace(old, name + "_long")
        staged = output / wrapper.name
        staged.write_text(text)
        sources[sources.index(wrapper)] = staged
        # Match the ISAAC scaiev2 native memory width contract (also used on FPGA).
        for i, src in enumerate(sources):
            text = src.read_text()
            old = "assign ls_inputs_scaiev.fn3 = LS_W_fn3; //Full word"
            if old in text:
                text = text.replace(
                    old,
                    "assign ls_inputs_scaiev.fn3 = scaiev.execute_injectLS_potentiallyValid ? scaiev.execute_Instr[14:12] : scaiev_inputs.instruction[14:12];",
                )
                staged = output / src.name
                staged.write_text(text)
                sources[i] = staged
    obj = output / "obj_dir"
    command = [
        verilator,
        "--cc",
        "--exe",
        "--build",
        "-j",
        str(jobs),
        "-Wno-fatal",
        "--top-module",
        "sim_top",
        "-GDATA_WAIT_STATES=" + str(data_wait),
        "--Mdir",
        str(obj),
        "-o",
        "simulator",
        *map(str, sources),
        str(HERE / (core + ".sv")),
        str(HERE / "host.cpp"),
    ]
    version = subprocess.check_output([verilator, "--version"], text=True).strip()
    if core == "cva5" and not re.search(r"Verilator [5-9]\.", version):
        raise ValueError(
            "CVA5 requires modern SystemVerilog support; use pinned Verilator 5.040"
        )
    started = time.monotonic()
    meta = {
        "core": core,
        "verilator_version": version,
        "firmware": str(firmware),
        "firmware_sha256": sha(firmware),
        "rtl_source_sha256": original,
        "staged_rtl_sha256": {str(p): sha(p) for p in sources},
        "adapter_sha256": sha(HERE / (core + ".sv")),
        "host_sha256": sha(HERE / "host.cpp"),
        "compile_command": command,
        "max_cycles": max_cycles,
        "data_wait_states": data_wait,
        "passed": False,
    }
    try:
        with (output / "compile.log").open("w") as log:
            subprocess.run(
                command,
                stdout=log,
                stderr=subprocess.STDOUT,
                check=True,
                timeout=timeout,
            )
        with (output / "uart.log").open("w") as log:
            result = subprocess.run(
                [str(obj / "simulator"), str(firmware), str(max_cycles)],
                stdout=log,
                stderr=subprocess.STDOUT,
                timeout=timeout,
            )
        text = (output / "uart.log").read_text()
        match = re.search(
            r"ISAAC_RTL_RESULT exit=(\d+) cycles=(\d+) retired=(\d+) completed=(\d+) passed=(\d+)",
            text,
        )
        if match:
            meta.update(
                dict(
                    zip(
                        ("exit_status", "cycles", "retired", "completed", "passed"),
                        map(int, match.groups()),
                    )
                )
            )
        meta["passed"] = bool(meta["passed"] and result.returncode == 0)
        meta["returncode"] = result.returncode
    except (subprocess.SubprocessError, OSError) as exc:
        meta["error"] = str(exc)
    meta["elapsed_seconds"] = time.monotonic() - started
    (output / "execution.json").write_text(json.dumps(meta, indent=2) + "\n")
    print(
        json.dumps(
            {
                k: v
                for k, v in meta.items()
                if k
                not in ("rtl_source_sha256", "staged_rtl_sha256", "compile_command")
            },
            indent=2,
        )
    )
    return meta["passed"]


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--core", required=True, choices=["cva5", "vex"])
    p.add_argument("--rtl", type=Path, required=True)
    p.add_argument("--firmware", type=Path, required=True)
    p.add_argument("--output", type=Path, required=True)
    p.add_argument("--verilator", default="verilator")
    p.add_argument("--max-cycles", type=int, default=100000000)
    p.add_argument("--data-wait", type=int, default=0)
    p.add_argument("--timeout", type=int, default=300)
    p.add_argument("--jobs", type=int, default=4)
    a = p.parse_args()
    raise SystemExit(0 if run(**vars(a)) else 1)


if __name__ == "__main__":
    main()
