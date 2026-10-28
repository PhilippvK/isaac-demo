#!/usr/bin/env python3
"""Build the pinned CFU-Playground VexRiscv on a Digilent Arty A7-100T.

The initial board configuration uses integrated RAM and ROM-boot firmware.
This command builds gateware; it does not program the board.
"""

import argparse
import hashlib
import json
import os
import shutil
from pathlib import Path
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--cfu", type=Path, required=True)
    parser.add_argument("--firmware", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--build", action="store_true")
    parser.add_argument("--vivado", type=Path)
    parser.add_argument("--baseline", action="store_true", help="Use the matching full CPU without its CFU plugin")
    parser.add_argument("--clock-hz", type=int, default=50000000)
    args = parser.parse_args()
    if args.vivado:
        os.environ["PATH"] = str(args.vivado.resolve().parent) + os.pathsep + os.environ.get("PATH", "")
    root, output = args.root.resolve(), args.output.resolve()
    from cfu_playground_sim import REVISION, git
    if git(root, "rev-parse", "HEAD") != REVISION:
        parser.error("CFU-Playground checkout differs from pinned revision")
    dependencies = sorted(path for path in (root / "third_party/python").iterdir()
                          if path.is_dir() and (path / ".git").exists())
    revisions = {}
    for path in dependencies:
        revisions[path.name] = git(path, "rev-parse", "HEAD")
        if revisions[path.name] != git(root, "ls-tree", "HEAD", str(path.relative_to(root))).split()[2]:
            parser.error(f"Dependency differs from pinned gitlink: {path}")
    sys.path[:0] = [str(root / "soc")] + list(map(str, dependencies))
    os.environ["CFU_ROOT"] = str(root)
    from patch_cpu_variant import patch_cpu_variant, copy_cpu_variant_if_needed
    from litex_boards.targets.digilent_arty import BaseSoC
    from litex.soc.integration.builder import Builder
    from litex.soc.interconnect.csr import CSRStorage, AutoCSR
    from migen import Module
    class Finish(Module, AutoCSR):
        def __init__(self):
            self.finish = CSRStorage(1, name="finish")
    patch_cpu_variant()
    variant = "full+debug" if args.baseline else "full+cfu+debug"
    copy_cpu_variant_if_needed(variant)
    kwargs = {}
    if args.firmware:
        kwargs["integrated_rom_init"] = str(args.firmware.resolve())
    if not args.baseline:
        kwargs["cpu_cfu"] = str(args.cfu.resolve())
    soc = BaseSoC(variant="a7-100", toolchain="vivado", sys_clk_freq=args.clock_hz,
                  cpu_type="vexriscv", cpu_variant=variant,
                  integrated_rom_size=128*1024, integrated_main_ram_size=128*1024,
                  with_jtagbone=False, with_led_chaser=False, uart_baudrate=115200, **kwargs)
    soc.submodules.sim_finish = Finish()
    soc.add_csr("sim_finish")
    output.mkdir(parents=True, exist_ok=True)
    inputs = [args.cfu] + ([args.firmware] if args.firmware else [])
    report = {"board": "digilent_arty_a7_100", "cpu_variant": variant,
              "clock_hz": args.clock_hz, "integrated_main_ram_bytes": 128*1024,
              "cfu_playground_revision": REVISION, "dependencies": revisions,
              "inputs_sha256": {str(path.resolve()): hashlib.sha256(path.read_bytes()).hexdigest() for path in inputs},
              "status": "started", "build_requested": args.build}
    record = output / "isaac_fpga_build.json"
    previous = json.loads(record.read_text()) if record.exists() else {}
    if args.build:
        vivado = args.vivado.resolve() if args.vivado else shutil.which("vivado")
        if not vivado:
            parser.error("Vivado is not on PATH; supply --vivado")
        report["vivado_version"] = subprocess.check_output([str(vivado), "-version"], text=True)
        # Pin both revisions and tracked local modifications in the tool stack.
        report["tool_source_diffs_sha256"] = {str(path): hashlib.sha256(git(path, "diff", "HEAD", "--").encode()).hexdigest()
                                                for path in [root] + dependencies}
        report["driver_sha256"] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
        fingerprint = hashlib.sha256(json.dumps(report, sort_keys=True).encode()).hexdigest()
        report["build_fingerprint"] = fingerprint
        cached_outputs = previous.get("outputs_sha256", {})
        if (previous.get("build_fingerprint") == fingerprint and cached_outputs
                and all(Path(path).is_file() and hashlib.sha256(Path(path).read_bytes()).hexdigest() == digest
                        for path, digest in cached_outputs.items())):
            report.update(status="cache_hit", outputs_sha256=cached_outputs)
            record.write_text(json.dumps(report, indent=2) + "\n")
            print("Reusing verified FPGA build", output)
            return
    record.write_text(json.dumps(report, indent=2) + "\n")
    builder = Builder(soc, output_dir=str(output), compile_software=False,
                      csr_json=str(output / "csr.json"), csr_csv=str(output / "csr.csv"))
    try:
        builder.build(run=args.build)
        report["status"] = "build_finished" if args.build else "elaborated"
        if args.build:
            files = [output / "gateware/digilent_arty.bit"] + sorted((output / "gateware").glob("*.rpt"))
            report["outputs_sha256"] = {str(path): hashlib.sha256(path.read_bytes()).hexdigest() for path in files}
    except BaseException:
        report["status"] = "failed"
        raise
    finally:
        record.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
