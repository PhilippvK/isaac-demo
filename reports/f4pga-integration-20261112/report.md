# Independent F4PGA / SymbiFlow FPGA implementation target

Work began on November 12 and continued on November 13, 2026.

## Measured results

Both designs completed synthesis, packing, placement, routing, FASM conversion,
bitstream generation, native-metric validation, aggregation and preservation.
The final two conversions were resumed from verified routed checkpoints after
the wrapper fixes; physical implementation was not replaced with mocked data.

| Variant | Mapped LUT atoms | FF atoms | RAMB36E1_PRIM atoms | Routed critical path | Setup/hold at 50 ns |
|---|---:|---:|---:|---:|---|
| baseline | 5,575 | 1,232 | 32 | 33.5814 ns | Pass / Pass |
| CRC32 | 9,739 | 1,322 | 32 | 37.4019 ns | Pass / Pass |

Both have 0 DSP atoms. VPR reports sWNS/hWNS = 0 ns (clipped worst-negative
slack), with 4 unconstrained startpoints and 30 unconstrained endpoints. No
hardware execution, numerical firmware result or hardware speedup is claimed.
The F4PGA final histogram reports 32 RAMB36E1_PRIM atoms, while the independent
Yosys 0.62 frontend check reports 64 RAMB36E1 instances. These model counts come
from different mappings; mapped-memory equivalence and capacity on hardware
have not been established by this evaluation.

`results.json` and `evaluation/metrics.csv` contain the measurements. The portable
`evidence/baseline.tar.gz` and `evidence/crc32.tar.gz` archives contain all
checksummed result artifacts, including actual bitstreams and native reports.
They extract as `baseline/` and `default/`; the latter is the CRC32 variant.
Their execution metadata revalidates with the backend without the original
work directory. The hashes of the retained inputs, tools and evidence are in
`preserved-artifacts.json`.

Real baseline reuse was also exercised through `full_flow.sh ... syn_0`, with
preservation and actual `report_0` linking the measurements. Its
`cache-integration/` experiment is a report/cache fixture, not another benchmark.
The dispatcher/environment-snapshot smoke fixture runs no synthesis.

## Integration

`FPGA_SYN_TOOL=f4pga` or `symbiflow` selects a Yosys/VPR/Project X-Ray
implementation backend in the normal `syn_0` stage, independently of Vivado.
The initial target is VEX_5S on Arty A7-100T, xc7a100tcsg324-1, with a fixed
20 MHz core clock. The new `vex_5s_arty_a7_100t_f4pga.env` preset disables ASIP
synthesis and Nailgun's embedded OpenLane evaluation.

The backend stages baseline/default/shared RTL and sibling ISAX sources, exposes
the retirement counter through explicit ports and provides open inferred 256 KiB
RAM instead of Vivado's generated Block Memory IP. Firmware can be embedded as a
little-endian flat binary or hexadecimal COE. Original HLS source files are not
modified. Empty firmware means zero initialization for resource experiments,
not a bootable workload.

The full-100T architecture package has a PLL model but no MMCM model. The staged
shell therefore uses PLLE2_ADV, with 100 MHz × 10 / 50 = 20 MHz at a 1 GHz VCO,
retaining feedback/core BUFGs and the shell's lock/reset synchronization. The
advanced PLL's unused dynamic-reconfiguration inputs are tied off. This is an
intentional clocking implementation difference from the Vivado shell.

An explicit core-net clock is included alongside the oscillator constraint.
Native synthesis also emits propagated clocks. Duplicate clock aliases are
collapsed only when the synthesized JSON proves identical net-bit identities
and period/waveform constraints. Conflicting constraints fail. Both native and
effective SDC files and the alias mapping are preserved. Effective constraints
are explicitly passed to pack, place and route.

Selected results are preserved outside `work/`, with aggregate resource/timing
CSV, native logs, staged RTL, firmware image, final mapped views and bitstream.
Cache reuse checks backend/part/board/clock identity, completed stages, artifact
hashes and metrics against native reports. CI reports link the preserved results.
Suffix selection and local/Docker HLS directories are supported. The existing
Vivado collector columns are retained, with explicit backend/resource provenance.

The native FPGA execution wrapper can select F4PGA and openFPGALoader. Programming
is volatile and serial-selected, keeps existing UART capture/board locking and
requires verified setup and hold metrics. The synthesis stage never programs
hardware. Hardware execution is a separate validation task.

## Toolchain

Official architecture archives:

- `20220907-210059/symbiflow-arch-defs-install-xc7-66a976d.tar.xz`, SHA256
  `8fa1aa9cfc033c9fef59c2ac19d4ff18568a66bc8ce15c3385cd9ec1d1901274`.
