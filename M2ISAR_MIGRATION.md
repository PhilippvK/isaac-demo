# Typed M2-ISA-R and default auto-fill

ISAAC Toolkit now uses `M2-ISA-R` and the shared
`m2isar.backends.coredsl2.writer` implementation. The old
`m2isar.backends.coredsl2_set.writer` module remains a compatibility adapter.

## Active behavior

The submodule tracks `coredsl2` from `https://github.com/tum-ei-eda/M2-ISA-R.git`.

- `scripts/env.sh` selects `M2-ISA-R` by default. An explicit `M2ISAR_DIR`
  still overrides that selection. Both Python setup scripts install this checkout.
- Toolkit's normal `generate_etiss_core` entry point uses the encoding planner.
  The former `generate_etiss_core_planner` entry point delegates to it.
- Candidates are parsed with the selected XLEN and typed operand attributes.
  All custom sets share one encoding allocation domain. CFU retains its fixed
  encoding contract and persistent manifest.
- The generator writes combined, split, encoded-candidate, and legacy HLS
  artifacts through the shared writer. It resolves the generated core with the
  typed parser and stores that complete model, including its actual widths.
  A core without C has no artificial 16-bit instruction class.
- Normal and performance retargeting use `fill_mode="auto"` by default, for both
  local scripts and Docker. Their direct CLIs accept `--fill-mode empty` as an
  explicit opt-out. Direct shell invocations honor `ISAAC_M2ISAR_FILL_MODE=empty`.
- Auto-fill preserves the generated architecture implementation and header,
  length updater, JIT settings and decoder widths. The RV32IMACFD implementation
  is copied only in explicitly selected empty mode.
- The local performance script uses the selected host `python3` and typed
  checkout for parsing/writing, independently of the performance workspace's
  legacy wrapper environment.

## Installation and Docker

The workspace venv has been updated with:

```sh
venv/bin/python3 -m pip install --no-deps --no-build-isolation -e ./M2-ISA-R
```

Fresh setup uses `scripts/setup_python.sh` or `scripts/setup_python_docker.sh`,
which install dependencies normally. The typed package explicitly discovers
only `m2isar*` packages, so auxiliary `ext` and `integrations` directories do not
break editable or wheel installation.

ETISS and demo Docker recipes copy and install the upstream `M2-ISA-R` submodule. Existing Docker images must be rebuilt to pick up these changes.
They have not been rebuilt or published by this update.

Seal5 uses the `M2-ISA-R` submodule in its local subprocess; its separate
Docker environment is preserved.
Legacy model pickles must be regenerated through the typed parser.

## Verification

The M2-ISA-R suite covers both modern and compatibility imports, shared default
and split writers, typed parser roundtrips, planner allocation and operand
metadata. Toolkit tests cover CFU artifact consistency and manifest reuse,
multiple custom sets, RV32/RV64, compressed-width selection, and propagation of
both auto/empty modes to local and Docker backends.

A real Toolkit candidate-index run in `/tmp/isaac-typed-integration` generated
`TypedSmoke`, including CSR/trap support and a custom register-add instruction.
ETISS generation with `--fill-mode=auto` succeeded. All generated C/C++ sources
compiled and linked against the installed ETISS into
`/tmp/isaac-typed-integration/build/libTypedSmoke.so`. This checks generation and
compilation, not simulator execution or performance-simulation execution.

Verification results after resuming the interrupted validation: **32 typed
M2-ISA-R tests passed**, **51 Toolkit tests passed**, **2 legacy M2-ISA-R tests
passed**, and **1 Seal5 frontend test passed**. Two optional Toolkit tests are
skipped because their external tool dependency is unavailable. Editable
installation and wheel packaging were also checked in the earlier session.

## End-to-end replay (2026-10-23)

The saved CRC32 experiment at `out/embench_iot/crc32/20261021T203031` was
replayed in `/tmp/isaac-e2e-typed`, preserving the original experiment. Its
three selected candidates were regenerated through Toolkit's default typed
generator and the production local ETISS retarget script with default auto-fill.
The retargeted ETISS compiled and installed successfully. The saved compiled
CRC32 executable then ran on that simulator using both TCCJIT and GCCJIT:
both reported `MLONMCU EXIT: 0`, **3,483,205 run instructions**, and
**3,483,518 total instructions**, matching the original experiment.

The updated `etiss_arch_riscv` and nested ISA definitions supply the explicit
memory-access widths required by the typed backend. No backend memory-width
workaround is retained. The custom-add smoke program also executed successfully
under both JITs in the earlier session.

The replay uncovered and fixed nested-cast parentheses in the shared writer.
Empty function/instruction blocks are omitted. The legacy M2-ISA-R set parser
now accepts an inherited-only set, and Seal5's own frontend accepts those sets
and optional typed operand declarations. ANTLR parsers were regenerated with
4.13.1. Seal5 obtains operand fields from the explicit encodings; typed operand
metadata remains available to the typed M2-ISA-R pipeline.

Combined, split and HLS CoreDSL artifacts pass the legacy parser and Seal5's
actual compiler frontend. The split model preserves all three custom instruction
sets and their aggregate references. `scripts/verify_cfu_artifacts.py` verifies
all three fixed CFU encodings across compiler and ISS artifacts against the
persisted manifest. Focused regressions cover inherited-only sets and Seal5
input with typed operands. Shell syntax and whitespace checks pass.

Replay logs and models are in `/tmp/isaac-e2e-typed`, including
`crc32-run-tcc/runtime-verified.log`, `crc32-run-gcc/runtime.log`,
`validation-summary.json`, `artifact-check-resumed.log`,
`legacy-consumer-resumed.log`, `seal5-*-parse.log`, and `seal5-models/`.
This replay reuses the saved compiler executable output: it does not rebuild
the full LLVM compiler, synthesize HLS/RTL, or rebuild Docker images.
