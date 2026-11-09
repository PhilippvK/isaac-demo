#!/usr/bin/env python3
"""Rebuild an exported MLIF benchmark for the simulated Nailgun core.

Replay compilation options, replacing only ETISS platform code and linker/runtime.
Source paths must still exist; --path-map OLD=NEW supports relocated exports.
"""

import argparse
import hashlib
import json
from pathlib import Path
import shlex
import subprocess

ROOT = Path(__file__).resolve().parents[2]
RUNTIME = Path(__file__).resolve().parent / "runtime"


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def build(
    commands, output, gnu, compiler=None, mappings=(), arch=None, abi=None, isel=None
):
    output = Path(output).resolve()
    output.mkdir(parents=True, exist_ok=True)
    (output / "build.json").write_text(json.dumps({"status": "incomplete"}) + "\n")
    entries = json.loads(Path(commands).read_text())
    records, objects, skipped = [], [], []

    def remap(value):
        for old, new in mappings:
            value = value.replace(old, new)
        return value

    def run(cmd, source):
        records.append(
            {"command": cmd, "source": str(source), "source_sha256": sha(source)}
        )
        subprocess.run(cmd, check=True)

    for i, entry in enumerate(entries):
        source = Path(remap(entry["file"]))
        # The ETISS CRT, libc fixes, and trap handler are replaced as a unit.
        if "/cmake/targets/etiss/" in str(source) or str(source).endswith(
            "/lib/targets/etiss.c"
        ):
            skipped.append(str(source))
            continue
        args = entry.get("arguments") or shlex.split(entry["command"])
        args = [remap(x) for x in args]
        if any("MLONMCU_SKIP_CHECK" in x for x in args):
            raise ValueError("Benchmark correctness check is disabled in this export")
        cleaned = [str(Path(compiler).resolve()) if compiler else args[0]]
        j = 1
        while j < len(args):
            arg = args[j]
            if arg in ("-o", "-MF", "-MT", "-MQ"):
                j += 2
                continue
            if arg in ("-c", "-MD", "-MMD", "-MP") or arg == str(source):
                j += 1
                continue
            if arg == "-DMLONMCU_TARGET_ETISS":
                arg = "-DMLONMCU_TARGET_RTL_SIM"
            # Resolve relative include paths against the exported compile directory.
            if (
                arg.startswith("-I")
                and len(arg) > 2
                and not Path(arg[2:]).is_absolute()
            ):
                arg = "-I" + str(Path(remap(entry["directory"])) / arg[2:])
            if arg.startswith("-march=") and arch:
                arg = "-march=" + arch
            if arg.startswith("-mabi=") and abi:
                arg = "-mabi=" + abi
            cleaned.append(arg)
            j += 1
        if isel:
            selected = [cleaned[0]]
            j = 1
            while j < len(cleaned):
                arg = cleaned[j]
                if arg in ("-fglobal-isel", "-fno-global-isel"):
                    j += 1
                    continue
                if arg == "-mllvm" and j + 1 < len(cleaned) and cleaned[j + 1].startswith(
                    ("-global-isel=", "-global-isel-abort=")
                ):
                    j += 2
                    continue
                selected.append(arg)
                j += 1
            # -fglobal-isel appends abort=2 inside Clang, overriding user -mllvm
            # options. Set backend options directly, as MLIF does when tracing.
            cleaned = selected + ["-mllvm", "-global-isel=" + str(int(isel == "gisel"))]
            if isel == "gisel":
                cleaned += ["-mllvm", "-global-isel-abort=1"]
        obj = output / f"benchmark_{i}.o"
        run([*cleaned, "-c", str(source), "-o", str(obj)], source)
        objects.append(obj)
    if not any(str(r["source"]).endswith("/generic/main.c") for r in records):
        raise ValueError("Expected MLIF generic main with benchmark verification")
    gcc = str(Path(gnu).resolve() / "bin/riscv32-unknown-elf-gcc")
    base = [
        gcc,
        "-march=rv32im_zicsr_zifencei",
        "-mabi=ilp32",
        "-O2",
        "-ffunction-sections",
        "-fdata-sections",
    ]
    for name in ("start.S", "platform.c"):
        src = RUNTIME / name
        obj = output / (name + ".o")
        run([*base, "-c", str(src), "-o", str(obj)], src)
        objects.append(obj)
    elf = output / "benchmark.elf"
    link = [
        *base,
        "-nostartfiles",
        "-Wl,--gc-sections",
        "-Wl,--no-relax",
        "-T",
        str(RUNTIME / "link.ld"),
        "-Wl,-Map=" + str(output / "benchmark.map"),
        *map(str, objects),
        "-Wl,--start-group",
        "-lc",
        "-lm",
        "-lgcc",
        "-Wl,--end-group",
        "-o",
        str(elf),
    ]
    subprocess.run(link, check=True)
    subprocess.run(
        [
            str(Path(gnu).resolve() / "bin/riscv32-unknown-elf-objcopy"),
            "-O",
            "binary",
            str(elf),
            str(output / "benchmark.bin"),
        ],
        check=True,
    )
    tools = {}
    for tool in dict.fromkeys([r["command"][0] for r in records]):
        tools[tool] = {
            "sha256": sha(tool),
            "version": subprocess.check_output(
                [tool, "--version"], text=True
            ).splitlines()[0],
        }
    manifest = {
        "status": "complete",
        "tools": tools,
        "compile_commands": str(Path(commands).resolve()),
        "compile_commands_sha256": sha(commands),
        "compilation": records,
        "skipped_platform_sources": skipped,
        "link_command": link,
        "linker_sha256": sha(RUNTIME / "link.ld"),
        "elf_sha256": sha(elf),
        "instruction_selector": isel or "preserved from compile commands",
        "runtime": "RTL MMIO, 256 KiB at 0x80000000; original benchmark checks retained",
    }
    (output / "build.json").write_text(json.dumps(manifest, indent=2) + "\n")
    return elf


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("compile_commands", type=Path)
    p.add_argument("output", type=Path)
    p.add_argument("--gnu", type=Path, default=ROOT / "install/gnu_cfu")
    p.add_argument("--isel", choices=["dag", "gisel"])
    p.add_argument("--compiler")
    p.add_argument("--arch")
    p.add_argument("--abi")
    p.add_argument("--path-map", action="append", default=[])
    a = p.parse_args()
    build(
        a.compile_commands,
        a.output,
        a.gnu,
        a.compiler,
        [x.split("=", 1) for x in a.path_map],
        a.arch,
        a.abi,
        a.isel,
    )


if __name__ == "__main__":
    main()
