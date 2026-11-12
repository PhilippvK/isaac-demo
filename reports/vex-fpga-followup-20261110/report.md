# Vex Arty follow-up: CRC32 acceleration and native MLonMCU execution

## Hardware result

On Arty A7-100T serial `210319C08AE1`, at 20 MHz, an arithmetic CRC32
index ISE followed by a native load takes **14,361 cycles versus 16,408 native**
in each of five paired runs: **12.48% fewer cycles, 1.143x speedup**.
Both produce CRC32 `0x65842ca9`. The x0 probe and all 1,280 memory checks pass.
The physical measurement on November 12 matches the November 10 board-shell
RTL simulation exactly. UART printing is outside the timed paired regions.

This is a manually selected intrinsic (`CUSTOM2` in the retained CRC32
allocation). It does not establish automatic compiler utilization or a speedup
for other workloads. Both sides execute on the same extended design. The
original memory-injecting intrinsic still takes 16,409 cycles against 16,408
native; see the preceding [hardware report](../vex-arty-fpga-20261110/report.md).

## Why the original intrinsic was not faster

The original memory ISE reduces the loop from 13 instructions to 10 but loses
its savings in pipeline stalls. The retained retirement trace and disassembly
show an exposed multiply dependency and injected-memory stalls. The arithmetic
index version combines XOR/mask/shift, retains a native address add/load, and
uses 11 instructions per loop. This removes 2,047 measured cycles overall.
The `crc-profile/` and `crc-index-profile/` directories retain the traces and
UART evidence. The testbench uses behavioral RAM/clock primitive replacements;
physical execution is the independent confirmation.

## Branch and store probes

The November 10 physical captures pass 1,344 branch checks, 48 custom store
checks, and six native store checks. These are separate generated instruction
allocations and bitstreams, not additions to the CRC32 image. No branch/store
performance speedup is claimed.

| Design | Routed setup WNS | Timing constraints |
|---|---:|---|
| CRC32 arithmetic-index firmware | 0.593 ns | Met |
| Branch probes | 1.515 ns | Met |
| Store probes | 2.565 ns | Met |

The CRC32 logic uses the existing CRC32 allocation with different initialized
firmware. All measurements are at 20 MHz; WNS is not a maximum-frequency claim.
Existing reset/BRAM/DSP advisories remain as described in the preceding report.

## MLonMCU FPGA integration

`nailgun.execution=fpga` selects the new `scripts/fpga_syn/run.py` runner.
The explicit `fpga_run_0` full-flow stage builds firmware through native MLonMCU,
synthesizes initialized BRAM, verifies routed timing, programs volatile FPGA
configuration and validates captured UART. RTL remains the default execution
mode. The current hardware runtime requires Vex and exactly 256 KiB RAM.

The original November 10 native MLonMCU CRC32 run passed with 5,573,423 Run
Cycles and 4,179,706 Run Instructions. This full benchmark configuration is
separate from the 1,024-byte freestanding paired intrinsic test above.
The TVM AOT sine run passed with 57,909 Run Cycles, 42,715 Run Instructions,
and 4/4 numerical outputs within `atol=rtol=1e-6`. Its binary model frames,
inputs/references/decoded outputs and report are retained in `mlonmcu-sine/`.

A November 12 repeat through `build_mlonmcu.py --run --execution fpga` checks
the helper and exported bitstream/checkpoint/report artifacts in
`mlonmcu-crc32/`. See its `execution.json` and firmware build manifest for the
final status and exact command. It passed with the same 5,573,423 Run Cycles;
its exported bitstream hash matches the execution manifest, and exported UART
bytes match exactly. The board now contains this native CRC32 benchmark image.

## Reproduction and retained evidence

See [the execution guide](../../scripts/rtl_sim/README.md#fpga-execution-through-mlonmcu)
for full-flow configuration. `run.sh` reproduces the intrinsic firmware build,
FPGA synthesis, and physical capture using the previously generated CRC32 RTL.
Hardware programming writes volatile configuration only; flash is unchanged.

- `results.json`: parsed, checked physical pair measurements.
- `board-crc-index/`, `board-branches/`, `board-stores/`: raw UART, execution
  metadata and programming logs.
- `crc-index-firmware/`: matching binary, ELF, COE, disassembly and input hashes.
- `crc-index-fpga/`, `branches/`, `stores/`: selected routed reports,
  bitstreams and checkpoints; bulk Vivado project/IP trees are excluded.
- `mlonmcu-crc32-original/`, `mlonmcu-sine/`, `mlonmcu-crc32/`: native runtime
  reports, UART and firmware/model evidence.
- `manifest.json`: hashes of selected evidence and implementation source files.

The focused runner tests cover timing/synthesis/timeout failures, stale UART
rejection and preservation of binary model output. All 14 repository tests pass; shell syntax and source whitespace checks pass. Raw tool logs and UART
captures retain their original whitespace and CRLF bytes. No other submodule working changes are
included in this follow-up.

Implementation commit: `183e7c2`; MLonMCU submodule commit: `c1915344`.
Retirement traces are compressed as `trace.csv.gz`.
