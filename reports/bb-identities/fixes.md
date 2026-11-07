# Decoder and BB mapping changes following the investigation

The investigation in [report.md](report.md) describes the old behavior. The
implementation now contains the following fixes.

## ELF decoding

Version-2 BB map entries contain padding relative to the previous block end,
then a **size**. The decoder now uses that size directly and advances the cursor
past both padding and code. It rejects duplicate block/function identities,
truncated or oversized ULEB128 fields, out-of-text ranges and unrelocated ELF
objects. Unsupported map versions/features and undecodable instructions fail
explicitly rather than producing plausible but untrustworthy counts.

`llvm_bbs` records a numeric fixed `bb_id`, ELF SHA-256 and decoder version.
That provenance propagates through `llvm_bbs_new` and `choices`; old tables must
be regenerated so stale padded ranges are not reused.

## Import and lookup

- Numeric fixed IDs are used for matching and weighting. MIR labels are kept
  separately for diagnostics; `%bb.N` text is not used as evidence of identity.
- An import is compiled into a private UUID namespace, validated, then published
  transactionally for its exact public label/module/stages. A failed compile
  cannot partially merge into an older public graph.
- A `cdfg_imports` session artifact records the ELF, direct compiler binary,
  command/directory, source/header dependency hashes, graph identity and semantic
  node fields/edges, and a unique `compilation_id`. Readers reject missing or
  changed receipts/inputs/graphs. Profiling and MaxMISO annotation fields are
  intentionally excluded from the graph signature.
- BB lookup requires exactly one matching fixed ID in the specified module,
  function, stage and compilation. Queries constrain both endpoints and every
  DFS expansion; isolated instructions are retained. Invalid, duplicate or
  absent identities stop the operation rather than selecting a nearby number.
- LLVM exports identity-schema and clone metadata and refuses missing fixed IDs
  and nonzero clone IDs. The ELF base-ID format cannot distinguish such clones.
- Weight writes and partition writes use the same scope as lookup. Output indices
  retain fixed ID, MIR name, module and import identity as separate fields.

These checks establish identity and provenance, not a proof that a block's
instruction sequence survives all later machine passes unchanged. Later-created
or removed blocks still need explicit handling; the existing count validation
remains active. An ELF imported without original build provenance is still
trusted as the initial input: no scheme can reconstruct which source/compiler
produced an arbitrary old binary solely from its block numbers.

## Updating an existing workspace/session

1. The updated LLVM compiler has been built and installed locally at
   `install/llvm/bin/clang` (also available in `llvm-project/build/bin`). The
   previous executable is backed up as
   `install/llvm/bin/clang-19.before-bb-identity-fix`. Rebuild the workload with
   the updated compiler; retain the correct compile commands for the ELF.
   CDFG replay requires a direct compiler command, without a ccache/env wrapper.
2. Re-run the original static BB analysis, trace-to-BB mapping and BB selection
   commands with `--force`, retaining the workload's original options.
3. Regenerate the CDFG for the desired label/stage. The receipt is saved with the
   session. If multiple stages were imported, select one explicitly for weights.
4. Annotate/query using that same label and stage. If sources, headers, compiler,
   ELF or commands change, rebuild/reanalyse/reimport rather than reusing it.

Original compile outputs are not overwritten by CDFG replay. Standard Clang
compile commands and Make-format dependency files are supported. Import now
requires a working source/build directory and readable dependencies for receipts.
Lookup also requires the recorded compiler and dependencies to remain readable,
so their fingerprints can be checked; unavailable inputs cause an explicit error.

## Review status

The LLVM `clang` and `llc` targets rebuilt successfully; see
[fix-build.log](fix-build.log) and [fix-install.log](fix-install.log). Python syntax and whitespace checks were run.
No new test suite or live database end-to-end run was executed for these fixes.
Historical experiment results remain in this directory and the sibling report
directories; all compiler logs are under `logs/` as gzip files.

Subsequent live verification is recorded in [the quality experiment](../bb-quality-20261102/report.md), including known strict-count and compiler-retargeting failures.
