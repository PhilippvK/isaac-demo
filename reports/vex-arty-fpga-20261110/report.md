# VEX_5S on Arty A7-100T

## Result

**Baseline and CRC32 ISE-extended designs synthesize, route and execute on the
physical Arty A7-100T**, serial `210319C08AE1`, using Vivado 2024.1 and a 20 MHz
core clock. Only volatile configuration was programmed; flash was not written.
The board currently contains the extended CRC32 image.

| Routed resource / timing | Baseline | CRC32 extended |
|---|---:|---:|
| LUTs | 1,654 | 3,350 |
| Registers | 1,030 | 1,117 |
| BRAM tiles | 64 / 135 | 64 / 135 |
| DSPs | 4 | 7 |
| Overall setup WNS | 2.554 ns | 0.593 ns |
| Core-clock setup slack | 24.891 ns | 21.940 ns |

Both builds meet all specified timing constraints, including hold timing.
Reports have zero unconstrained internal endpoints. These are results at
20 MHz, not a measured maximum-frequency comparison. The shared 256 KiB RAM
accounts for most of the BRAM usage.

## Hardware correctness and performance

- Baseline: the **unchanged TVM AOT sine ELF** from the previous experiment
  executes with native MLonMCU runtime and LLVM22 GISel. All four scalar
  float32 outputs match the earlier RTL results bit for bit. Numerical checks
  against supplied model references pass with `atol=rtol=1e-6`; maximum absolute
  reference error is `2.384185791015625e-7`. References describe the learned
  model, not exact mathematical sine.
- Extended: the existing CRC32 intrinsic firmware passes RAM initialization,
  the x0 probe, **1,280 memory checks**, CRC32 `0x65842ca9`, and five paired runs.
- Each pair measures **16,408 native cycles vs 16,409 ISE cycles** on the same
  extended core. **No acceleration is demonstrated**: the ISE variant is one
  cycle slower (about 0.006%). UART printing is outside the timed regions.
  This is a manually selected intrinsic and does not measure automatic compiler
  utilization or establish results for other workloads/ISE allocations.
- Branch and store ISE variants were not synthesized or run in this experiment.

The board-shell simulation also executes the sine firmware successfully and
reconstructs identical values from its serial waveform. Its RAM and clock
primitives are behavioral substitutes, so physical execution is the stronger
check. The board and shell simulation report identical timed sine run counts
(57,909 cycles for the final measured inference region).

## Implementation

- `vex_arty_top.sv`: board clocks/reset, generated Vex AHB interfaces, one shared
  true dual-port RAM, byte writes, blocking UART TX and native runtime counters.
- `vex_5s_arty_a7_100t.env`: explicit board preset; original Vex query and generic
  FPGA configurations remain as before.
- FPGA synthesis selects a core-specific shell, includes Nailgun's sibling
  `ISAX_*.sv` modules, and creates the matching RAM interface.
- `run_arty.py` supports the MLonMCU completion protocol and optional scalar
  float32 numerical checks; the default freestanding probe mode remains.

Only the demo repository changed in this experiment. No LLVM, Toolkit,
MLonMCU, MLIF, Nailgun or SCAIE-V source changes were required. Upstream the
board integration to the demo repository; there is no new submodule patch.

## Discovered failure and retained limitations

The first dual-port build accidentally lost byte-write enables when Vivado
changed the RAM IP mode. Its one-bit write enable corrupted byte stores; UART
output was unreadable and both hardware attempts were explicitly marked failed.
The intermediate correction also hit IP validation because initialization was
loaded before the final widths were set. The final flow selects memory mode,
sets widths/byte enables, then loads initialization. Final generated IP has
four write enables on both ports. The failed builds are diagnostic evidence,
not passing measurements.

Routed DRC reports retain DSP pipeline advisories and warnings about core
asynchronous-reset signals feeding BRAM control paths. RAM enable is gated
while core reset is asserted, and reset release is synchronized. Repeated
asynchronous reset behavior has not been characterized on hardware. No DRC
severity was lowered. Synthesis logs also retain the existing project-mode
`synth_ip` advisory and a common-clock RAM out-of-context clock-source warning;
full-design routing has no missing clocks, unresolved black boxes or timing
failures. Bitstream generation finishes without critical warnings/errors.

UART RX, interrupts, DDR, arbitrary tensor decoding and a runtime firmware
loader are not implemented. Concurrent writes and instruction fetches to the
same RAM word are outside the validated contract. Counter reads are 32 bits.

## Evidence and reproduction

- `baseline-final/` and `extended-crc32/`: bitstreams, routed checkpoints and
  synthesis/routing reports.
- `board-sine-final/`: physical programming log, raw binary UART and numerical
  validation metadata. `board-extended-crc32/`: physical CRC32 probe evidence.
- `shell-sim/`: behavioral primitive models/testbench, decoded UART, build/run
  logs and comparison metadata. The compiled simulator/build tree is excluded.
- `vivado-final.log`, `vivado-extended.log`, `results.json`, `manifest.json`.
- `run.sh`: rebuild/program commands. Referenced HLS and firmware inputs remain
  in their previous report directories. `manifest.json` pins exact source,
  firmware, bitstream and routed-checkpoint content.

The earlier `baseline/`, `board-sine/`, and `board-sine-retry/` runs are failed;
selected diagnostic logs are retained. Bulk Vivado project/IP build trees are
excluded from Git. Timing and resource comparisons above use only final builds.

Implementation commit: `9968b0c`. CVA5 synthesis was not rerun in this experiment.
