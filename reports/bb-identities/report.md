# Basic block identity investigation

## Findings

**The numeric CDFG `bb_id` and ELF map ID use the same fixed LLVM `UniqueBBID.BaseID`, when enabled and when the block survives. The `%bb.N` spelling is a different, mutable identifier. Treating the spelling as the fixed ID can match the wrong blocks. Later machine passes also create and remove fixed IDs, so an early CDFG and a final ELF do not have identical block sets.**

This was reproduced with small RISC-V programs and checked against linked ELF maps. The saved CRC32/SHA256 CDFGs have matching numeric IDs and MIR spellings at their export stage, but those same compilations contain later block-set changes. Thus the concern is valid without implying every saved CDFG push was wrong.

## Identifier namespaces

| Identifier | Source | Meaning |
|---|---|---|
| `%bb.N` in CDFG `BB.name` / `INSTR.basic_block` | `MachineBasicBlock::printAsOperand` → `printName` → `getNumber()` | Mutable machine block number; layout/renumbering can change it |
| CDFG numeric `bb_id` | `MachineBasicBlock::getBBID()->BaseID` | Fixed ID assigned when the machine block is created, if BB map/section options enable it |
| ID in version-2 `.llvm_bb_addr_map` | AsmPrinter emits `getBBID()->BaseID` | Fixed ID of a final surviving block, emitted in layout order |
| Toolkit ELF `bb_name` | `analyze_llvm_bbs` formats the parsed ID as `%bb.<ID>` | Looks like MIR syntax but denotes the fixed ELF ID |
| Runtime trace `bb_idx` | Deduplication of `(first_pc,last_pc)` ranges in `trace_bbs.py` | Index of a runtime PC range, not an LLVM block identity |
| `func_bb_idx` | Per-function `cumcount()` in range analysis | Local dataframe numbering, not an LLVM ID |

The current C++ CDFG payload has `bb_id`, not `bb_idx`. LLVM IR block names are another namespace and exist before these machine IDs are allocated. `.llvm_bb_addr_map` is a dedicated ELF section, separate from DWARF; DWARF line-table basic-block flags are not these numeric IDs. Missing fixed IDs appear as `-1` in the existing exporter and as `none` in the new trace.

## Concrete reproducer

`cases.c` contains a conditional select, a loop with a call, and a switch. Compiled for RV32IM, GlobalISel, `-O2`, `-g`, and `-fbasic-block-sections=labels`. The rebuilt compiler reports these mappings for `choose`:

| Fixed ID | CDFG stage 32 MIR name | Later behavior | Final ELF ID / MIR number |
|---:|---|---|---|
| 0 | absent | Temporary GlobalISel entry block, deleted before stage 1 | absent |
| 1 | `%bb.1` | Survives and is renumbered | ID 1 / `%bb.0` |
| 2 | `%bb.3` | Removed by tail duplication | absent |
| 3 | `%bb.2` | Survives; empty at stage 32, later receives instructions | ID 3 / `%bb.1` |
| 4 | absent | Created during machine sinking | ID 4 / `%bb.2` |

At stage 32, `%bb.3` therefore has fixed ID 2. The toolkit ELF name `%bb.3` refers to fixed ID 3. A name-based join silently connects different blocks. Fixed ID 3 is already present at stage 32, but its early MIR name is `%bb.2`. Simply sorting or renumbering exported rows does not repair this.

The full machine-pass dumps also show PHI-elimination edge splitting, block movement during branch folding/placement, and renumbering during unreachable-block elimination and branch relaxation. New blocks get new fixed IDs; existing fixed IDs survive renumbering. Instructions can move between blocks or be duplicated, so matching the fixed identity still does not establish an unchanged instruction count or body.

## Compilation matrix

Eight fresh compiles with the rebuilt Clang cover GlobalISel and SelectionDAG at O0/O1/O2/O3, each with all three functions. The table counts function-scoped IDs; equal numbers in different functions are distinct. These are reproducer results, not an estimate of how often real applications are affected.

