# CVA5 and Vex RTL simulation integration

## Implemented

`rtl_sim_0` is now a normal `full_flow.sh` stage, with filtered/selected,
preliminary and final suffixes. `RTL_SIM_ENABLE=1` inserts the matching stage
after HLS; default remains disabled. Native and retargeted variants rebuild the
actual extraction benchmark from its exported MLIF compile commands. The
selected instruction selector is recorded and passed to compilation.

The ETISS startup, semihosting and linker are replaced with an RTL runtime at
0x80000000, with 256 KiB RAM, newlib UART/heap services, cycle/retirement counters,
trap diagnostics and an explicit status register. MLIF's original benchmark
verification remains enabled. A disabled verification option is rejected.

Both backends simulate generated Nailgun/SCAIE-V RTL, not ISS or CFU-Playground:

- VEX_5S: AHB memory, byte write lanes and selectable data wait states.
- CVA5: synchronous local RAM and single-beat peripheral AXI. The staged
  generated wrappers preserve full byte addresses (the original wrapper
  truncates them twice), and injected memory operations honor funct3 widths.
  Cached/external-memory configurations and burst peripheral traffic fail
  explicitly; they are not approximated by this adapter.

No FPGA board, FPGA synthesis, Vivado or proprietary IP simulator is required.
Verilator 5.040 is pinned by an installer. The system's Verilator 4.038 works
for Vex but cannot compile CVA5's SystemVerilog interfaces.

Results include compiler/source/firmware/RTL hashes, commands, UART output,
benchmark-region metrics, whole-program counters, JSON and CSV. Selected
reports and firmware are also copied outside the disposable build directory;
normal CI reports link the measurements. Failed reruns invalidate old success
markers before doing any work.

## Actual extraction benchmark results

These execute the Embench sources and MLIF main from the earlier extraction
exports, not the manually written CRC32 probe. Both benchmark verification
functions pass on both cores.

| Core | Benchmark | Run cycles | Run instructions | Verified |
|---|---|---:|---:|---|
| VEX_5S | CRC32 | 5,051,140 | 4,179,696 | Yes |
| CVA5 | CRC32 | 4,180,440 | 4,179,696 | Yes |
| VEX_5S | SHA256 | 4,753,937 | 4,305,511 | Yes |
| CVA5 | SHA256 | 4,839,579 | 4,305,511 | Yes |

All images use RV32IM/ILP32 and LLVM22 SelectionDAG. The older SHA256 extraction
export was RV32IMFD/ILP32D; it was explicitly rebuilt for the supported integer
hardware ISA. Its benchmark verifier still passes. This is a source-level
benchmark reproduction; it is not unchanged execution of the ETISS ELF.

The whole `full_flow.sh` stage was also exercised successfully with CRC32/Vex
and SHA256/CVA5. A two-variant native/extended-architecture CRC32 run using the
matching branch compiler and Vex branch RTL passes both variants. That workload
does not select those branch fixtures, so equal metrics there are a plumbing
control, **not evidence of an automatically selected ISE speedup**.

Vex CRC32 also passes with one data wait state: benchmark results are unchanged.
See `benchmark-results.json`, `flow-*/summary.json`, and per-run UART logs.

## Generated ISE execution through the new adapters

The existing firmware probe builder now has `--rtl-sim`, returning main's
status through the same exit register. These supplement the actual benchmark
runs above and exercise real extension traffic.

| Core / generated RTL | Wait setting | Result |
|---|---:|---|
| Vex full CRC32 set | 1 AHB data wait | 1,280 load checks, x0 check, 5 native/ISE CRC pairs pass |
| CVA5 full CRC32 set | spaced peripheral AXI | 1,280 load checks, x0 check, 5 native/ISE CRC pairs pass |
| Vex fused branches | 1 AHB data wait | 1,344 checks across all six branch types pass |

These reuse the exact generated sets from the earlier HLS reports. CVA5's
previously reported taken-backward fused BGEU problem is not repaired by this
integration; no new passing CVA5 branch claim is made.

## Failure handling and remaining limitation

- An explicit exit status 7 fails, despite completing normally.
- A 1,000-cycle limit stops CRC32 and fails with `completed=0`.
- A missing compiler on a rerun replaces deliberately preexisting successful
  JSON with a failed summary; stale success is not retained.
- A requested LLVM22 GISel CRC32 build fails before simulation with
  `RegisterBankInfo::ValueMapping::verify`, while compiling MLIF's `bench.c`.
  The stage preserves the compiler log and reports failure. GISel selection is
  exposed by the integration, but this compiler/assertion combination is not
  validated as working. The passing workload measurements above use DAG.

The current replay backend supports MLIF's generic C entry point, including
Embench. It needs the source/include paths and compiler dependencies to remain
available. It does not reconstruct deleted generated files or arbitrary extra
CMake-linked frontend libraries. RAM capacity and both bus timing models are
explicit constraints, not claims of support for every Nailgun core configuration.

## Reproduction and affected repositories

See [the integration guide](../../scripts/rtl_sim/README.md).
`reproduce.py --verilator /path/to/verilator-5.040/bin/verilator` rebuilds and
executes all four benchmark/core combinations, using the preserved compilation
exports under `inputs/`. Restore the generated RTL archives referenced by the
CVA5 and Vex HLS reports first if their local `hls-run` trees are absent.

All implementation changes are in **isaac-demo-new**. No new submodule or
external repository edits were required. The staged CVA5 wrapper address
corrections are useful upstream feedback for Nailgun's CVA5 wrapper generation;
the existing SCAIE-V Vex store patch remains in the dedicated HLS image.
