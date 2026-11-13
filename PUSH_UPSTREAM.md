# Push and upstream handoff — 2026-11-12

All paths below are relative to `/var/tmp/ga87puy/isaac-demo-new`.
No pushes were performed. Ahead counts refer to locally cached remote-tracking
refs; fetch before publishing to check for newer remote changes. Do not force-push.

## Completed FPGA follow-up commits

| Repository | Commit | Purpose |
|---|---|---|
| MLonMCU (`mlonmcu/`) | `c1915344` | Select FPGA execution explicitly and export hardware evidence. |
| Demo (`.`) | `183e7c2` | FPGA runner/full-flow stage, intrinsic firmware variant, board locking, tests and usage guide. |
| Demo (`.`) | `af5d4ea` | Physical CRC32 acceleration, branch/store probes, native MLonMCU/sine evidence and reproduction. |

The implementation/evidence split is intentional. The demo implementation pins
MLonMCU `c1915344`; publish that commit before the demo. The FPGA follow-up
report is `reports/vex-fpga-followup-20261110/report.md`.

## Repositories to publish

The current demo branch also includes earlier local changes. To publish its
complete history with fetchable dependencies, publish these repositories first:

| Local location | Configured origin | Branch | Local unpublished work versus cached tracking ref |
|---|---|---|---|
| `install/mlonmcu/deps/src/mlif` | `tum-ei-eda/mlonmcu-sw` on GitHub | `isaac-demo-rebased` | `713f9e8`: Nailgun bare-metal runtime, toolchains and scoped LLVM22 GISel workaround. |
| `M2-ISA-R` | `tum-ei-eda/M2-ISA-R` on GitHub | `coredsl2` | 3 commits, through `2f32e39`: staticness, branch/encoding constraints, affine memory ranges. |
| `isaac-toolkit` | `tum-ei-eda/isaac-toolkit` on GitHub | `main` | 4 commits, through `723433e`: decoder, query/HLS constraints and x0-safe writeback. |
| `memgraph_experiments` | `PhilippvK/memgraph_experiments` on GitHub | `main` | `77179c2`: fused memory and branch candidates. |
| `seal5` | `tum-ei-eda/seal5` on GitHub | `main` | 3 commits, through `8d73694`: legalizer compatibility, build/report controls, memory/branch patterns. |
| `mlonmcu` | `tum-ei-eda/mlonmcu` on GitHub | `isaac-demo-rebased` | 3 commits: `dadb2a56` native target, `4d03f7f4` unquantized validation inputs, `c1915344` FPGA execution. |
| `.` | `Philippvk/isaac-demo` on GitHub | `main` | 19 commits through `af5d4ea`, plus this handoff commit: flows, adapters, dependency pins and selected evidence. |

Commands, run from the demo root:

```bash
git -C install/mlonmcu/deps/src/mlif push origin isaac-demo-rebased
git -C M2-ISA-R push origin coredsl2
git -C isaac-toolkit push origin main
git -C memgraph_experiments push origin main
git -C seal5 push origin main
git -C mlonmcu push origin isaac-demo-rebased
git push origin main
```

These are existing working branch destinations, not instructions to merge into
upstream default branches. If a branch is protected, push a topic branch and
open a PR. Changes rebased or cherry-picked upstream get different IDs: update
the demo's gitlinks before publishing those replacements.

Seal5's untracked `examples/cdsl/` and `seal5/frontends/coredsl2_seal5/` remain
untouched. They are not included in these commits or in a normal push.

## Separate source upstreaming

- **MLonMCU**: upstream the native target/FPGA adapter and model-input fix from
  `isaac-demo-rebased` to the appropriate maintained branch.
- **MLIF (`mlonmcu-sw`)**: upstream `713f9e8` separately. The demo also preserves
  its changes in `cfg/mlif/nailgun.patch`; the dependency is not a Git submodule.
- **SCAIE-V Vex backend**: submit `cfg/hls/patches/scaiev-vex-subword-stores.patch`
  to the source repository owning `src/scaiev/backend/VexRiscv.java`. The patch
  currently lives in the demo and is applied by `docker/Dockerfile_hls_vex`;
  there is no new SCAIE-V repository commit in this workspace to push.
- **CVA5 SCAIE-V integration and Nailgun top generator**: move the staged-source
  corrections in `scripts/fpga_syn/boards/arty_a7_100/prepare_scaiev.py` and
  `prepare_top.py` into their authoritative integration/generator sources.
  See `reports/upstreaming-20261107/README.md` for source ownership and caveats.
- **ISAAC LLVM fork**: the reusable LLVM22 port is preserved in
  `cfg/seal5/llvm22-isaac.patch`. Upstream to the ISAAC LLVM fork or continue
  applying it through Seal5; generated target/experiment changes are not a
  general LLVM submission. The disposable `llvm-project-22` tree is not a
  registered submodule and has no new push requirement from the FPGA follow-up.

No new FPGA-follow-up commits are needed in `isaac-docker-service`, `etiss`,
`etiss_arch_riscv`, `mgclient`, or the registered LLVM19 `llvm-project` submodule.

## ASIP synthesis follow-up

Demo commit `faf4f15` adds reproducible Nangate45/Sky130 Design Compiler
synthesis, library preparation, an opt-in Sky130 preset and tests. A separate
evidence commit preserves the eight-run evaluation under
`reports/asip-synthesis-20261112/`. These changes belong only in
`Philippvk/isaac-demo`; no additional source-repository push is required.
Open library downloads and compiled databases remain local in
`install/asip-libs/` and can be regenerated with the documented helper.
Concurrent submodule pointer edits were excluded from the ASIP commits.

## Independent OpenLane2 / LibreLane follow-up

Demo commit `9b3be24` integrates both controllers as independent `syn_0`
backends, with presets, collection, cache validation and evidence preservation.
The accompanying evidence commit retains the four real Sky130 synthesis runs
and reproduction inputs under `reports/openlane-asip-20261112/`. All four
map successfully; all fail the requested 10 ns setup target. OpenLane2 validation
uses the documented isolated Yosys API adapter.

Only the demo repository needs pushing for this addition:

```bash
git push origin main
```

No dependency commits or submodule pointer changes are included. The PDK,
container image and isolated controller install remain local and are not pushed.

## Independent F4PGA / SymbiFlow follow-up

Demo commit `79a5523` adds the independent VEX_5S Arty A7-100T backend,
open board adapters, checked baseline/route reuse, resource/timing reporting
and an openFPGALoader execution path. A separate evidence commit retains
baseline/CRC32 routed results and bitstreams under
`reports/f4pga-integration-20261112/`. Both meet the 50 ns constrained-path
setup/hold target; hardware execution and mapped-memory equivalence remain
unverified. See the report for the PLL, memory-model and timing-scope limits.

This follow-up requires only the demo repository push:

```bash
git push origin main
```

No F4PGA, Vivado, MLonMCU or other dependency source repository changed.
Concurrent submodule edits remain excluded. The isolated tool installation and
device database are local; the pinned installer recreates them.
