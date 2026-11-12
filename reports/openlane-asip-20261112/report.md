# Independent OpenLane2 / LibreLane ASIP synthesis target

## Result

OpenLane2 and LibreLane now run as independent `syn_0` ASIP synthesis backends,
selected by `ASIP_SYN_TOOL=ol2` or `librelane`. Nailgun generates RTL only; its
embedded OpenLane plugin is disabled by the new presets. The DC backend remains
available under `synopsys`, with its original output directory convention.

Real baseline and CRC32-extended VEX_5S runs completed through the normal
synthesis stage, unmapped-cell/synthesis checks, pre-PnR STA and aggregate report
collector in both controllers:

| Controller | Variant | Cell area (µm²) | Setup slack at 10 ns | Hold |
|---|---|---:|---:|---|
| librelane | baseline | 182,048.35 | -9.9769 ns | Pass |
| librelane | crc32 | 239,086.80 | -14.8083 ns | Pass |
| openlane2 | baseline | 182,048.35 | -9.1328 ns | Pass |
| openlane2 | crc32 | 239,086.80 | -13.7384 ns | Pass |

All four are successful mapped designs, but **all fail the 10 ns setup target**.
The pipeline deliberately keeps mapping success separate from setup/hold status.
No timing closure or hardware speedup is claimed. The CRC32 allocation adds
about **31.33% mapped cell area** with the selected `AREA 0` strategy. The controllers
produce the same mapped areas with the shared toolchain; their native SDC/STA
semantics yield different setup slack, which is retained rather than forced equal.

## Fully integrated behavior

- `flow_syn.sh` dispatches DC, OpenLane2 and LibreLane with the same
  baseline/default/shared selection, skip controls and reusable baseline interface.
- The target is independent of HLS and takes generated `files.txt` inputs,
  including sibling `ISAX_*.sv` modules and staged include headers.
- Work/evidence directories include backend and selection suffixes, allowing DC
  and open-source results to coexist. The DC legacy path stays unchanged.
- Aggregate CSV preserves backend, PDK, clock, setup/hold status and area overhead.
  Cached baselines with mismatched backend/library/clock or failed metadata are
  rejected; metrics-only legacy caches require regeneration.
- Selected evidence and compressed final views are retained outside disposable
  `work/` directories. `report_0` links the preserved measurements.
- The matrix evaluator accepts `--tool librelane` and `--tool ol2`, including
  hash-checked reuse of completed runs.
- Former Fmax-search placeholders now fail explicitly; no Fmax result is invented.

The six explicit steps are Yosys JSON header, synthesis, unmapped-cell check,
synthesis checks, SDC validation and OpenROAD pre-PnR STA. No checker is disabled,
and the target stops before floorplanning. It is an alternative to DC logic
synthesis, not a full RTL-to-GDSII implementation run.

## Validation environment

LibreLane 3.0.16 runs in its pinned official amd64 image:

`ghcr.io/librelane/librelane@sha256:4bc9042ba177f73f275b5b39e7d372a07d3f4043f548a0ba7f640097b7205051`

The runtime supplies Yosys 0.62 and OpenROAD 2026-02-17. OpenLane2 uses the
pinned 2.3.10 controller wheel over the same runtime to avoid downloading a
second large tool image on a nearly full host. Its old Pyosys C++-mangled entry
point is incompatible with Yosys 0.62; the validation-only
`openlane2-yosys-api.patch` replaces that one call with the supported interface.
The backend does not apply third-party patches automatically. A native or
matching official OpenLane2 installation is supported by the same launcher
interface; its separate official image was not used in this validation.

The Sky130A PDK is the existing open_pdks revision
`bdc9412b3e468c102d01b7cf6337be06ec6e9c9a`, with `sky130_fd_sc_hd` and typical
`nom_tt_025C_1v80` analysis. Docker's daemon could not traverse the NFS-backed
cache, so the selected cell-library views and flow setup were copied to the
ignored `install/asip-pdks/` tree. Legacy I/O LEF/Verilog references were also
copied for the OpenLane2 config loader; no I/O cells are instantiated by these
core designs. The original cache remains unchanged. No PDK/library binaries are
vendored in Git. `PDK_SOURCES`, resolved configs and actual Liberty hashes record
provenance. `toolchain.json` records the image/controller/wheel identity.

Runtime containers use the caller's UID/GID, a writable run directory, a
read-only PDK mount and no network access. The controller can instead run in a
native configured environment via `ASIP_SYN_OL2_COMMAND`.

## Scope and comparison limits

The core and its extension logic are synthesized; external RAM, FPGA shells,
board peripherals, physical routing and extracted parasitics are excluded.
Default PDK timing assumptions and the engine's native fallback SDC are recorded
in resolved configs. Only the typical analysis corner was requested. No
signoff, mapped-netlist equivalence or post-layout maximum frequency is claimed.

The previous DC experiment used a different pinned Sky130 Liberty distribution
and different optimizer/constraint handling. Its smaller area and positive setup
slack are not a controlled tool-only comparison. Both flows retain native
configuration, data hashes and reports so a stricter matched-library experiment
can be performed later. The verified source RTL is the same retained input set.

## Reproduction

See [the backend guide](../../scripts/asip_syn/README.md#independent-openlane2-and-librelane-target)
for standard usage with `full_flow.sh ... syn_0`. `run.sh` reproduces the synthesis
stage from `rtl-inputs.tar.gz`, without rerunning Nailgun or discovery. It requires
a complete compatible PDK and an installed native or Docker runtime. The input
archive is checked against each run's source hashes.

For the exact OpenLane2 compatibility validation, download/extract its wheel
with `pip download --no-deps openlane==2.3.10`, verify the SHA256 in
`toolchain.json`, apply `openlane2-yosys-api.patch` within the isolated extracted
package, and select `openlane2-launch.sh` as the command. This adapter is not
needed when using a matching controller/tool installation.

`preserved/ENGINE/VARIANT/` contains execution metadata, config, metrics, tool
output and an archive of final mapped views/native STA reports.
`cache-integration/` demonstrates reusable baseline preservation for all three
backends and actual CI report links; its tiny experiment files are explicitly
an integration fixture, not another benchmark measurement. The matrix logs
record completed-run revalidation. Initial PDK-mount/config/API failures are
retained as diagnostics, separate from the four successful results.

Validation: **36 tests pass**, covering variant/suffix dispatch, report
collection/preservation, required STA completion, unmapped/check errors,
non-finite metrics, artifact tampering and incompatible baseline rejection.
Shell syntax, source whitespace and archived artifact hashes are checked.
Existing dirty submodule pointers and Seal5 files remain untouched. No push
was performed. These changes belong only in the demo repository.

Implementation commit: `9b3be24ea12e9c8a464dd6140f5e5a025e541662`.

Primary tool references: [LibreLane custom flows](https://librelane.readthedocs.io/en/latest/usage/writing_custom_flows.html),
[LibreLane Docker installation](https://librelane.readthedocs.io/en/latest/installation/docker_installation/index.html),
and [OpenLane2 2.3.10 package](https://pypi.org/project/openlane/2.3.10/).
