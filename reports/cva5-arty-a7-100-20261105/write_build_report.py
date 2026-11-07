import json
from pathlib import Path
r = Path(__file__).resolve().parent
rows = json.loads((r / 'results.json').read_text())
labels = {'baseline':'Baseline', 'crc32-scaiev2-final':'CRC32: all 116 ISEs', 'memory-cva5-final':'5 CRC32 load ISEs', 'branches-fixed':'6 branch probes', 'store-probes':'3 store probes'}
lines = ['# CVA5 synthesis with Arty A7-100 board constraints', '',
'Vivado 2024.1, actual part `xc7a100tcsg324-1`, top `cva5_arty_top`.', '',
'## Implemented changes', '',
'- Added an Arty shell around the unmodified generated CVA5/HLS RTL. AXI stays inside the FPGA. The single-beat peripheral master connects to AXI UART Lite; inactive cache buses are terminated internally. The build rejects core configurations with caches or the external instruction bus enabled.',
'- Added 100 MHz to 20 MHz MMCM clock generation, global clock buffers, lock-dependent reset with synchronized release, and active-high button-0 reset.',
'- Added E3 clock, D9 button, A9 UART RX, D10 UART TX constraints, all LVCMOS33, plus configuration bank voltage settings. The board oscillator is constrained to 10 ns; Vivado derives the actual 50 ns core clock.',
'- UART is configured at 115200 baud, 8N1, with its registers at `0x60000000` (aliased throughout the peripheral window). Clock, reset button, RX, TX are the only four package signals.',
'- The main `cva5_reuseio` preset now selects the board and correct part. The existing synthesis script supports `FPGA_SYN_BOARD=arty_a7_100`, the board top and IP, absolute/relative file lists, and `FPGA_SYN_PYTHON` for CSV reporting.', '',
'## Routed results', '',
'Complete board/core/extension totals, including two 256 KiB local memories. BRAM tiles are RAMB36 equivalents. The device has 63,400 LUTs, 126,800 FFs, 135 BRAM tiles and 240 DSPs.', '',
'| Variant | LUTs | FFs | BRAM tiles | DSPs | Core setup slack (ns) | Overall setup slack (ns) | Bitstream |',
'|---|---:|---:|---:|---:|---:|---:|---|']
for x in rows:
 lines.append(f"| {labels[x['variant']]} | {x['LUTs']:,.0f} | {x['FFs']:,.0f} | {x['BRAM_tiles']:g} | {x['DSPs']:g} | {x['core_WNS_ns']:+.3f} | {x['WNS_ns']:+.3f} | {'Generated' if x['bitstream'] else 'Pending'} |")
lines += ['',
'Core slack is for the 20 MHz intra-clock paths. Overall slack also includes the UART TX output constraint relative to the 100 MHz board oscillator; it must not be interpreted as a maximum core frequency.', '',
'## Checks and scope', '',
'- Each reported completed build ran synthesis, optimization, placement, routing and `write_bitstream`. The synthesis script explicitly rejects unresolved black boxes. Core and extension hierarchy utilization is retained to show the designs were not replaced by empty shells.',
'- A separate mapped-netlist inspection confirms the branch redirection request is driven by a LUT6 with 69 internal loads. Combinational optimization moves branch logic across hierarchy boundaries, so the zero-LUT ISAX_XBranch hierarchy row is not evidence of an absent branch control path. See `branch-connectivity.log` and `inspect_branch.tcl`. This connectivity check is not functional execution.',
'- All five final timing summaries state that all user-specified timing constraints are met, including hold. There are no missing clocks or unconstrained internal endpoints. UART RX and the reset button are asynchronous inputs excluded from synchronous input timing; UART RX synchronization is provided by the IP and core reset release by the shell. The input-delay diagnostic for those asynchronous ports is not a synchronous timing guarantee.',
'- Final DRC contains DSP pipelining warnings. There are no missing pin/I/O-standard/voltage findings, no DRC errors or critical warnings, and no DRC severity downgrades. Raw logs retain separate non-DRC warnings from IP synthesis in project mode and inability to write user Tcl/WebTalk settings.',
'- Synthesis retains 130 BRAM tiles (96.3% of capacity), leaving only five tiles for future features. The full set has 111 arithmetic and five load ISEs and uses unshared HLS implementations. Six branches and three stores are supplemental probes, not CRC32-discovered speedups.',
'- These bitstreams were not programmed. No firmware image was supplied; workload boot, UART execution, RTL functional behavior and speedup were not measured. The result establishes board-constrained physical implementation and bitstream generation.', '',
'## Reproduction and files', '',
'- [Board-shell usage and memory/UART details](../../scripts/fpga_syn/boards/arty_a7_100/README.md). `FPGA_SYN_INIT_COE` optionally initializes both local memory IP instances from a common firmware image; its path must be absolute. No DDR controller or runtime loader is included.',
'- `bash reports/cva5-arty-a7-100-20261105/reproduce.sh` rebuilds all variants using the retained HLS source file lists and the project Python environment.',
'- [CSV](results.csv), [JSON](results.json), [source and bitstream hashes](sha256.json). Each `builds/VARIANT` directory contains `cva5_arty_top.bit`, `synthesized.dcp`, `routed.dcp`, raw logs and `reports/` (hierarchy CSVs, utilization, timing, power and DRC).',
'- The first attempt exposed a missing IP-netlist generation step, fixed by explicit IP synthesis. The initial successful baseline/full implementations then hit a CSV-only missing-pandas error under the host Python; their reports were regenerated with `venv/bin/python`, and subsequent builds use that interpreter explicitly. No hardware-source patch or resynthesis was needed for that reporting issue.',
'- The earlier [xc7a200t core-only report](../cva5-fpga-20261105/report.md) is a different target and top. Those timings/resource percentages are not Arty results. The same HLS RTL is used here, but logic connected only to removed external buses may be optimized differently.', '']
(r / 'build-results.md').write_text('\n'.join(lines))