- `20220907-210059/symbiflow-arch-defs-xc7a100t_test-66a976d.tar.xz`, SHA256
  `49b355e8a442e46652c7b089c23dc020d4babb8009d8f4494e09d72e37b2e5ef`.

The isolated installation is on scratch storage because the workspace filesystem
was almost full at the start. No pre-existing tools or environments were changed.
The pinned setup helper reproduces the package downloads and installation;
`conda-explicit.txt` and `pip-freeze.txt` record the resolved environment.

- VPR 8.1.0-dev, revision 8.0.0-5699-g25e723a24 (official pinned optimized build).
- Yosys 0.29+34, commit 57c9eb70f, build 20230524_010725_py37; matching F4PGA
  plugins 1.20230425_38_g38a8a5d, build 20230524_010725.
- Project X-Ray tools ae546d6b, database 0a0adde, builds 20220708_203356.
- F4PGA Python wrappers at commit 0723f9ca4ea4b686ff9c2e32c9cec56d40de1a62.

Initial installation attempts and build failures are retained separately. The
original 2022 Yosys 0.19 toolset crashed in ABC9 on the real Vex design; the pinned
0.29 toolset follows the version used by CFU Playground's environment. A trial
with MMCME2_ADV synthesized but failed packing because the architecture has no
MMCM model. Another trial exposed duplicate generated-clock aliases and motivated
the checked SDC normalization. These failures did not produce passing results.

The console FASM wrapper also failed to forward the explicit SDC and masked its
genfasm failure, yielding empty FASM and a blank configuration bitstream. The
backend's artifact validation rejected these runs. The final implementation uses
F4PGA's Python API to pass `--sdc_file constraints.sdc`, and requires logic/BRAM
features before bitstream conversion. Final conversion was retried from verified
routing; metadata records that resumption, route hashes, previous execution state
and finalizer/driver hashes. `runner-before-fasm-fix.py` preserves the exact
controller snapshot used for the physical implementation stages.

Project X-Ray's exclusive lock on read-only database files failed on this NFS
mount. An unchanged local copy of all 771 Artix-7 database files was verified by
SHA256 (`local-database-sha256.json`) and selected with `DATABASE_DIR`. No runtime
source patches or disabled locks were used.

## Validation and limits

The regression suite covers real open-RAM simulation, source staging/adaptation,
all six command stages, dispatch aliases, failure handling, incomplete native
results, timing/clock validation, baseline identity/tamper rejection, preservation,
legacy Vivado resource/overhead collection and timing-gated hardware execution.
Mocked command tests are integration fixtures, not FPGA benchmark measurements.
**52 tests pass**, with shell syntax and source whitespace checks also passing.
See `verification.txt` for the test outcome.

Independent frontend checks synthesized the actual baseline and CRC32 Vex designs
with Yosys 0.62, checking hierarchy and mapped connectivity. The open memory mapped
to RAMB36 primitives. These are frontend checks, not complete F4PGA implementation
results; the matching 0.29 runtime performs another structural check before its
native implementation flow.

F4PGA counts mapped LUT atoms before packing, not Vivado post-route physical LUTs.
LUT6 cells can be split and repacked, and component counts disappear after
flattening. Unknown ISAX/SCAIE-V component values remain blank. BRAM instance
counts and 18K-equivalent counts are separate. Native VPR sWNS/hWNS describe
constrained paths; zero worst-negative slack does not assert a positive timing
margin. Asynchronous reset/UART inputs and UART output have no external timing
requirements in this backend. This is not an identical constraint set or a
controlled tool-only comparison with previous Vivado measurements. Native VPR
architecture defaults/options are retained in the logs.

CVA5, other boards/parts, variable-frequency search, mapped-netlist equivalence,
and full FPGA hardware execution are not claimed by this validation.

## Reproduction

See [the backend guide](../../scripts/fpga_syn/f4pga/README.md).
The pinned installer is `scripts/fpga_syn/f4pga/install.sh`; activate its `env.sh`
through `FPGA_SYN_F4PGA_ENV_SCRIPT`. The retained RTL input archive from the ASIP
follow-up is the same verified source set used here:
`../openlane-asip-20261112/rtl-inputs.tar.gz` (baseline and crc32-fixed).

The flow supports `FPGA_SYN_HLS_DIR` pointing to an extracted variant tree;
`default` should point to `crc32-fixed`. Source the new preset, select the runtime,
and run `scripts/flow_syn.sh OUTPUT` or the normal full-flow `syn_0` stage.
Use a fresh work directory. Explicit baseline reuse is available after a completed
result. No large runtime installation or device database is vendored in Git.

Implementation commit: `79a5523` (demo repository only). No push was performed.