| Selector / optimization | Stage-32 blocks | MIR number differs from fixed ID | Fixed IDs lost by ELF | New fixed IDs in ELF |
|---|---:|---:|---:|---:|
| dag-O0 | 20 | 0 | 0 | 0 |
| dag-O1 | 17 | 2 | 2 | 3 |
| dag-O2 | 17 | 2 | 2 | 3 |
| dag-O3 | 17 | 2 | 3 | 3 |
| gisel-O0 | 20 | 0 | 0 | 0 |
| gisel-O1 | 17 | 2 | 1 | 3 |
| gisel-O2 | 17 | 2 | 1 | 3 |
| gisel-O3 | 17 | 2 | 3 | 3 |

Optimization and instruction selector change both ID assignment and subsequent transformations. GlobalISel initially allocates and deletes an extra entry block, so even otherwise similar DAG and GlobalISel compiles need not assign the same IDs. Recompilation with different flags, compiler revisions, source or target settings is not an identity-preserving operation.

## GlobalISel fallback

`fallback.c` includes vector and long-double operations. `extended_add` sets `FailedISel`: the failed GlobalISel blocks have fixed IDs 0 and 1, `ResetMachineFunction` clears them, and fallback selection creates MIR `%bb.0` with fixed ID 2. The final linked ELF contains ID 2. The counter is not reset with the MIR numbering. Earlier failed snapshots are diagnostic only: the existing exporter skips functions with `FailedISel`. The new trace records that flag and a distinct `event=reset reason=failed-isel`.

## Saved application replay

Original commands were recovered from saved `compile_commands.json.pkl` and replayed with the original installed Clang 19.0.0git revision `54c047b2f03e74e271f60f00a038a1baa4872a2f`. The vanished original build directories were replaced by the current workspace as cwd; source/include/toolchain paths are absolute, and outputs were redirected to this experiment directory. No fresh Memgraph push was made and shared DB state was not modified. Comparisons use the actual saved graph snapshots and saved ELF-derived tables.

| Application | Saved CDFG blocks compared | Disagreements with replayed stage-32 identities | Later changes visible against saved ELF |
|---|---:|---:|---|
| SHA256 | 54 | 0 | `benchmark_body` gains ID 4; `sha256_digest` loses IDs 3, 11, 17 |
| CRC32 | 34 | 0 | `benchmark_body` loses ID 6 and gains ID 7 |

The independent saved Genie CRC32 snapshot also had zero mismatched MIR-number/fixed-ID pairs among its 39 represented blocks; its build was not replayed here. Saved graph snapshots contain instruction-represented blocks, so these audits do not count empty BB nodes without any instructions. The agreement does not prove unchanged block contents, an identical final CFG, or explain every earlier BB instruction-count discrepancy.

## Stage masks are not chronological

The observed optimized GlobalISel order is **1 → 2 → 4 → 8 → 16 → 32 → 128 → 256 → 64**. These values follow the actual TargetPassConfig insertion points, not a numerical stage sequence. O0 and target-specific pipelines can omit visits.

| Mask | Snapshot point |
|---:|---|
| 1 | after IR translation |
| 2 | after legalization |
| 4 | after register-bank selection |
| 8 | after GlobalISel instruction selection |
| 16 | after fallback selection |
| 32 | after FinalizeISel / pseudo expansion |
| 128 | after machine sinking |
| 256 | after unreachable-block elimination and LiveVariables, before PHI elimination |
| 64 | after register allocation |

Later CDFG stages may have different register/SSA properties; moving export later requires checking the consumers, rather than assuming it fixes correspondence.

## A separate ELF decoder problem

Using `-mllvm -align-all-blocks=4`, LLVM successfully writes and `llvm-readobj` successfully decodes a linked ELF with `choose` block offsets 0, 0x10 and 0x20. The toolkit `parse_elf` raises `AssertionError` in `decode_map` at `sz >= 0`.

AsmPrinter emits a padding/start delta followed by **block size**. `llvm_bbs.py` treats the second field as an end offset and computes `size = second - start_delta`. This becomes wrong when padding is nonzero and can also shift the running cursor. The second field must be used directly as the block size. This is a size/range decoding issue separate from block identity. It was reproduced but not changed as part of the diagnostic investigation.

