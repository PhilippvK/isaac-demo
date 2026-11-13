# CVA5 F4PGA integration, 2026-11-13–14

CVA5 is integrated into the independent F4PGA/SymbiFlow synthesis target on
Arty A7-100T (`xc7a100tcsg324-1`), with a PLL-generated 20 MHz core clock.
Baseline and selected five-load-instruction designs both complete synthesis,
packing, placement, routing, FASM and bitstream generation. The normal
`flow_syn.sh` path also passes real baseline reuse, collection and preservation.
No FPGA has been programmed in this task.

## Completed implementations

| Result | Baseline | Selected five loads |
|---|---:|---:|
| Mapped LUT atoms (not physical LUT sites) | 13553 | 14952 |
| Flip-flops | 2732 | 2932 |
| RAMB36 / RAMB18 | 93 / 4 | 93 / 4 |
| Writable data-memory RAMB36 subset | 64 | 64 |
| DSPs | 0 | 0 |
| Routed critical path | 34.2373 ns | 33.2807 ns |
| VPR setup / hold WNS | 0 / 0 ns | 0 / 0 ns |
| Constrained setup / hold met at 50 ns | yes / yes | yes / yes |

[Collected metrics](metrics.csv) preserve backend/core/part/clock identity.
Component counts are unavailable in the flattened native netlist; they are
not estimated. The selected design adds 1399 LUT atoms and 200 FFs. Firmware
contents differ between variants, so resource comparisons include that difference.

Both runs report **5 unconstrained timing startpoints and 8680 unconstrained
timing endpoints**. These are constrained-path VPR results, not complete board
timing signoff. The single-port memory architecture and legacy timing models
need further investigation before claiming every endpoint is covered.

Portable archives contain bitstreams, native netlists, placement/routing,
FASM, logs, firmware images, staged RTL and execution SHA-256 manifests:

- [Baseline archive](evidence/baseline.tar.gz), [metrics](baseline.metrics.json),
  [execution metadata](baseline.execution.json).
- [Selected-load archive](evidence/load5.tar.gz), [metrics](load5.metrics.json),
  [execution metadata](load5.execution.json).

## Functional checks

All three optimized frontend netlists pass their matching firmware simulations:

| Design | Load comparisons | CRC pairs | Final PASS cycle |
|---|---:|---:|---:|
| Baseline | — | native only | 160883 |
| Selected five loads | 1280 | 5 native/custom | 1000041 |
| Full 116 instructions | 1280 | 5 native/custom | 996561 |

Every CRC is `65842ca9`; verification is `00002ca9` (11433). Steady pairs take
15384 native cycles and 13336 custom-instruction cycles, matching the earlier
[Vivado hardware firmware results](../cva5-fpga-execution-20261105/report.md).
The five-load set and full set have different custom encodings, so each needs
its matching firmware. The selected-load binary and intrinsic header are preserved.

[Transcripts, checksums and pair data](simulation/results.json) are frontend
simulation evidence, before technology mapping. Ideal clock stubs do not
validate the PLL, physical board timing, or execution of these new bitstreams.
Technology-mapped RAM equivalence and physical FPGA execution remain untested.

The focused suite passes **65 tests**, covering UART channel ordering and
backpressure, serial TX/RX, FIFOs/error flags, RAM writes/address boundaries,
capacity rejection, firmware staging, baseline identity, interruption status,
Verilog export and FASM mux metadata. The preserved Vex baseline still validates,
and CVA5 reuse of it is rejected. The actual `flow_syn.sh` preservation smoke
test also passes: [result](flow-cache-smoke.json).

## Compatibility fixes

- sv2v v0.0.13 converts CVA5 packages and interfaces. Known, in-range literal
  selects left by that release are folded for the pinned Yosys frontend.
- Intel MLAB hints are removed while Xilinx hints remain. Whole-array RAM
  initialization becomes element-wise initialization, retaining memory inference.
- Staged defaults define inactive cache requests, unused writeback slots and
  selector padding, and the disabled decoupled-writeback renamer flag. The
  optimized design passes `check -assert` with zero structural problems.
