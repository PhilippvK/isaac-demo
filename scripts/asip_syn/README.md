# ASIP synthesis backends

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

## Independent OpenLane2 and LibreLane target

Select `ASIP_SYN_TOOL=librelane` or `ASIP_SYN_TOOL=ol2` (`openlane2` and
`openlane` are aliases). These run as the normal `syn_0` synthesis stage after
RTL generation, independently of Nailgun's HLS plugin. The opt-in
`vex_5s_librelane.env` and `vex_5s_openlane2.env` presets disable
`HLS_NAILGUN_OL2_ENABLE` and select the corresponding standalone target.

```bash
source scripts/env.sh
source cfg/flow/paper/vex_5s_librelane.env
export ASIP_SYN_OL2_PDK_ROOT=/path/to/complete/pdk/root
# Use a native installation, with tools available in that environment:
export ASIP_SYN_OL2_COMMAND='/path/to/python -m librelane'
scripts/full_flow.sh crc32 latest syn_0
```

For a pinned Docker runtime instead of a native command:

```bash
unset ASIP_SYN_OL2_COMMAND
export ASIP_SYN_OL2_DOCKER_IMAGE=ghcr.io/librelane/librelane@sha256:4bc9042ba177f73f275b5b39e7d372a07d3f4043f548a0ba7f640097b7205051
```

The Docker mode runs under the caller's UID/GID, with only the run directory
writable and the PDK mounted read-only. Network access is disabled inside the
flow container. A local or manually installed PDK is required; a Liberty-only
installation from the DC helper is insufficient. Install a full PDK with the
engine's documented Volare/Ciel workflow first. A Docker daemon must be able to
traverse the mount source; NFS root-squash can require a local selected-library
cache. `ASIP_SYN_OL2_PDK_MOUNT_SOURCE` optionally supplies the daemon's path alias.
Native installations do not need this setting.

The explicit custom flow is: Yosys JSON header, synthesis, unmapped-cell checker,
synthesis-check checker, SDC validation and OpenROAD pre-PnR STA. It stops before
floorplanning. No checker is disabled. A negative timing result remains a
successful mapping measurement, with `setup_timing_met`, `hold_timing_met` and
`timing_met` reported separately. Missing/non-finite metrics, missing STA state,
unmapped cells and failed synthesis checks fail the target.

Sky130 aliases `sky130` and `sky130hd` map to `sky130A` / `sky130_fd_sc_hd`.
The default analysis corner for Sky130 is `nom_tt_025C_1v80`. Other installed
PDKs require a valid `--scl`/`ASIP_SYN_OL2_SCL` and their own configuration;
PDK defaults apply unless a corner is specified. Nangate45 is not silently
mapped to Sky130: provide a complete compatible Nangate PDK if using that name.
The current validation covers Sky130/VEX_5S; CVA5/VEX_4S are accepted interfaces
but have not been validated with this backend in this change.

Additional settings:

- `ASIP_SYN_OL2_CORE_NAME`, `ASIP_SYN_OL2_CLOCK_NS`, `ASIP_SYN_OL2_PDK`.
- `ASIP_SYN_OL2_SCL`, `ASIP_SYN_OL2_CORNER`, `ASIP_SYN_OL2_STRATEGY` (default `AREA 0`).
- `ASIP_SYN_JOBS`, `ASIP_SYN_TIMEOUT`, `ASIP_SYN_PYTHON` apply to either backend.
- `ASIP_SYN_HLS_DIR`, `ASIP_SYN_OUTPUT_DIR`, `ASIP_SYN_REPORT_DIR` override inputs,
  work outputs and preserved evidence. Baseline/default/shared skips and
  `ASIP_SYN_BASELINE_USE` work across the backends; mixed backend/library/clock
  comparisons are rejected when collecting metadata. Reusable baselines must
  contain `execution.json`; metrics-only legacy caches need regeneration.

OpenLane/LibreLane work directories are separate from DC's legacy directory:
`work/MODE/asip_syn_openlane2_SUFFIX` and `asip_syn_librelane_SUFFIX`, versus
DC's `asip_syn_SUFFIX`.
Selected reports and compressed final views are preserved outside `work/` and
linked by `report_0`. Selection suffixes are applied consistently to HLS inputs,
synthesis outputs and evidence. Fmax search is explicitly unsupported; use
period sweeps instead of the former placeholder path.

Both backends produce the legacy `metrics.csv` columns plus `execution.json`.
The normal aggregate CSV now retains backend identity, library and timing
status. Component area remains blank when optimization merges hierarchy.
Final native state, resolved configuration, library hashes and mapped views
are preserved. The matrix evaluator also accepts `--tool librelane` or
`--tool ol2`, with `--pdk-root`, `--docker-image` or `--command` and optional
`--scl`/`--corner`. Use separate output directories per backend.

Use a matching controller/tool installation. OpenLane2 2.3.10's Pyosys interface
is incompatible with Yosys 0.62 out of the box. The validation-only controller
overlay uses the single API adapter saved with the experiment; the backend
does not patch installed tools automatically. A normal matching OpenLane2
installation can be used directly, or use LibreLane's pinned complete runtime.

See [the independent-target validation report](../../reports/openlane-asip-20261112/report.md)
for tool/PDK versions, actual synthesis results and reproduction commands.
Upstream references: [LibreLane custom flows](https://librelane.readthedocs.io/en/latest/usage/writing_custom_flows.html),
[Docker installation](https://librelane.readthedocs.io/en/latest/installation/docker_installation/index.html),
and [OpenLane2 custom flows](https://openlane2.readthedocs.io/en/stable/usage/writing_custom_flows.html).
