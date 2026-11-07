# Compiler retargeting repair

## Cause

The worker installs Seal5 revision `168b81be68c752a96238c8f504b88346bc38a55c`
onto a prebuilt LLVM 19 stage-zero baseline. Its custom-immediate backend emits
assembler diagnostics and machine-operand verification code, but that baseline's
LLVM 19 marker patch lacks the two required insertion sites:

- `RISCVAsmParser.cpp`: `riscv_match_invalid_operands`
- `RISCVInstrInfo.cpp`: `riscv_verify_operands`

The CRC32 instruction set requires new immediate types and therefore exposes the
mismatch. The error occurs during patch injection, before compilation.

## Changes

- Added the missing sites to Seal5's LLVM 19 marker patch for new baselines.
- Updated the LLVM worker preparation to detect absent sites in an older LLVM 19
  baseline and register a normal, high-priority phase-one patch. It is recorded
  in Seal5's patch history before generated field-type code is injected. Each
  job still resets to the pristine image tag. Other LLVM versions with missing
  sites, incomplete marker pairs, and ambiguous source anchors fail explicitly.
- Corrected `scripts/flow_seal5.sh` to use the current service CLI flags
  `--tag llvm --output ...`.
- Installed the preparation change in the idle running LLVM worker using
  `docker cp`. The original script is retained as `prepare-before.py`. New image
  builds copy the updated preparation source through the existing Dockerfiles.
  The worker image was also rebuilt successfully with Docker Compose; future
  recreation using that updated image retains the fix. The active build was
  allowed to continue in its existing container.

## Checks completed

- Five preparation tests pass. Two old model fixtures were updated to use the
  typed-model interface consumed by the worker.
- The full updated LLVM 19 marker patch passes `git apply --check` against pinned
  LLVM revision `5bd6ab74cd1dc8d09e54ca6000361d020d138aeb`.
- Shell syntax and whitespace checks pass.
- CRC32 retry job: `8e282aff-1639-426d-a14b-6248cf0ec294`. Uses the original
  generated 34-instruction CoreDSL and empty user overrides, retaining the
  worker's pinned default configuration.

The retry passed the previously failing patch phase and reached LLVM compilation.

## Final result

The retry completed compiler construction, pattern generation, tests, installation,
and report generation successfully. The recovered compiler reports Clang 19.1.7,
LLVM commit `f8fcd61d1cd23a0ba4412cc6ab878a57ecfd1e4e` (including generated patches).
Its installation is in `crc32/llvm_install/` under this report directory.

- 34/34 instructions have `good` backend status in `status_compact.csv`.
- All 28 generated tests pass: 26 instruction code-generation tests and two
  set-level tests. Eight instructions have no individual code-generation test.
- The coverage report marks all instructions `bad` against its complete required
  test matrix: assembler/encoding/disassembly coverage is not complete. Passing
  the available compiler tests is not a claim of complete ISA validation.
- Five worker preparation regression tests and two artifact-delivery tests pass.
- The actual profiled `beebsc.c` and `crc_32.c` compile successfully with the
  recovered compiler, both with the baseline architecture and with `_xisaac`.
  Baseline assembly has no custom instructions. Extended assembly contains one
  `custom6` in beebsc and six custom occurrences across `custom17`, `custom19`,
  and `custom20` in crc_32: seven static occurrences, four distinct ISEs.
  See `compile-smoke.json`, `compile-smoke.log` and `compile_crc32.py`.
  These are static emissions; dynamic utilization, correctness under an extended
  simulator and cycle reduction remain separate measurements.

## Artifact delivery repair

After successful server completion, the client ran out of disk space extracting
the artifact. It first materialized a complete uncompressed tar in `/tmp`, then
extracted it, then copied the complete output tree to its final location.

The Toolkit now streams Zstandard directly into tar extraction and moves files
into their final location, merging existing directories and preserving symlinks
on retries. This also corrects the Python 3.14 branch, which attempted to open the
output directory as a file instead of unpacking the tar. Only the Python 3.10
legacy-Zstandard path was executed in this environment; Python 3.14 remains
untested here. The tests exercise nested archives, executable bits, symlinks,
retry extraction, output merging and the absence of a full temporary tar.

The already-downloaded archive was streamed successfully and its output recovered
without rebuilding. The client failure log is preserved in `crc32-client.log`;
the successful server log and CSV reports are under `crc32/`. The redundant
compressed download is removed after successful recovery, as on normal client
completion. The installed compiler, source archive, Seal5 export and reports are
retained.

The rebuilt worker image is
`sha256:ee32cb521e0e8759ca85a4900d0fa75175da4c4d84dee5978c8c1fd60480482c`.
Its build log is `worker-image-build.log`.


Subsequent dynamic old/new utilization measurements are in [the utilization comparison](../bb-utilization-20261103/report.md).