- Each 256 KiB local RAM uses two 32K-word banks. This avoids the incompatible
  legacy 64K-depth RAMB36 cascade mapping that discarded half the writable RAM.
  Native validation requires at least 64 data RAMB36 equivalents. This fix is
  CVA5-specific; the previously documented Vex memory-mapping discrepancy remains
  outside this port.
- The pinned Yosys Verilog writer mis-emits some ascending-array references even
  though its internal connections are correct. Simulation exports use
  `splitnets -ports`; a pipeline regression checks the result.
- An open UART replaces Vivado AXI UART Lite IP. It supplies independent AW/W
  capture, held responses, 16-byte FIFOs and 115200 baud 8N1 polling registers.
  Its level interrupt is unconnected in this shell; UARTLite interrupt pulse
  compatibility is not claimed.

The selected build exposed a redundant architecture FASM rule: ADI1MUX forwarding
BDI1MUX unconditionally requested `BLUT.DI1MUX.DI_CMC31`, conflicting when the
actual B mux selected `BI`. The finalizer removes that redundant feature in a
local architecture copy. BDI1MUX's actual route emits its selection. Architecture
structure and timing are unchanged; the original architecture SHA-256 must match
the packed-netlist header before export. The installed architecture is unchanged.
[Provenance and command](load5.fasm-architecture.json) preserve both hashes.
The routed checkpoint was revalidated and only FASM/bitstream conversion retried.
The original [bitstream rejection](diagnostics/lutram-mux-conflict.log) is retained.

## Full-set stress result

The 116-instruction set completes synthesis, packing and placement, and its
frontend firmware passes. Its mapped netlist has 45628 LUT atoms. Routing was
stopped after 18 completed iterations because congestion persisted; the latest
estimated critical path was about 70.9 ns, above the 50 ns target. No completed
routing, final routed timing or bitstream is claimed for that variant.

[Stress summary](crc32.partial.json), [partial archive](evidence/crc32-partial.tar.gz)
and [checksums](crc32.partial.sha256.json) are explicitly incomplete results.
They cannot be reused as completed baselines. Rejected cascade mappings and the
ascending-array exporter reproducer are also retained under [diagnostics](diagnostics).

## Reproduction and provenance

[rtl-inputs.tar.gz](rtl-inputs.tar.gz) contains 248 original files in three
variant trees, with [source hashes](rtl-inputs-sha256.json). [Firmware](firmware)
contains the matching binaries. With F4PGA and pinned sv2v installed, set
`FPGA_SYN_F4PGA_ENV_SCRIPT`, `FPGA_SYN_F4PGA_SV2V`, and optionally
`FPGA_SYN_PYTHON`, then run:

```bash
bash reports/cva5-f4pga-20261113/reproduce.sh /absolute/new-build-directory
python3 reports/cva5-f4pga-20261113/verify-evidence.py \
  reports/cva5-f4pga-20261113/evidence/baseline.tar.gz \
  reports/cva5-f4pga-20261113/evidence/load5.tar.gz
```

The default reproduction builds baseline and selected loads. Set
`CVA5_VARIANTS=crc32` with a fresh directory to repeat the larger stress build;
it can take substantially longer to route.

[Toolchain provenance](toolchain.json) records the native runtime and simulation
image. Architecture/device/database setup is the same as the earlier
[F4PGA integration](../f4pga-integration-20261112/report.md), including unchanged
Project X-Ray data on local storage for file locking. Simulation uses Verilator
5.044 from the pinned LibreLane image, matching runtime headers and host GCC.
No Vivado or proprietary license is used by this flow.

Exact initial drivers are [preserved](driver-used.py) and
[preserved for selected loads](driver-load5-used.py), matching execution hashes.
The finalizer additionally checks capacity immediately after synthesis, requires
the frontend netlist in the manifest, records interruptions accurately, and
applies the checked FASM metadata correction. Finalizer/adapter hashes are in
selected-load execution metadata. [sha256.json](sha256.json) covers report files.

See the [backend guide](../../scripts/fpga_syn/f4pga/README.md) and
[CVA5 preset](../../cfg/flow/paper/cva5_reuseio_arty_a7_100t_f4pga.env).
The existing Vex-only native MLonMCU counter/execution adapter remains separate
from this CVA5 synthesis target.
