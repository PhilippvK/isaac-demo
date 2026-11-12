# Design Compiler ASIP synthesis

This flow maps a generated core plus its instruction extensions into an explicit
standard-cell library. The FPGA shell, RAM, UART and board clock/reset logic are
excluded. Outputs are synthesis estimates, not placed-and-routed silicon results.

## Tools and libraries

Provide `dc_shell`, `lc_shell` and your normal license-server environment. Tool
paths can be supplied as `ASIP_SYN_DC_SHELL` and `ASIP_SYN_LC_SHELL` or CLI flags.
The validated installation is DC W-2024.09-SP2 and LC X-2025.06-SP3. The older
DC T-2022.03-SP5 fails to start on this host with a GLIBC loader error.

Download and convert Nangate first:

```bash
python3 scripts/asip_syn/prepare_libraries.py --pdk nangate45 \
  --lc-shell /path/to/lc_shell
```

The helper downloads pinned, SHA256-checked Liberty files from the
[OpenROAD-flow-scripts platform repository](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/tree/a47d4fdc6534cb3cdfdd9ff76737a899a5bb2ee0/flow/platforms).
It compiles `.db` files locally with Library Compiler and records source URLs,
checksums and tool version in `install/asip-libs/PDK/manifest.json`. Libraries
and compiled databases stay in the ignored install tree; they are not vendored.
An installed LC startup message `Error: Message for 'CLE-100' not found` is
retained in its log; the helper accepts this specific startup diagnostic only
when the actual Liberty import/write completes and produces a database.

`nangate45` uses the typical 1.1 V / 25 C Nangate NLDM view. The historical
recipe named `NangateOpenCellLibrary_typical_ccs_scan.db` at a machine-specific
path. That database was unavailable; these results reconstruct the Nangate45
flow using the trusted NLDM view, not a bit-for-bit reproduction of the old
CCS/scan characterization. An existing original database may be selected via
`ASIP_SYN_LIBRARY` for a separate comparison.

## Baseline and extension runs

```bash
ASIP_SYN_DC_SHELL=/path/to/dc_shell \
  bash scripts/asip_syn_script.sh OUTPUT RTL_DIR VEX_5S nangate45 10
```

`RTL_DIR` can contain `files.txt` directly or a `VexRiscv_5s/` core directory.
Source-list paths may be relative or absolute. Sibling `ISAX_*.sv` files omitted
by Nailgun's core file list are included and hashed. Use a fresh output directory
for every run; an existing execution report is rejected to avoid stale evidence.

The wrapper keeps the original positional interface and honors:

- `ASIP_SYN_DC_SHELL`, `ASIP_SYN_PYTHON`, `ASIP_SYN_JOBS`, `ASIP_SYN_TIMEOUT`.
- `ASIP_SYN_LIBRARY`: exact compiled database, overriding library defaults.
- `TECHLIB_PATH`: directory for an existing library; the historical Nangate
  CCS/scan database name is accepted as a fallback.
- The optional sixth positional argument: custom constraints if the file exists.
  Historical `flow_syn.sh` passed an unwritten destination path; in that case
  the technology-aware default constraints apply.

The full flow still uses its `syn_0` stage and existing ASIP enable/skip settings.
`ASIP_SYN_SYNOPSYS_CLOCK_NS` now supplies the period if the older
`ASIP_SYN_SYNOPSYS_CLK_PERIOD` alias is unset. No FPGA settings are changed.

## Sky130

After the Nangate comparison succeeds, prepare the high-density Sky130 view:

```bash
python3 scripts/asip_syn/prepare_libraries.py --pdk sky130hd --lc-shell /path/to/lc_shell
ASIP_SYN_DC_SHELL=/path/to/dc_shell \
  bash scripts/asip_syn_script.sh OUTPUT RTL_DIR VEX_5S sky130hd 10
```

`sky130` is a wrapper alias for `sky130hd`. The opt-in flow preset
`cfg/flow/paper/vex_5s_sky130hd.env` selects this library while retaining the
original Vex candidate policy. The selected typical corner is
`sky130_fd_sc_hd__tt_025C_1v80`, at 1.8 V / 25 C. Nangate and Sky130 use their
own driver cells; no cell name is borrowed from the other technology.
The common 33.4 fF output load is 33.4 in Nangate units and 0.0334 in Sky130
units. Both libraries use ns for time. The constraints use 20% input/output
budgets, 0.25 ns clock uncertainty, 0.15 ns clock transition, maximum fanout 10
and maximum transition 0.75 ns. They time all non-clock input ports, including
reset/debug inputs; there are no hidden false paths.

The old Vex SDC mixed Sky130 drivers with Nangate libraries and scaled its load
as though capacitance were in pF. It remains available as a historical/custom
constraint input; the new default fixes the library cells and physical units.
A 10 ns target is a common comparison constraint, not a promise that Sky130
meets 100 MHz. Setup and hold status are reported separately; `timing_met`
requires both. Successful mapping can still have timing violations. The
legacy CSV `status` column describes setup only. Hold WNS and violating-path
counts are parsed from DC QoR reports; hold WNS has that report's precision.
This recipe reproduces the original compile strategy without `set_fix_hold`;
hold closure remains a separate backend step.

## Matched evaluation

```bash
python3 scripts/asip_syn/evaluate.py \
  --rtl reports/vex-5s-hls-20261107/hls-run \
  --output reports/asip-synthesis-20261112/evaluation \
  --libraries install/asip-libs --clock-ns 10 --parallel 2 --jobs 4 \
  --dc-shell /path/to/dc_shell --lc-shell /path/to/lc_shell
```

This evaluates baseline, CRC32, branch and corrected-store allocations in
Nangate45, then the same variants in Sky130. `--variants` and `--pdks` restrict
the matrix. Missing libraries are prepared before their technology stage.
Use `--resume` to revalidate hashes, reports and artifacts of completed runs
without consuming another synthesis license. Incomplete runs are rejected.
Summary JSON/CSV records cell area, setup slack, timing status and area ratios
within each technology. A synthesis error stops the matrix with its diagnostic
logs retained. Timing violations remain reportable evaluation results.

Every successful run retains source/library/constraint hashes, frozen Tcl/SDC,
full DC output, units, area/timing/QoR/design-rule/reference reports, a mapped
checkpoint and Verilog/DDC/SDF/SDC. `metrics.csv` keeps the legacy collector's
column names; component area fields stay blank when synthesis optimization
has merged hierarchy. A post-mapping checkpoint is written before reporting.

`report_power` uses vectorless default activity and is diagnostic only. Do not
interpret it as workload energy. A synthesis timing result is not measured
silicon frequency. Existing RTL/FPGA tests validate the source design; this
flow alone does not establish mapped-netlist equivalence. No external RAM area,
physical routing, clock tree, parasitic extraction or signoff corners are included.
