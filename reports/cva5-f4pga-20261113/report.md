# CVA5 F4PGA integration, 2026-11-13

The independent F4PGA/SymbiFlow backend now accepts CVA5 as well as VEX_5S on
Arty A7-100T (`xc7a100tcsg324-1`), with a 100 MHz oscillator and a PLL-generated
20 MHz core clock. It does not invoke Vivado or require a proprietary license.

The baseline has completed synthesis, packing, placement, routing, FASM and
bitstream generation. The 116-instruction CRC32 build is routing. Both banked
frontend simulations pass. No FPGA has been programmed in this task.

The backend stages the existing byte-address and injected funct3 adapters,
explicit defaults for inactive CVA5 signals, portable local memories, and an
AXI UARTLite polling-compatible UART with 16-byte FIFOs. sv2v v0.0.13 converts
the package/interface RTL; the pinned Yosys checks the optimized design with
`check -assert`. Original generated sources remain untouched.

Three compatibility issues were addressed during validation:

- Intel MLAB hints are removed, while Xilinx hints remain.
- Whole-array RAM initialization becomes element-wise initialization, retaining
  memory inference instead of constructing large packed vectors.
- Each local RAM has two 32K-word banks. The legacy 64K-depth RAMB36 cascade
  mapping discarded half of the writable data memory. The new result validator
  requires at least 64 RAMB36 equivalents belonging to the data RAM itself.

The old Yosys Verilog writer also mis-emits some references to ascending packed
arrays. Its internal connections are correct. Preserved simulation netlists
therefore use `splitnets -ports` before Verilog export; a two-stage pipeline
regression exercises the workaround. Early simulation timeouts and aborted
incompatible mappings are diagnostic attempts, not successful implementations.

Both banked frontend simulations complete their firmware tests. Baseline
reports RAM PASS, CRC32 `65842ca9`, verification `00002ca9` (11433), and final
PASS at cycle 160883. The CRC32 design passes 1280 native/custom load checks
and five matching CRC pairs, finishing at cycle 996561. Steady pairs take
15384 native cycles and 13336 custom-instruction cycles, matching the earlier
[Vivado hardware firmware results](../cva5-fpga-execution-20261105/report.md).
These are frontend simulation results for the open flow, not execution of its
mapped netlist or bitstream. Ideal clock stubs do not validate PLL locking or
board timing. Detailed transcripts and checksums are in [simulation](simulation/results.json).

The focused suite passes 62 tests, including UART channel ordering/backpressure,
serial TX/RX, FIFO ordering/error flags, RAM byte writes/address boundaries,
capacity rejection, firmware staging, exporter behavior, and core-specific
baseline reuse. The preserved Vex baseline also validates unchanged; CVA5
reuse of that baseline is rejected.

The exact driver used for the native builds is [preserved](driver-used.py).
Its hash matches execution metadata. The final backend additionally performs
the same memory-capacity check immediately after synthesis, and requires the
preserved frontend netlist in its manifest. Build inputs and commands otherwise
match. Tool provenance is recorded in [toolchain.json](toolchain.json).

See [backend documentation](../../scripts/fpga_syn/f4pga/README.md) and the
[CVA5 preset](../../cfg/flow/paper/cva5_reuseio_arty_a7_100t_f4pga.env).

## Completed baseline implementation

| Result | Baseline |
|---|---:|
| Mapped LUT atoms (not physical LUT sites) | 13553 |
| Flip-flops | 2732 |
| RAMB36 / RAMB18 | 93 / 4 |
| Data-memory RAMB36 subset | 64 |
| DSPs | 0 |
| Routed critical path | 34.2373 ns |
| VPR setup / hold WNS | 0 / 0 ns |
| Constrained setup / hold met at 50 ns | yes / yes |

VPR reports 5 unconstrained timing startpoints and 8680 unconstrained timing
endpoints. This is a constrained-path implementation result, not complete
board timing signoff. The single-port memory architecture and legacy timing
models need further investigation before claiming every endpoint is covered.

The baseline [archive](evidence/baseline.tar.gz) contains the bitstream,
netlists, placement/routing, FASM, native logs, firmware images, staged RTL and
SHA-256 execution manifest. All 126 manifest artifacts were verified directly
from the compressed archive. [Metrics](baseline.metrics.json) and
[execution metadata](baseline.execution.json) are also available without
extracting it. The [diagnostic archives](diagnostics) preserve the rejected
cascade mappings; they are not usable implementation caches.

## Reproduction and limits

[rtl-inputs.tar.gz](rtl-inputs.tar.gz) contains 165 original input files in
baseline/CRC32 trees; [the manifest](rtl-inputs-sha256.json) records their hashes.
[firmware](firmware) contains the exact binaries used in each build. Their ROM
contents differ, so native resource comparisons include that difference.

With the F4PGA runtime and pinned sv2v installed, set
`FPGA_SYN_F4PGA_ENV_SCRIPT`, `FPGA_SYN_F4PGA_SV2V`, and optionally
`FPGA_SYN_PYTHON`, then run:

```bash
bash reports/cva5-f4pga-20261113/reproduce.sh /absolute/new-build-directory
python3 reports/cva5-f4pga-20261113/verify-evidence.py \
  reports/cva5-f4pga-20261113/evidence/baseline.tar.gz
```

The native runtime, official architecture archive, Project X-Ray database and
local-storage workaround are the same as the previous
[F4PGA integration](../f4pga-integration-20261112/report.md). Simulation uses
Verilator 5.044 from the pinned LibreLane image to generate C++, its matching
runtime headers, and host GCC to build it. The simulation harness and ideal
clock stubs are tracked under `tests/rtl`.

Mapped capacity is checked, but technology-mapped RAM equivalence and physical
FPGA execution have not been performed. The existing Vex-specific native
MLonMCU runtime-counter adapter remains separate from this CVA5 synthesis port.
