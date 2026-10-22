#!/usr/bin/env python3
"""Invoke the pinned CFU-Playground LiteX simulator without changing the demo venv.

By default, elaborate the SoC and export its software interface. --run builds
and executes firmware already linked for the exported LiteX memory map.
"""

import argparse
import hashlib
import json
import os
import re
import signal
from pathlib import Path
import subprocess
import sys

REVISION = "7f8ec4147b39db98534f8a10f9ddb1c26aca5648"


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args], text=True).strip()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--cfu", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--firmware", type=Path)
    parser.add_argument("--run", action="store_true")
    parser.add_argument("--rom-boot", action="store_true",
                        help="Firmware is linked at reset address 0; bypass the LiteX BIOS")
    parser.add_argument("--timeout", type=int, default=600)
    parser.add_argument("--success-token", help="Require this firmware output token as well as exit 0")
    parser.add_argument("--instruction-trace", action="store_true",
                        help="Record pinned VexRiscv writeback retirement events as CSV")
    args = parser.parse_args()
    root, cfu, output = args.root.resolve(), args.cfu.resolve(), args.output.resolve()
    if git(root, "rev-parse", "HEAD") != REVISION:
        parser.error(f"CFU-Playground must be at {REVISION}")
    if not cfu.is_file() or not (root / "soc/sim.py").is_file():
        parser.error("Missing CFU RTL or CFU-Playground simulator")
    if args.run and (args.firmware is None or not args.firmware.is_file()):
        parser.error("--run requires an existing LiteX-linked --firmware binary")
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    env = os.environ.copy()
    env["CFU_ROOT"] = str(root)
    dependencies = sorted(path for path in (root / "third_party/python").iterdir()
                          if path.is_dir() and (path / ".git").exists())
    revisions = {path.name: git(path, "rev-parse", "HEAD") for path in dependencies}
    # Compare initialized dependencies against the parent's gitlink, not remote HEAD.
    for path in dependencies:
        expected = git(root, "ls-tree", "HEAD", str(path.relative_to(root))).split()
        if len(expected) < 3 or revisions[path.name] != expected[2]:
            parser.error(f"Dependency differs from pinned gitlink: {path.name}")
    env["PYTHONPATH"] = os.pathsep.join(map(str, dependencies)) + os.pathsep + env.get("PYTHONPATH", "")
    output.mkdir(parents=True, exist_ok=True)
    original_cfu = cfu
    if args.instruction_trace:
        if not args.run:
            parser.error("--instruction-trace requires --run")
        trace_path = output / "instruction_trace.csv"
        # The pinned core increments minstret on this exact isFiring signal.
        # Bind observes the CPU without changing its ports or pipeline.
        monitor = '''
module IsaacRetirementTrace(input wire clk, reset, firing,
                           input wire [31:0] pc, instruction);
  integer trace_fd;
  reg [63:0] cycle = 0;
  initial begin
    trace_fd = $fopen(TRACE_PATH, "w");
    if (!trace_fd) $fatal(1, "Cannot open ISAAC retirement trace");
    $fwrite(trace_fd, "cycle,pc,bytecode\\n");
  end
  always @(posedge clk) begin
    if (reset) cycle <= 0;
    else begin
      cycle <= cycle + 1;
      if (firing) $fwrite(trace_fd, "%0d,0x%08x,0x%08x\\n", cycle, pc, instruction);
    end
  end
  final begin
    $fclose(trace_fd);
  end
endmodule
bind VexRiscv IsaacRetirementTrace isaac_retirement_trace (
  .clk(clk), .reset(reset), .firing(lastStageIsFiring),
  .pc(lastStagePc), .instruction(lastStageInstruction));
'''.replace("TRACE_PATH", json.dumps(str(trace_path)))
        cfu = output / "cfu_with_trace.sv"
        cfu.write_text(original_cfu.read_text() + monitor)
    command = [sys.executable, str(root / "soc/sim.py"), "--cpu-variant", "full+cfu+debug",
               "--cpu-cfu", str(cfu), "--output-dir", str(output),
               "--csr-json", str(output / "csr.json"), "--csr-csv", str(output / "csr.csv")]
    if args.run:
        command += ["--run", "--bin", str(args.firmware.resolve())]
        if args.rom_boot:
            command += ["--integrated-rom-init", str(args.firmware.resolve()), "--no-compile-software"]
    else:
        command += ["--no-compile-software", "--no-compile-gateware"]
    output.mkdir(parents=True, exist_ok=True)
    report = {"cfu_playground_revision": REVISION, "dependencies": revisions,
              "cpu_variant": "full+cfu+debug", "command": command,
              "cfu_sha256": hashlib.sha256(original_cfu.read_bytes()).hexdigest(),
              "simulation_rtl_sha256": hashlib.sha256(cfu.read_bytes()).hexdigest(),
              "instruction_trace": args.instruction_trace,
              "mode": "run" if args.run else "elaborate", "status": "started"}
    if args.firmware:
        report["firmware_sha256"] = hashlib.sha256(args.firmware.read_bytes()).hexdigest()
    report_path = output / "isaac_sim_invocation.json"
    report_path.write_text(json.dumps(report, indent=2) + "\n")
    try:
        with (output / "isaac_sim.log").open("w") as log:
            process = subprocess.Popen(command, env=env, cwd=output, stdout=log,
                                       stderr=subprocess.STDOUT, start_new_session=True)
            try:
                returncode = process.wait(timeout=args.timeout)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGTERM)
                try:
                    process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    os.killpg(process.pid, signal.SIGKILL)
                    process.wait()
                raise
        report.update(status="exited", returncode=returncode)
        log_text = (output / "isaac_sim.log").read_text(errors="replace")
        if args.success_token:
            found = args.success_token in log_text
            report["success_token"] = args.success_token
            report["success_token_seen"] = found
            if not found and returncode == 0:
                report.update(status="missing_success_token", returncode=1)
        metrics = {}
        for field in ("CYCLES", "INSTRUCTIONS"):
            values = re.findall(rf"^ISAAC_CFU_{field}_HEX=([0-9a-f]{{16}})$", log_text, re.MULTILINE)
            if len(values) == 1:
                metrics[field.lower()] = int(values[0], 16)
        if len(metrics) == 2:
            metrics.update(validation="ISAAC_CFU_BENCH_PASS" in log_text and
                           "ISAAC_CFU_BENCH_FAIL" not in log_text and returncode == 0,
                           cpu_variant="full+cfu+debug", runner="verilator",
                           measurement="benchmark call plus counter-read overhead")
            report["benchmark_metrics"] = metrics
            (output / "benchmark_metrics.json").write_text(json.dumps(metrics, indent=2) + "\n")
            if not metrics["validation"]:
                report.update(status="benchmark_validation_failed", returncode=1)
    except subprocess.TimeoutExpired:
        report.update(status="timeout", returncode=124)
    finally:
        report_path.write_text(json.dumps(report, indent=2) + "\n")
    return report["returncode"]


if __name__ == "__main__":
    sys.exit(main())
