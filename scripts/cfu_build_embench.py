#!/usr/bin/env python3
"""Build Embench firmware for the CFU-Playground ROM-boot simulation target."""

import argparse
import hashlib
import json
import shlex
from pathlib import Path
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", type=Path, required=True)
    parser.add_argument("--gnu", type=Path, required=True)
    parser.add_argument("--benchmark-dir", type=Path, required=True)
    parser.add_argument("--support-dir", type=Path, required=True)
    parser.add_argument("--soc-json", type=Path, required=True)
    parser.add_argument("--arch", default="rv32im_zicsr_zifencei")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--discovery", action="store_true", help="Emit LLVM BB labels and discovery artifact metadata")
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    gnu = args.gnu.resolve()
    gcc = gnu / "bin/riscv32-unknown-elf-gcc"
    soc = json.loads(args.soc_json.read_text())
    if soc["constants"]["config_cpu_reset_addr"] != 0 or soc["constants"]["config_csr_data_width"] != 32:
        parser.error("Runtime requires reset at zero and 32-bit CSRs")
    names = {"CFU_UART_TXFULL": "uart_txfull", "CFU_UART_RXTX": "uart_rxtx",
             "CFU_UART_TXEMPTY": "uart_txempty", "CFU_SIM_FINISH": "sim_finish_finish"}
    (output / "cfu_soc.h").write_text("\n".join(
        f"#define {name} {soc['csr_registers'][register]['addr']}u" for name, register in names.items()) + "\n")
    ram = soc["memories"]["main_ram"]
    rom = soc["memories"]["rom"]
    linker = output / "link.ld"
    linker.write_text(f'''OUTPUT_ARCH(riscv)
ENTRY(_start)
MEMORY {{
 ROM (rx) : ORIGIN = 0, LENGTH = {rom['size']}
 RAM (rwx) : ORIGIN = {ram['base']}, LENGTH = {ram['size']}
}}
SECTIONS {{
 .text : {{ KEEP(*(.text.start)) *(.text*) . = ALIGN(4); }} > ROM
 .rodata : {{ *(.rodata*) . = ALIGN(4); }} > ROM
 .data : {{ _data_start = .; *(.data*) *(.sdata*) . = ALIGN(4); _data_end = .; }} > RAM AT > ROM
 _data_load = LOADADDR(.data);
 .bss (NOLOAD) : {{ . = ALIGN(4); _bss_start = .; *(.bss*) *(.sbss*) *(COMMON) . = ALIGN(4); _bss_end = .; }} > RAM
 __global_pointer$ = _data_start + 0x800;
 _stack_top = ORIGIN(RAM) + LENGTH(RAM);
 /DISCARD/ : {{ *(.eh_frame*) *(.comment*) }}
}}
''')
    runtime = Path(__file__).resolve().parents[1] / "cfg/cfu_playground/runtime"
    common = ["-O3", "-g", "-mabi=ilp32", "-ffunction-sections", "-fdata-sections", "-fno-unroll-loops",
              "-DNDEBUG", "-DCPU_MHZ=1", "-I" + str(args.support_dir.resolve()), "-I" + str(output)]
    sources = sorted(args.benchmark_dir.resolve().glob("*.c")) + [args.support_dir.resolve() / "beebsc.c"]
    if len(sources) < 2:
        parser.error("No benchmark sources found")
    commands, objects, hashes, compile_commands = [], [], {}, []
    def execute(command):
        command = list(map(str, command))
        commands.append(command)
        subprocess.run(command, check=True)
    for number, source in enumerate(sources + [runtime / "start.S", runtime / "embench.c"]):
        obj = output / f"source{number}.o"
        hashes[str(source)] = hashlib.sha256(source.read_bytes()).hexdigest()
        if source.parent == runtime:
            command = [gcc, "-march=rv32im_zicsr_zifencei"]
        else:
            command = [args.compiler.resolve(), "--target=riscv32", "--gcc-toolchain=" + str(gnu),
                       "--sysroot=" + str(gnu / "riscv32-unknown-elf"), "-march=" + args.arch]
            if args.discovery:
                command += ["-fbasic-block-sections=labels"]
        flags = common + (["-DCFU_DISCOVERY=1"] if args.discovery else [])
        compile_command = list(map(str, command + flags + ["-c", source, "-o", obj]))
        execute(compile_command)
        compile_commands.append({"directory": str(output), "file": str(source),
                                 "command": shlex.join(compile_command)})
        objects.append(obj)
    elf, binary = output / "firmware.elf", output / "firmware.bin"
    execute([gcc, "-march=rv32im_zicsr_zifencei", "-mabi=ilp32", "-nostdlib", "-Wl,--gc-sections",
             "-Wl,--no-relax", "-Wl,-Map," + str(output / "firmware.map"), "-T", linker, *objects, "-lgcc", "-o", elf])
    execute([gnu / "bin/riscv32-unknown-elf-objcopy", "-O", "binary", elf, binary])
    report = {"arch": args.arch, "abi": "ilp32", "cpu_mhz_scaling": 1,
              "warmup_heat": 0, "source_hashes": hashes, "commands": commands,
              "firmware_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),
              "soc_json_sha256": hashlib.sha256(args.soc_json.read_bytes()).hexdigest(),
              "measurement": "benchmark call plus counter-read overhead; initialization and validation excluded"}
    (output / "build.json").write_text(json.dumps(report, indent=2) + "\n")
    (output / "compile_commands.json").write_text(json.dumps(compile_commands, indent=2) + "\n")


if __name__ == "__main__":
    main()
