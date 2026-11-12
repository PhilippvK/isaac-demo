# Nangate45 reproduction and Sky130 ASIP synthesis evaluation

## Result

All eight VEX_5S core/extension configurations synthesize successfully in
Design Compiler at a **10 ns (100 MHz) setup target**. Nangate45 uses a trusted
open NLDM view to reconstruct the historical flow; Sky130 is now a separate
selectable standard-cell library. No registered submodule source was changed
for this synthesis work.

| Library | Variant | Cell area (µm²) | Area overhead | Setup slack (ns) | Hold |
|---|---|---:|---:|---:|---|
| nangate45 | baseline | 22,979.74 | 0.00% | 0.0041709 | -0.16 ns; 2061 paths |
| nangate45 | crc32 | 28,706.99 | 24.92% | 0.0059900 | -0.16 ns; 2149 paths |
| nangate45 | branches | 23,200.79 | 0.96% | 0.0069556 | -0.16 ns; 2065 paths |
| nangate45 | stores | 23,182.70 | 0.88% | 0.0071745 | -0.16 ns; 2066 paths |
| sky130hd | baseline | 124,566.97 | 0.00% | 0.0002060 | Pass |
| sky130hd | crc32 | 158,921.16 | 27.58% | 0.0002527 | Pass |
| sky130hd | branches | 126,491.31 | 1.54% | 0.0027180 | Pass |
| sky130hd | stores | 125,781.88 | 0.98% | 0.0010252 | Pass |

Nangate45 passes setup but retains hold violations; `timing_met` is therefore
false for those runs. Sky130 passes the reported synthesis setup and hold
checks. Positive setup margins are tiny (down to about 0.206 ps), so these
results do not establish robust timing closure or silicon maximum frequency.
Hold WNS above has the precision of the QoR report. All runs report zero
macros/black boxes and no unresolved references.

## Library provenance and reproduction boundary

The input Liberty files are pinned to OpenROAD-flow-scripts revision
`a47d4fdc6534cb3cdfdd9ff76737a899a5bb2ee0`, downloaded and SHA256-checked before
local Library Compiler conversion:

- [Nangate45 typical NLDM source](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/blob/a47d4fdc6534cb3cdfdd9ff76737a899a5bb2ee0/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib): 1.1 V, 25 C.
- [Sky130 high-density typical source](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/blob/a47d4fdc6534cb3cdfdd9ff76737a899a5bb2ee0/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib): 1.8 V, 25 C.

The original `.db` location was unavailable, and the user preferred a trusted
open source over supplying the old database. The historical recipe named a
CCS/scan Nangate view; this is a reconstruction using the pinned NLDM view,
not an exact reproduction of that old characterization. Library source/database
hashes and LC logs are in `libraries/`; library binaries remain local under
`install/asip-libs/` and are not included here.

Tools: Design Compiler W-2024.09-SP2 and Library Compiler X-2025.06-SP3, using
the user-provided license environment. DC T-2022.03-SP5 failed at startup with
a GLIBC loader error on this host. LC emits a startup `CLE-100` missing-message
diagnostic; both actual Liberty imports and database writes complete. The
conversion helper accepts only that specific diagnostic and checks completion.

## What was synthesized

The same generated Vex RTL allocations previously validated in RTL and on Arty
were used: baseline, `crc32-fixed`, branches and `stores-fixed`. Every run hashes
the complete core file list plus sibling `ISAX_*.sv` modules. This includes the
core and extension logic, with external instruction/data memories excluded.
The register file is synthesized as core logic. FPGA shells, BRAM, UART and
clock/reset board primitives are not included.

Compilation follows the historical `compile_ultra` plus incremental strategy.
The current DC release ignores the legacy `-timing_high_effort_script` flag;
the warning is preserved. Hold repair was not enabled in the original strategy.
Clock uncertainty is 0.25 ns, transition 0.15 ns, external input/output delay
budgets 20% of the clock period. All non-clock inputs, including reset/debug,
are constrained. Output load is physically 33.4 fF in both technologies:
33.4 Nangate library units versus 0.0334 Sky130 units. Matching technology
inverters model input drivers. No false paths or DRC severity changes are used.

The old Vex constraints referenced Sky130 drivers while selecting Nangate and
assumed pF loading. The corrected flow explicitly selects driver names and
load units per library. It also fixes machine-specific script/library paths,
missing extension sources, pipeline failure reporting, and the ignored
`ASIP_SYN_SYNOPSYS_CLOCK_NS` configuration alias. A separate
`vex_5s_sky130hd.env` preset leaves the original Nangate default intact.

## Evaluation implications and limits

The full CRC32 allocation adds **24.92% area in Nangate45** and **27.58% in
Sky130**. The earlier physical-board intrinsic result was 14,361 versus 16,408
cycles (12.48% fewer cycles). That measures a particular intrinsic schedule
on the board memory model; it is not a measured ASIC workload execution or an
ASIC speedup guarantee. The area is for the full retained allocation, not a
minimal implementation of just the arithmetic-index instruction.

Branch and store allocations add about 1% area, with correctness established
by the existing RTL/FPGA probes; no branch/store performance benefit was
measured here. Compare overhead within each technology: absolute Nangate and
Sky130 area/delay also differ in voltage, library architecture and modeling.

These are core synthesis estimates, not placed-and-routed results. The reports
retain a high-fanout-net warning that uses a fanout estimate of 1000 for delay
calculations. External memory, floorplan, clock tree, extracted parasitics,
other PVT corners, signoff verification and mapped-netlist equivalence are not
covered. Native reports also retain the implicit zero leakage-power objective;
that is not a measured power budget. `report_power` uses default vectorless
activity and is not workload energy evidence. Nangate hold closure remains
required before treating its design as timing-clean.

## Reproduction and saved artifacts

Run `run.sh` with `LM_LICENSE_FILE` set and tool paths available, or follow the
[Design Compiler guide](../../scripts/asip_syn/README.md). The helper evaluates
Nangate first, then Sky130. `--resume` revalidates complete outputs, including
RTL/library/constraint/artifact hashes; it rejects incomplete runs.

`summary.json` and `summary.csv` contain the final parsed measurements with
separate setup/hold status. `preserved/PDK/VARIANT/` contains frozen synthesis
and constraint Tcl, source lists, reports, execution metadata and compressed
Verilog/DDC/SDF/SDC/SVF archives. Disposable tool work trees remain untracked.
Initial report-option failures are retained under `diagnostics/`.

The first successful mappings exposed an unsupported timing-report option and
an unavailable design-area attribute in this DC release. The report option was
corrected; final areas come from DC's native area reports. Completed mapped
outputs were revalidated rather than synthesized again solely to reparse them.
Snapshots retain the exact script version that produced each mapped design.

Validation: all 20 repository tests pass, shell syntax and source whitespace
checks pass, and every final artifact/source/library hash was revalidated.
No changes to previously dirty submodule pointers are included in this work.

Implementation commit: `faf4f1539ab3445d02eed70dcd3c940134a6f76f`.
