#!/usr/bin/env python3
"""Program volatile Arty gateware and validate ROM-boot firmware over UART."""

import argparse
import fcntl
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import time


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--vivado", type=Path, required=True)
    parser.add_argument("--bitstream", type=Path, required=True)
    parser.add_argument("--board-serial", required=True)
    parser.add_argument("--port", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--timeout", type=int, default=120)
    args = parser.parse_args()
    if not re.fullmatch(r"[A-Za-z0-9]+", args.board_serial) or args.timeout <= 0:
        parser.error("Invalid board serial or timeout")
    sys.path.insert(0, str(args.root.resolve() / "third_party/python/pyserial"))
    import serial
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    # Serialize programming and serial capture for this physical board.
    lock = open("/tmp/isaac-cfu-board-" + args.board_serial + ".lock", "a")
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    bitstream = args.bitstream.resolve()
    begin_marker, ready_marker = output / "capture.begin", output / "capture.ready"
    for marker in (begin_marker, ready_marker):
        marker.unlink(missing_ok=True)
    script = output / "program.tcl"
    script.write_text('''open_hw_manager
connect_hw_server
set targets [get_hw_targets *BOARD_SERIAL*]
if {[llength $targets] != 1} { error "Expected one matching Arty target" }
current_hw_target [lindex $targets 0]
open_hw_target
set device [lindex [get_hw_devices xc7a100t*] 0]
if {$device eq ""} { error "Expected an XC7A100T device" }
current_hw_device $device
refresh_hw_device -update_hw_probes false $device
set_property PROGRAM.FILE [lindex $argv 0] $device
set marker [open [lindex $argv 1] w]
puts $marker "ready to program"
close $marker
set attempts 0
while {![file exists [lindex $argv 2]] && $attempts < 500} {
    after 10
    incr attempts
}
if {![file exists [lindex $argv 2]]} { error "UART capture did not acknowledge programming boundary" }
program_hw_devices $device
close_hw_target
disconnect_hw_server
close_hw_manager
'''.replace("BOARD_SERIAL", args.board_serial))
    command = [str(args.vivado.resolve()), "-mode", "batch", "-nojournal", "-nolog",
               "-source", str(script), "-tclargs", str(bitstream), str(begin_marker), str(ready_marker)]
    report = {"board_serial": args.board_serial, "serial_port": args.port,
              "baudrate": 115200, "programming": "volatile SRAM; no flash writes",
              "bitstream_sha256": hashlib.sha256(bitstream.read_bytes()).hexdigest(),
              "command": command, "validation": False, "status": "started"}
    record = output / "fpga_run.json"
    record.write_text(json.dumps(report, indent=2) + "\n")
    data = bytearray()
    capture_started = False
    try:
        uart = serial.Serial(args.port, 115200, timeout=0.1, exclusive=True)
    except serial.SerialException as error:
        report.update(status="serial_access_failed", error=str(error), programming_started=False)
        record.write_text(json.dumps(report, indent=2) + "\n")
        print(str(error), file=sys.stderr)
        return 1
    with uart, (output / "program.log").open("w") as log:
        uart.reset_input_buffer()
        process = subprocess.Popen(command, cwd=output, stdout=log, stderr=subprocess.STDOUT)
        deadline = time.monotonic() + args.timeout
        while time.monotonic() < deadline:
            if not capture_started and begin_marker.exists():
                # Opening the FTDI port can reset the previously loaded image.
                # Discard that boot before allowing Vivado to program the new one.
                uart.reset_input_buffer()
                data.clear()
                capture_started = True
                ready_marker.write_text("UART cleared; program now\n")
            received = uart.read(max(1, uart.in_waiting))
            if capture_started:
                data.extend(received)
            text = data.decode(errors="replace")
            if process.poll() is not None:
                if process.returncode != 0 or "ISAAC_CFU_BENCH_FAIL" in text:
                    break
                if "ISAAC_CFU_BENCH_PASS" in text and "ISAAC_CFU_INSTRUCTIONS_HEX=" in text:
                    break
        if process.poll() is None:
            process.terminate()
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
        report["program_returncode"] = process.returncode
    text = data.decode(errors="replace")
    (output / "uart.log").write_bytes(data)
    metrics = {}
    for field in ("CYCLES", "INSTRUCTIONS"):
        values = re.findall(r"ISAAC_CFU_" + field + r"_HEX=([0-9a-f]{16})", text)
        if len(values) == 1:
            metrics[field.lower()] = int(values[0], 16)
    valid = (capture_started and process.returncode == 0 and "ISAAC_CFU_BENCH_PASS" in text
             and "ISAAC_CFU_BENCH_FAIL" not in text and len(metrics) == 2)
    report.update(status="passed" if valid else "failed", validation=valid, metrics=metrics,
                  programming_boundary_acknowledged=capture_started)
    record.write_text(json.dumps(report, indent=2) + "\n")
    metrics.update(runner="fpga", validation=valid, board="digilent_arty_a7_100")
    (output / "benchmark_metrics.json").write_text(json.dumps(metrics, indent=2) + "\n")
    print(json.dumps(report, indent=2))
    return 0 if valid else 1


if __name__ == "__main__":
    raise SystemExit(main())
