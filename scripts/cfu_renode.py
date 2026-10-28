#!/usr/bin/env python3
"""Run LiteX-linked firmware with Renode CPU emulation and a Verilated CFU.

Renode cycle values are model values and must not be labeled VexRiscv RTL cycles.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import signal
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--renode", type=Path, required=True)
    parser.add_argument("--library", type=Path, required=True)
    parser.add_argument("--firmware", type=Path, required=True)
    parser.add_argument("--soc-json", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--success-token", default="ISAAC_CFU_BENCH_PASS")
    parser.add_argument("--duration", type=float, default=0.2)
    parser.add_argument("--timeout", type=int, default=120)
    args = parser.parse_args()
    if not 0 < args.duration < 40 or args.timeout <= 0:
        parser.error("Duration must be between zero and 40 seconds; timeout must be positive")
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    env["XDG_CONFIG_HOME"] = str(output / "config")
    version = subprocess.check_output([str(args.renode.resolve()), "--version"], env=env,
                                      text=True, timeout=30).strip()
    if "998250fe" not in version:
        parser.error("Expected CFU-Playground's pinned Renode build 998250fe")
    model = Path(__file__).resolve().parents[1] / "cfg/cfu_playground/renode/IsaacLiteX.cs"
    soc = json.loads(args.soc_json.read_text())
    if soc["constants"]["config_csr_data_width"] != 32 or soc["constants"]["config_cpu_reset_addr"] != 0:
        parser.error("Expected 32-bit LiteX CSRs and reset at zero")
    platform = []
    for name in ("rom", "sram", "main_ram"):
        region = soc["memories"][name]
        platform.append(f"{name}: Memory.MappedMemory @ sysbus 0x{region['base']:x}\n    size: 0x{region['size']:x}\n")
    platform += ['cpu: CPU.VexRiscv @ sysbus\n    cpuType: "rv32im_zicsr_zifencei"\n',
                 f"uart: UART.IsaacLiteXUART @ sysbus 0x{soc['csr_bases']['uart']:x}\n",
                 f"finish: Miscellaneous.IsaacFinish @ sysbus 0x{soc['csr_registers']['sim_finish_finish']['addr']:x}\n",
                 "cfu0: Verilated.CFUVerilatedPeripheral @ cpu 0\n"]
    repl = output / "isaac.repl"
    repl.write_text("\n".join(platform))
    def resource(path):
        text = str(path.resolve())
        if any(c.isspace() for c in text) or any(c in text for c in '\";'):
            raise ValueError("Renode resources currently require paths without whitespace, quotes or semicolons")
        return "@" + text
    script = output / "run.resc"
    script.write_text("\n".join([
        'using sysbus', 'mach create "isaac_cfu"', 'include ' + resource(model),
        'machine LoadPlatformDescription ' + resource(repl),
        # This pinned emulator implements instret low but omits instreth.
        # Bounded runs stay below 2^32 retirements; supply the zero high half.
        'cpu RegisterCustomCSR "ISAAC_INSTRETH" 0xC82 User',
        'cpu PerformanceInMips 100',
        'cpu.cfu0 SimulationFilePathLinux ' + resource(args.library),
        'sysbus LoadELF ' + resource(args.firmware),
        'showAnalyzer sysbus.uart Antmicro.Renode.Analyzers.LoggingUartAnalyzer',
        f'emulation RunFor "{args.duration}"', 'quit', '']))
    command = [str(args.renode.resolve()), "--disable-xwt", "--console", "--plain", "-e", "include " + resource(script)]
    report = {"runner": "renode", "renode_version": version, "command": command,
              "virtual_duration_seconds": args.duration, "status": "started",
              "measurement": "Renode CPU emulation with Verilated CFU; not VexRiscv RTL timing",
              "instruction_counter_high_half": "custom zero CSR; bounded runs must retire fewer than 2^32 instructions",
              "cpu_performance_in_mips": 100,
              "sha256": {str(path.resolve()): hashlib.sha256(path.read_bytes()).hexdigest()
                         for path in (args.library, args.firmware, args.soc_json, model)}}
    report_path = output / "renode_invocation.json"
    report_path.write_text(json.dumps(report, indent=2) + "\n")
    with (output / "renode.log").open("w") as log:
        process = subprocess.Popen(command, env=env, cwd=output, stdout=log,
                                   stderr=subprocess.STDOUT, stdin=subprocess.DEVNULL,
                                   start_new_session=True)
        try:
            returncode = process.wait(timeout=args.timeout)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGTERM)
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
            returncode = 124
    text = (output / "renode.log").read_text(errors="replace")
    passed = (args.success_token in text and "ISAAC_CFU_FINISH=1" in text
              and "ISAAC_CFU_BENCH_FAIL" not in text and "ISAAC_CFU_FAIL" not in text and returncode == 0)
    report.update(status="passed" if passed else "failed", returncode=returncode,
                  validation=passed, finish_seen="ISAAC_CFU_FINISH=1" in text)
    metrics = {"runner": "renode", "validation": passed,
               "measurement": report["measurement"]}
    for marker, name in (("CYCLES", "model_cycles"), ("INSTRUCTIONS", "instructions")):
        values = re.findall(r"ISAAC_CFU_" + marker + r"_HEX=([0-9a-f]{16})", text)
        if len(values) == 1:
            metrics[name] = int(values[0], 16)
    report_path.write_text(json.dumps(report, indent=2) + "\n")
    (output / "benchmark_metrics.json").write_text(json.dumps(metrics, indent=2) + "\n")
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
