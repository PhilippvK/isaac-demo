# Preservation and upstreaming handoff

All implementation changes were committed locally in separate batches. Nothing
was pushed. Push submodule commits before publishing the demo's new gitlinks;
otherwise a fresh recursive checkout cannot fetch those unpublished commits.
`commits.json` lists the ten new submodule commits and five implementation
commits in the main repo. The subsequent evidence/documentation commit contains
this handoff, portable backups, and selected experiment results.

## Repositories with new commits

| Repository | New commits | Upstream action |
|---|---|---|
| Main `isaac-demo` | `3a31083`, `309c148`, `bd738ed`, `d27324b`, `ba65154`, plus the evidence commit | Publish flow/configuration, LLVM patch, selector comparison, FPGA/firmware support and updated submodule pins together. |
| `tum-ei-eda/M2-ISA-R` (`coredsl2`) | `df47075`, `79286a3`, `2f32e39` | Intrinsic staticness, signed B-format offsets, constrained encoding allocation, and affine memory-range export. |
| `tum-ei-eda/isaac-toolkit` (`main`) | `7ec17eb`, `875aca7`, `4e9da97` | LLVM BB-map decoder, configured query limits, self-contained HLS state, SCAIE-V constraints, signed/scaled HLS immediates. Requires the new M2-ISA-R encoding API. |
| `PhilippvK/memgraph_experiments` (`main`) | `77179c2` | Fused scalar load/store and six conditional branch generation, operand/effect handling, conservative filtering. Requires matching typed M2-ISA-R/Toolkit consumers. |
| `tum-ei-eda/seal5` (`main`) | `54fe09e`, `dfea1af`, `8d73694` | LLVM 20+ legalizer adaptation, compiler-test reporting/build controls, memory and branch TableGen generation. Branch patterns remain DAG-only; memory can use normal GlobalISel import. |

Earlier query-filtering and Sankey fixes were already committed before this
batch (including demo `d457ee9`/`682430b`, Toolkit `439c6ec`, Memgraph
`b150538`/`6a92f11`); they were not duplicated.

Each changed submodule has both an incremental `.bundle` and a mail-format
`.patch` here. Bundles retain the original commit IDs and require the recorded
base objects. For example, in an initialized Toolkit checkout:

```sh
git -C isaac-toolkit fetch ../reports/upstreaming-20261107/isaac-toolkit.bundle HEAD
# FETCH_HEAD is 4e9da973a363b1c4f7285a25fff3d95e67a43ebc.
```

The patches can instead be applied with `git am` on the recorded bases:

| Submodule | Base before these changes |
|---|---|
| M2-ISA-R | `59ba470011fafe5e814a2b9ca9504d8175fe25cc` |
| ISAAC toolkit | `5b9ec155a38f1aa787c6747cfe8ada50cf917e0b` |
| Memgraph experiments | `64a7fa938d0d2f3273078eb67010ee6e434b46ac` |
| Seal5 | `f8b4ab8f089be1c143b0100159671c1b5802aee4` |

## External patches and integration work

- **LLVM/ISAAC fork:** `cfg/seal5/llvm22-isaac.patch` is the maintained LLVM
  22 CDFG/BB-identity port. Carry it in the ISAAC LLVM fork or keep applying it
  through Seal5. `llvm-project-22` is a disposable checkout, not a new submodule.
  Its existing final experiment commits are backed up in
  `llvm22-final-experiment.patch`, against
  `ca7933e47d3a3451d81e72ac174dcb5aa28b59d1`. This full series contains generated
  XMem patterns as well as reusable patches; do not submit it wholesale to LLVM.
- **CoreDSL2LLVM/PatternGen:** the matching `llvm-22.1.8` release branch is a
  dependency. `llvm22-pattern-backend.patch` preserves the backend support
  imported by Seal5 (experiment commit `84d3e741`). No separate dirty
  CoreDSL2LLVM checkout was found in this workspace; do not assume that this
  imported patch represents a new unsubmitted change to that repository.
- **CVA5 SCAIE-V integration:** the generated `core/scaiev_unit.sv` forces
  injected accesses to word width. `cva5-scaiev-memory-width.patch` derives
  funct3 from the active instruction instead. The production adapter is
  `scripts/fpga_syn/boards/arty_a7_100/prepare_scaiev.py`. Submit the fix to the
  CVA5 SCAIE-V integration source and, if generated there, its SCAIE-V template.
  The image's CVA5 checkout names the `scaiev_integration` branch of the TU
  Darmstadt `scale4edge/scaie-v-cores/cva5` repository and the
  `PhilippvK/cva5-sv` fork. Locate the authoritative template before submission.
- **Nailgun/CVA5 top generation:** `nailgun-cva5-word-address.patch` preserves
  the byte-address to RAM word-index correction and full-width wires.
  `prepare_top.py` applies this to staged synthesis input. Move the correction
  into the generator/template that emits `CVA5_top.v`; changing a generated
  file alone will not survive regeneration. No Longnail scheduler change is
  required by the evidence collected here.
- **RAM IP latency and Arty shell:** maintained in this demo's synthesis recipe;
  these are not changes to Vivado or the upstream generic CVA5 core.

These standalone CVA5 patches are against the saved generated HLS source,
not guaranteed to apply directly to a generator template. The raw source is in
`../cva5-reuseio-hls-20261105/selected-generated-rtl.tar.gz`.

## Validation boundary and remaining issue

Physical Arty execution passed native CRC32, 1280 generated load checks,
five matching CRC32 cycle pairs, and 48 byte/halfword/word store checks.
The explicit CRC32 load intrinsic reduces steady kernel cycles by 13.31%.
A taken backward fused BGEU still stalls. Signed/scaled displacement export is
fixed, but the branch integration is **experimental and not fully validated**.
The unsuccessful handshake experiment stays in report artifacts and is not
part of the production adapter. Keep the experimental presets opt-in while
investigating the remaining core/integration problem.

No tests or synthesis runs were added or executed during this commit-only
handoff. Existing regression sources and recorded execution evidence were saved.

## Configuration isolation

- `cva5_reuseio`: memory/branch filters disabled, generic xc7a200t synthesis.
- `cva5_reuseio_mem_branch`: separate experimental query/Toolkit YAML,
  constrained SCAIE-V allocation and compiler pattern support; generic target.
- `cva5_reuseio_arty_a7_100t`: original candidate policy, Arty A7-100 target.
- `cva5_reuseio_mem_branch_arty_a7_100t`: both opt-ins.

Only the CVA5 reuse-I/O query config had been modified during the recent work;
other existing query presets were unchanged. The standalone new
`fused-memory.yml` remains opt-in. Historical reports retain the configuration
names used at measurement time; the report index maps them to current presets.

## Local data not committed

Compiler installations/build trees, routed Vivado checkpoints, bulk traces,
Python caches, auxiliary `M2-ISA-R-new`/`llvm-project-22` clones, and scratch
`tmp` workspaces remain on disk. The selected evidence is listed with hashes in
`preserved-artifacts.json`; three passing bitstreams, firmware snapshots,
RTL archive, execution logs, reports and reproducers are included in Git.
Seal5 also has untracked local example dependency clones and ANTLR `.interp`/
`.tokens` metadata; its tracked implementation is fully committed.
Other registered submodules (`etiss`, `etiss_arch_riscv`, `isaac-docker-service`,
`llvm-project`, `mlonmcu`, `mgclient`) had no new source changes in this batch.