## Affected joins and recommended follow-up

1. Preserve numeric fixed `bb_id` separately from the MIR number/name. Join ELF IDs to CDFG `bb_id`, scoped by compilation/session, module, function and stage. Reject missing/negative IDs and ambiguity; account for clone IDs where applicable. Do not use textual `%bb.N` equality as proof of identity.
2. `annotate_bb_weights.py` currently compares ELF `bb_name` to CDFG `BB.name` and `INSTR.basic_block`. Both its preflight comparison and annotation writes can therefore be wrong for a reproducer such as `choose`. Change the identity key before interpreting count mismatches as corruption. The candidate query generator default BB predicate already uses numeric `bb_id`; not every consumer has this problem.
3. Keep explicit unmatched/later-created/removed categories. New final blocks have no earlier CDFG counterpart; dropped early blocks have no final ELF range. Do not assign either to the nearest number or a shifted list index.
4. Keep semantic/stage differences separate from identity checks. Splits, merges, sinking, tail duplication, register allocation and instruction expansion change contents even when a surviving fixed ID matches. A stable ID is not complete transformation lineage.
5. Repair the padded BB map size decoder independently, then assess instruction-count tolerances using valid ranges. If the same numeric IDs are expected across recompilations, record and verify source/compiler/target/flags fingerprints.

## Diagnostics implemented and validated

Added the opt-in assertions-build debug category `bbid-trace` in machine function/block lifecycle code, CDFG snapshots, GlobalISel fallback reset, and ELF address-map emission. Normal output is unchanged unless tracing is enabled. CDFG snapshots run without enabling export or connecting to Memgraph; `requested`, `selected`, and `failed_isel` make that distinction visible. Creation logs can have `mbb=-1` before insertion, and clear/delete logs after emission include function cleanup.

From the workspace, use the **rebuilt** compiler (the existing installed copy was not overwritten):

```sh
llvm-project/build/bin/clang --target=riscv32 -march=rv32im -mabi=ilp32 -O2 -g \
  -fbasic-block-sections=labels -fglobal-isel -mllvm -global-isel-abort=0 \
  -mllvm -debug-only=bbid-trace -mllvm -print-after-all \
  -c example.c -o example.o 2> example.bbid.log
```

The rebuilt compiler is clang version 19.1.7 (git@github.com:PhilippvK/llvm-project.git 5bd6ab74cd1dc8d09e54ca6000361d020d138aeb), with assertions enabled. `clang` and `llc` builds completed; all changed source files compiled successfully. `validate_trace.py` checked 422 normal lifecycle events, CDFG stage mappings/order, final emission IDs against linked ELF, the fallback reset and final ID, and safe `none` handling without BB-ID options. Traced and untraced object files were byte-identical. `git diff --check` passed. This investigation added diagnostics and documentation; it did not change matching rules, the ELF decoder, or BB optimization semantics.

## Evidence files

- `trace-validation.json`, `verified-trace.log`, `verified-trace-map.txt`, `verified-fallback.log`, `verified-fallback-map.txt`, `verified-no-ids.log` contain final rebuilt-compiler evidence.
- `matrix-audit.json`, `matrix-summary.txt`, `matrix-commands.json`, and `gisel-O*` / `dag-O*` files contain the eight fresh compiles and 24 function audits.
- `replay-audit.json`, `replay-commands.json`, and `replay-*.log` contain the saved application comparisons.
- `aligned-validation.json`, `aligned-parser.txt`, `aligned-map.txt` contain the padding decoder reproducer.
- `source_versions.json`, `build.log`, `build-incremental.log` identify source fingerprints, compiler and build evidence.
- Reusable scripts and fixtures: `cases.c`, `fallback.c`, `validate_trace.py`, `matrix.py`, `audit_matrix.py`, `replay_saved.py`, `audit_replays.py`, `make_report.py`.
- `passes.log`, `summary.txt`, `snapshots.json`, `traced-llc.*` are earlier exploratory evidence; the `verified-*` artifacts and matrix were refreshed with the final instrumented build.
