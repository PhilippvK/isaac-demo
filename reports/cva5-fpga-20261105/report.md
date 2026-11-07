# CVA5 / SCAIE-V 2.0 FPGA synthesis and implementation

Vivado 2024.1 from `/nfs/tools/xilinx/Vivado/2024.1/`, Artix-7 `xc7a200tffv1156-1`, top `cva5_top`, 50 ns clock period (20 MHz). Fresh baseline and four extensions use the retained Nailgun HLS outputs in [the HLS report](../cva5-reuseio-hls-20261105/report.md). No RTL source changes were needed for Vivado.

## Results

All figures below are complete core totals, including the same two 256 KiB local memories. BRAM tiles are RAMB36 equivalents (RAMB36 + RAMB18 / 2), not a direct sum of primitive counts.

### After synthesis

| Variant | LUTs | FFs | BRAM tiles | DSPs | Setup slack (ns) |
|---|---:|---:|---:|---:|---:|
| Baseline | 3,511 | 2,033 | 130 | 4 | +38.693 |
| CRC32: all 116 ISEs | 13,571 | 4,441 | 130 | 160 | +35.195 |
| CRC32: 5 load ISEs | 4,046 | 2,236 | 130 | 4 | +35.251 |
| 6 branch probes | 3,804 | 2,083 | 130 | 4 | +38.683 |
| 3 store probes | 3,554 | 2,120 | 130 | 4 | +36.967 |

### After placement and routing

| Variant | LUTs | FFs | BRAM tiles | DSPs | Setup slack (ns) |
|---|---:|---:|---:|---:|---:|
| Baseline | 3,439 | 2,067 | 130 | 4 | +29.978 |
| CRC32: all 116 ISEs | 13,359 | 4,474 | 130 | 160 | +18.347 |
| CRC32: 5 load ISEs | 3,953 | 2,270 | 130 | 4 | +27.964 |
| 6 branch probes | 3,732 | 2,117 | 130 | 4 | +29.798 |
| 3 store probes | 3,478 | 2,154 | 130 | 4 | +27.292 |

## Interpretation

- All five designs passed synthesis, including the explicit check for unresolved black boxes. All five completed placement/routing and met the specified internal clock constraints; see the individual timing summaries for setup, hold, and pulse-width results.
- The full CRC32 set contains 111 arithmetic and 5 load ISEs. Resource sharing across instructions was disabled for these HLS outputs. The extension hierarchy survives synthesis and accounts for 156 additional DSPs; the complete routed design adds 9,920 LUTs and 2,407 FFs over baseline. This is a measurable cost of the present unshared implementation, not the minimum cost achievable for CRC32.
- Routed load-only overhead is 514 LUTs and 203 FFs, with no additional DSP or BRAM. Routed branch-only overhead is 293 LUTs and 50 FFs, with no additional DSP or BRAM. Routed store-only overhead is 39 LUTs and 87 FFs, also with no additional DSP or BRAM. Standalone probe encodings differ from the full CRC32 allocation, so costs need not add linearly.
- The full design has less timing margin than baseline. Its worst reported setup path runs from the data-memory return path through core/SCAIE-V forwarding to an extension multiplier: 31.275 ns data delay, of which 28.351 ns is routing. No frequency sweep was performed; these results are not measured maximum operating frequencies.

## Scope and limitations

- CRC32 produced the actual arithmetic/load candidates. Branch and store sets are supplemental instruction probes (six fused condition variants and SB/SH/SW respectively), not discovered CRC32 speedups.
- This establishes synthesizability, physical fit, and timing for these generated designs. RTL functional simulation, FPGA execution, workload utilization, and runtime speedup were not measured in this run.
- HLS scheduling used 100 ns; FPGA implementation here uses the configured 50 ns period and still meets timing.
- Only the internal clock is constrained. External AXI I/O delays, board pin assignments, I/O standards, CFGBVS and configuration voltage are not specified. Routed DRC reports retain those board-related findings. No bitstream was generated and no board was programmed.
- Synthesis logs contain ordinary warnings about unused/unconnected signals, widths, and disabled logic. Logged undriven/latch warnings introduce no additional messages versus baseline. Message suppression prevents treating this comparison as exhaustive functional verification. The generic synthesis script also emits setup critical warnings about the local Tcl store, project-mode `synth_ip`, duplicate IP addition, and incremental source additions; actual core synthesis completes. Raw logs and [warning summaries](warnings.json) are retained.

## Reproduction and retained artifacts

- [Machine-readable results](results.csv), [JSON](results.json), [tool and target settings](provenance.json), [RTL source hashes](source-sha256.json).
- Each variant directory contains raw Vivado synthesis/implementation logs, utilization and hierarchy reports, timing summaries and paths, DRC reports, `synthesized.dcp` and `routed.dcp`.
- `bash reports/cva5-fpga-20261105/reproduce.sh` reruns all designs. Source file lists refer to the retained HLS outputs in this checkout. `synthesize.tcl` uses the repository FPGA recipe through synthesis, accepts absolute source paths, limits threads, checks black boxes, and retains a checkpoint. `implement.tcl` resumes that checkpoint through routing.
- `cfg/flow/paper/cva5_reuseio.env` now enables FPGA synthesis, clears the stale external baseline path, and sets `FPGA_SYN_VIVADO_CLK_PERIOD=50`, the variable consumed by `flow_syn.sh`. ASIP synthesis remains disabled.

## Subsequent on-board execution

See the [firmware execution report](../cva5-fpga-execution-20261105/report.md).
Actual execution required correcting the generated RAM byte/word address
boundary and output-register latency. The execution work also checks fused
branch and subword-store semantics; the physical synthesis results above
alone do not establish those functions.
