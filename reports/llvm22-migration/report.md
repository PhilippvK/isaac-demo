# Complexity assessment: ISAAC flow on LLVM 22

## Recommendation and effort

**Target LLVM 22.1.8 first. The scalar flow is a moderate port; reliably enabling
branch and memory discovery is a larger, separate integration task.** The new
Seal5 work removes substantial backend-generation work, but does not migrate the
ISAAC CDFG exporter or complete this repository's branch/memory frontend.

Planning estimate for one engineer familiar with this flow:

| Deliverable | Engineering effort | Main uncertainty |
|---|---:|---|
| LLVM 22 compiler + CDFG exporter and stage hooks | 3–5 days | Compilation/API and pipeline behavior |
| BB map decoding, identity/provenance and analysis | 1–2 days | Version-5 features and stage-to-final layout |
| Configs, pinned builds, services and scalar regression evidence | 2–4 days | Rebuild/debug iterations and existing workflow debt |
| Usable conditional-branch discovery/lowering | Additional 2–4 days | Branch targets, zero-result operations, displacement encoding |
| Restricted, semantically safe load/store discovery/lowering | Additional 4–8 days | Memory metadata, ordering, widths and safe fusion |
| Mixed branch/memory end-to-end stabilization | Additional 2–4 days | Real-workload correctness and utilization |

These are **estimates, not measured implementation times**. Plan about **1–2
weeks for a usable LLVM-22 scalar/CDFG flow**, and **roughly 3–5 weeks total** for
an initially restricted branch/memory-capable flow with meaningful regression
coverage. Parallelizable rows and shared integration work make simple addition
misleading. The upper tail grows if general atomics, volatile fusion, multi-output
writeback or a new codegen pass-manager implementation are included.

I recommend preserving a working LLVM 19 profile while adding a separately
pinned LLVM 22 profile. Do not switch the default, upgrade the GNU runtime,
change discovery stages and enable memory candidates simultaneously.

## Scope and evidence quality

This assessment uses the current worktree and downloaded LLVM 22.1.8 source,
not assumptions about an earlier checkout. This assessment did not change any
production compiler, simulator, configuration or database. No LLVM 22 build or end-to-end migration
was performed. Source merges are feasibility evidence, **not compile results**.

- Current custom LLVM: `5cf1dcaad9f8` on `isaac-llvm19.1.7`.
- Current Seal5: `f8b4ab8`, including the merged branch/memory work.
- Matching CoreDSL2LLVM `llvm-22.1.8` branch resolved to
  `8cb68410c9fd7de62845494d5b029e924e451921` and was read at that exact commit.
- Official LLVM source target: tag `llvmorg-22.1.8`.
- The initial source fetch downloaded 32 existing files and identified six
  paths absent upstream; custom CDFG files are expected to be absent.
- The direct CDFG include audit examined 41 paths. Generated `config.h` and the
  custom CDFG header are expected absences; `GISelKnownBits.h` is a real API move.

See [source-versions.json](source-versions.json),
[upstream-sources.json](upstream-sources.json),
[header-audit.json](header-audit.json), and
[patterngen-sources.json](patterngen-sources.json). Downloaded sources and merge
previews are retained here so `/tmp` cleanup cannot discard the assessment.

## What the recent Seal5 work actually provides

The local history includes the `updates-branch-mem` merge, LLVM-22 demo enablement
(`1592f24`), and automatic PatternGen backend import (`0b694d9`). The normalization
example now runs for LLVM 22 and 23. It contains selection/object/disassembly
fixtures for indexed/fused loads and stores, branch logic, and branch immediates.
The checked-in tests explicitly request GlobalISel and abort on fallback.
This is **available coverage**, not a claim that I ran it here.

The support is opt-in through `check_pattern_support.allow_memory` and
`allow_branches`, plus the relevant normalization passes. The example also raises
pattern selection priority. It is not an automatic enablement for all models.

Important limits documented in the example remain: multi-output operations,
postincrement/writeback and read-modify-write are excluded. LLVM 22 branch
fixtures use volatile effects because its RISC-V GlobalISel does not translate
the inline-assembly form used by some fixtures. Also, the example explicitly
says **gisel-table output patterns are not enabled**: supported GlobalISel
selection through generated/imported TableGen rules should not be confused
with enabling every PatternGen output mode.

Seal5 imports backend support from the matching CoreDSL2LLVM checkout. Four
RISC-V C++ files are replaced from that checkout: the instruction selector,
instruction info, late branch optimization and redundant-copy elimination.
The legalizer is retained with a narrow intrinsic case added; instruction
TableGen gains the branch-target operand. This import precedes insertion markers.

**Consequence:** use the matching branch and pin both repositories. Do not first
port custom edits into files that the subsequent import will overwrite. The
current CDFG hooks mostly live outside those replaced files, which helps.
Sources: local `seal5/seal5/tools/cdsl2llvm.py`,
`seal5/examples/normalization/README.md`, and the
[merged Seal5 change](https://github.com/tum-ei-eda/seal5/commit/49885385b98b0b0c3890b3112a1ec5b7d2b28e19).

## Compiler and CDFG port

### Size and three-way merge audit

The LLVM-19 custom delta against upstream 19.1.7 spans **23 files**, approximately
1,533 inserted and 62 deleted lines. The CDFG implementation itself is 914 lines.
The assessment ran per-file three-way merges: upstream 22.1.8 versus upstream
19.1.7 versus the current custom branch.

| Outcome | Files |
|---|---:|
| Clean textual merge | 10 |
| Conflicted | 6, with 9 conflict regions |
| Custom additions | 7, including documentation/notes |

Conflicted files:

1. `TargetPassConfig.cpp`: three regions, including changed ISel/fallback and
   machine-sinking placement.
2. `GIMatchTableExecutor.h`: new `LLVM_ABI` declaration versus the custom
   barrier-lookthrough argument; likely mechanical, but behavior needs coverage.
3. `MachineFunction.cpp`: renumbering diagnostics overlap newer implementation.
4. `RISCVRegisterBankInfo.cpp`: upstream now delegates most classes to the
   generated register-bank implementation; do not reinsert the old class list.
5. `SubtargetFeature.h`: upstream capacity changed from 5 to 6 words; the fork
   uses 10 for split extension sets. Determine required capacity from actual
   generated feature counts; six words is not automatically sufficient.
6. `InstCombineCasts.cpp`: the fork disables parts of cast optimization. This is
   an existing semantic/code-quality customization, not essential CDFG plumbing.
   Decide explicitly whether to retain it and compare results; do not silently
   drop it or copy old optimizer bodies onto LLVM 22.

Results and reproducible merge script:
[merge-audit.json](merge-audit.json), [merge_audit.py](merge_audit.py).
`merge-preview/` contains conflict-marked review material, not usable patches.

### Actual API and pipeline work

LLVM 22 still has `MachineFunctionPass` and the RISC-V legacy
`createPassConfig`/`TargetPassConfig` pipeline used here. A full rewrite to the
new codegen pass manager is not a prerequisite for the first migration.

The fixed `UniqueBBID` / `getBBID()` mechanism still exists. Most APIs used for
register definitions, LLTs, register printing and size queries are present.
However, `GISelKnownBits.h` became `GISelValueTracking.h`, with the legacy analysis
registration renamed to `GISelValueTrackingAnalysisLegacy`. In the current CDFG
pass that analysis is not queried: it appears in an include, registration macro
and commented-out requirements. Removing the unused dependency is preferable to
inventing a new analysis requirement solely to make it compile.

Re-establish all nine stage boundaries by meaning, not by copying surrounding
text or interpreting numeric bits as chronological order:

| Stage bit | Intended boundary |
|---:|---|
| 1 | After IR translation |
| 2 | After legalization |
| 4 | After register-bank selection |
| 8 | After GlobalISel instruction selection |
| 16 | After SelectionDAG/fallback selection |
| 32 | After FinalizeISel |
| 128 | After machine sinking |
| 256 | Before virtual-register rewriting, using the existing intended hook |
| 64 | After register allocation |

The current bit-256 hook actually precedes additional allocation preparation;
its precise semantic label should be audited, not assumed to mean immediately
before `VirtRegRewriter`. Optimized/unoptimized paths and GlobalISel failure/reset
need separate checks. Stage 32 is the lowest-disruption initial discovery target.

Retain the mgclient build option and include/link wiring. Review LLVM 22 symbol
visibility if a shared LLVM build is enabled; the current static-library build
shape avoids making that a prerequisite. The exporter should preserve analyses
and return `false` when it only observes the function; its current `true` returns
are technical debt worth fixing while doing the port.

The constant-fold-barrier matcher customization also deserves a dedicated review:
only instruction selection may look through the barrier; combiners must retain
its optimization semantics. PatternGen's branch already handles barriers during
extraction. A clean textual merge elsewhere is not evidence this interaction is
correct.

## BB analysis: a definite compatibility break

**LLVM 22.1.8 defaults to BB address-map version 5. The current Toolkit decoder
accepts only version 2 and feature mask zero. It will reject ordinary LLVM-22
output before the new graph identity checks can help.** The version-5 feature
field is **two bytes**, not one. Merely accepting the new version number would
misalign all subsequent reads.
Sources: [MCContext.h](https://github.com/llvm/llvm-project/blob/llvmorg-22.1.8/llvm/include/llvm/MC/MCContext.h),
[AsmPrinter.cpp](https://github.com/llvm/llvm-project/blob/llvmorg-22.1.8/llvm/lib/CodeGen/AsmPrinter/AsmPrinter.cpp),
[LLVM ELF decoder](https://github.com/llvm/llvm-project/blob/llvmorg-22.1.8/llvm/lib/Object/ELF.cpp).

Required work:

- Dispatch by map version; decode the v5 two-byte feature mask.
- Handle or explicitly reject each supported feature before consuming entries.
  Callsite offsets, introduced in v3, affect block-size interpretation: sum
  callsite deltas and the final remainder. Optional v4 hashes add eight bytes.
  Multi-range sections, omitted entries and PGO/post-link payloads need separate
  handling or clear rejection.
- Keep the corrected previous-end-relative alignment delta and the fixed base
  ID. Validate ranges against LLVM's own decoded map and the linked executable.
- Continue rejecting unsupported clone identities and ambiguous graph matches;
  numeric MIR names must never become the identity again.
- Preserve single-function/source/compilation/stage scoping and input receipts.
  Rebuild/reanalyze/reimport sessions for LLVM 22; do not relabel old receipts.
- `bb_map_decoder=2` currently denotes the Toolkit's decoder/provenance revision,
  not the ELF map's version. Do not set it to 5 and accidentally break every
  guard. Either preserve that internal contract while adding explicit ELF format
  metadata, or deliberately revise it in analysis, mapping, choices and guards.

There is also a useful simplification: in upstream LLVM 22,
`-fbasic-block-sections=labels` is a deprecated alias for
`-fbasic-block-address-map`. The new flag works independently of the old
non-x86 driver workaround. Use it for the LLVM-22 profile and **do not port the
old Clang driver bypass blindly**. Source: [Clang driver](https://github.com/llvm/llvm-project/blob/llvmorg-22.1.8/clang/lib/Driver/ToolChains/Clang.cpp).
The new BB creation condition is `Target.Options.BBAddrMap`; the fixed ID design
is therefore reusable. DWARF and symbol analysis still need regression checks,
but no comparable hard version gate was found there in this inspection.

## Why branch/memory enablement costs more than changing LLVM

The compiler backend is only one end of the flow. Current repository evidence:

- `cfg/isaac/query/paper/iss_only.yml` has loads, stores and total memory capped
  at zero. Changing LLVM will not create any memory candidates with that config.
- Active `tool/gen/cdsl.py` uses `CDSLEmitter` from `cdsl_utils.py`.
  Its BEQ/BNE emitter still writes a literal `TODO` branch offset.
- The generic-load emitter writes unresolved memory width/address placeholders
  (`unsigned<?>`, `?`). Generic store lowering is absent from its dispatch.
- Native memory lowering is limited to LH/LW and SH/SW; branch dispatch is
  limited to BEQ/BNE. This is not coverage of all new LLVM-22 selected forms.
- The CDFG exporter includes `MachineMemOperand.h` but exports register-use DFG
  edges and coarse `mayLoad`/`mayStore` flags, not memory-access metadata and a
  demonstrated memory-order/alias dependence model.

Before admitting memory fusion, export access width, extension behavior,
alignment/address space, volatility, atomic ordering and the information needed
to reject unsafe motion. Preserve dependence on intervening stores/calls/fences;
a register-only connected subgraph is not sufficient proof of safe fusion.
Use the backend's safe-fold checks as a second gate, not a replacement for a
correct candidate model or accurate generated semantics.

For branches, preserve the destination as a control operand, condition signedness
and B-format immediate constraints. Validate taken/not-taken paths, fallthrough,
loops, backward jumps, range limits and relocations after fusion changes code
layout. Review zero-register-result stores/branches against global output and
operand filters rather than requiring every ISE to be an arithmetic expression.

Start with a deliberately documented subset: ordinary scalar nonvolatile,
nonatomic loads/stores, no writeback/multi-output/RMW, and recognized conditional
branches. This reflects the backend's current limits; it is not a claim that
arbitrary memory/branch fusion becomes safe with LLVM 22.

## Build/service and runtime changes

The active service source still pins Seal5 `168b81b`, before the new support.
Local Seal5 being newer does not update the running compiler worker. Its LLVM
Dockerfiles also assert ancestry from the LLVM-19 fork commit. A stock LLVM-22
image cannot satisfy that ancestry check.

Versioned updates must cover:

- `cfg/seal5/llvm.yml`: LLVM version and regression-test build configuration.
- `cfg/seal5/tools.yml`: stop forcing PatternGen `llvm-19.1.0`; select/pin the
  matching `llvm-22.1.8` branch.
- `cfg/seal5/patches.yml`: LLVM-22 insertion markers and stage-zero ordering.
- `scripts/flow_seal5.sh` and `docker/seal5_script_local.sh`: remove hard-coded
  LLVM-19 refs from the LLVM-22 profile.
- `docker/Dockerfile_seal5` image base/source revision, worker Seal5 pin and
  pristine stage-zero snapshot. The current base-image recipe pins the LLVM-19
  fork at `5cf1dcaad9f8`; changing only its branch argument is insufficient.
- `prepare.py`'s LLVM-19 supplemental-marker path: do not apply it to LLVM 22.
  The LLVM-22 marker patch already contains the required operand sites.
- Discovery and retargeted compiler profiles must share the CDFG implementation,
  stage conventions and schema; rebuilding only the service compiler is not a
  complete migration.

ETISS does not inherently require a version port for LLVM 22: it consumes the
linked ELF and generated instruction semantics. Revalidate its ISA coverage,
semihosting, compressed instructions in runtime libraries and custom-op decoding.
The recent utilization experiment already exposed missing simulator C support;
keep that fix in the migration baseline. Keep the current GNU sysroot/ABI first,
and change it only if an independently demonstrated requirement appears.

## Proposed implementation order and acceptance evidence

1. **Pin a new LLVM-22 profile.** Freeze LLVM, Seal5, CoreDSL2LLVM and M2-ISA-R
   revisions. Preserve the 19 profile and its measured outputs.
2. **Port/build the observer and required compiler customizations.** Review the
   six conflicts manually, drop obsolete driver/register-bank workarounds only
   with evidence, retain fixed-ID guards and deliberately handle optimizer hacks.
3. **Repair BB decoding and stage verification before graph queries.** Cover
   padding, calls, multi-functions, new/deleted/clone IDs, failed GlobalISel and
   late block transformations. Compare with `llvm-readobj` and trace PC ranges.
4. **Scalar end-to-end gate.** Repeat CRC32 and SHA256 baseline/discovery/query/
   retarget/simulation with both DAG and GlobalISel paths as applicable. Check
   validation, stale-input rejection, candidate/emitted/used ISE counts and
   dynamic traces. New optimizer versions need not reproduce identical counts;
   explain changes and forbid wrong-block joins or incorrect results.
5. **Reuse the existing LLVM-22 normalization fixtures.** Require actual
   GlobalISel selection, native fallback with extensions disabled, object
   emission and disassembly, plus the normalization checker. Do not substitute
   a successful compiler build for branch/memory support.
6. **Complete ISAAC branch/memory generation and legality.** Add schema and
   lowering changes, then enable opt-in query profiles. Cover load extensions,
   truncating stores, address/data fusion, shared loads, aliasing barriers,
   branch bounds and displacement ordering.
7. **Mixed end-to-end gate.** Validate results under the generated simulator;
   measure static emission and dynamic use separately, exclude instrumentation
   matches from benchmark-body utilization, and report the cycle model. Broaden
   the benchmark corpus before switching the default profile.

Existing strict ELF/CDFG instruction-count checking already rejects some blocks
in both prior workloads. LLVM 22 may change those counts further. Address this
as a documented validation-model issue, not by making identity checks optional
or silently increasing tolerances until runs pass.

## Assessment limits

The source audit identifies concrete breaks and bounds the work. It does not
prove the CDFG pass compiles on LLVM 22, that the new fixtures pass in this
workspace, or that candidate quality improves. A complete migration would require
the acceptance evidence above. The requested **complexity evaluation** is
complete without presenting these future gates as completed implementation work.
