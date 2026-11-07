# Fused branch ISE verification — LLVM 22 / RV32

## Result

**Passed after fixing three integration bugs.** All six generated branch ISEs
are selected by SelectionDAG and execute correctly in the controlled RV32 tests.
The fixed generator also reproduces the working compiler from the common stage0
without manual edits to generated LLVM files. GlobalISel remains excluded.

| Check | Result |
|---|---|
| Operand/tree/CoreDSL generation and B-format allocation | All six comparisons on RV32 and RV64 |
| Automatic selection from C | Fused branches in all six compiled C functions |
| Compiler-relaxed long branches | All six functions compile, verify and execute |
| Differential execution | **15,834/15,834 cases pass**, 42 functions |
| Actual custom executions | **13,572**, 2,262 for each of six ISE types |
| Taken and fall-through coverage | Both outcomes at all 36 fused instruction sites |
| Assembler immediate validation | 54 checks pass, including odd/out-of-range rejection |
| External out-of-range relocation | Linker rejects it |
| GlobalISel control | Compiles successfully; selects no fused branches; generated GI table has no branch-ISE names |
| Focused regression suite | **105 tests and 10 subtests pass** |
| Clean retargeting reproduction | Build/export succeeds; both generated feature tests pass |

The six conditions are BEQ, BNE, BLT, BGE, BLTU and BGEU. Each tested ISE fuses
`(rs1 & rs2)` with comparison against 7. There are no output registers. The
register-selector fields and signed 13-bit byte displacement are allocated by
the real shared encoder, rather than hand-assigned to the test instructions.

## What executed

For each condition, the harness checks seven implementations against an
independent C reference:

1. A normal C function compiled with XBranch enabled; disassembly must contain
   a fused branch and omit the separate AND instruction.
2. The same C source compiled with XBranch disabled.
3. An LLVM IR function containing 1,100 retained NOPs in a fall-through block,
   forcing the compiler to relax a branch crossing more than 4 KiB. The resulting
   fused branch targets a nearby trampoline; the trampoline jumps to the far BB.
4. Explicit assembly with a forward target.
5. Explicit assembly with a backward target.
6. Explicit assembly at displacement **+4094**.
7. Explicit assembly at displacement **−4096**.

Each implementation runs 121 combinations of 11 edge values (including zero,
7, the signed minimum/maximum, and all ones), plus 256 deterministic random
pairs: 377 cases × 42 functions = 15,834 checks. Signed and unsigned comparisons
are checked separately. The harness prints `BRANCH TEST PASS` only after all
return values match, then exits through ETISS native semihosting (SYS_EXIT).
No proxy kernel or host-side semantic emulator is involved.

The instruction trace independently confirms all 42 function entry counts,
checks each custom opcode against the linked ELF at the exact PC, and checks
its next PC against the encoded target or fall-through address. Every custom
site executes 377 times and takes both paths. The final trace contains
1,924,355 instructions; its SHA256 and per-site coverage are in
`runtime-results.json`. The rerun with the clean reproduced compiler has the
same trace hash as the repaired first build.

## Bugs found and fixed

- **Model writing crashed on the lowered branch intrinsic.** M2-ISA-R's scalar
  staticness visitor assumed every call referenced a function object with
  attributes. Unresolved intrinsic names now conservatively remain dynamic.
  Regression tests cover unresolved calls and preservation of named static calls.
- **The GlobalISel-ignore flag was scoped too broadly.** Applying it to an entire
  generated file also affected instruction/helper records lacking that field.
  It now applies only to Pattern records.
- **The first TableGen rules never selected from C.** They matched generic
  `brcond`/`setcc` trees, but RISC-V custom-lowers these before DAG selection.
  Branch patterns now match `riscv_brcc`, preserving predicate and destination,
  including operand swapping for greater-than and less-or-equal conditions.
  The rules retain `GISelShouldIgnore = 1`. No branch GI rules are generated.

The first ETISS test setup omitted its required `--fill-mode=auto`; its default
empty implementation had no RISC-V instruction-length decoder and failed before
running the program. The final core uses auto-fill, matching the production
local runner. Diagnostic source instrumentation was removed by regenerating the
core before the successful runs. The harness uses SYS_EXIT because this ETISS
revision does not implement SYS_EXIT_EXTENDED. These setup failures contribute
no passing data to the result.

## Evidence and reproduction

All artifacts live in this repository and survive `/tmp` cleanup:

- `generate_fixtures.py`, `generation-results.json`, `generated-rv{32,64}/`:
  controlled candidate graphs, real generator output and encoding manifests.
- `retarget.sh`, `reproduce_compiler.py`, `reproduce-retarget.log`:
  normal local retargeting with the optional fused-branch configuration.
- `compiler/seal5.tar.gz`, `compiler/seal5_reports/`: corrected generated model,
  patch/test exports and build reports. `export-check.json` confirms that the
  archive includes the corrected `riscv_brcc` patterns, not the broken first rules.
- `compiler/llvm_install/`: independently retained compiler, linker and inspection
  tools. `compiler/RISCVGenGlobalISel.inc`: the corresponding GI table.
- `check_codegen.py`, `selected.c`, `selected.ll`, `gisel.s`, `far.{ll,s,o}`:
  automatic-selection, GI-exclusion and long-branch controls.
- `make_runtime.py`, `build_runtime.sh`, `harness.c`, `branches.S`,
  `branch-tests.{elf,dump}`, `runtime-final.log`, `runtime-results.json`,
  `instr_trace.csv.gz`, `analyze_trace.py`: execution proof and trace analysis.
- `check_assembler.py`, `assembler-results.json`: range/alignment and relocation
  controls. B-format unit tests also round-trip all 4,096 even displacements.
- `etiss/`: exact CoreDSL, generated architecture, local source clone, build,
  installation, configuration and logs. `container.json` pins the runtime image
  and mount. `source-versions.json` records source/binary/artifact fingerprints.
- `regression-tests.log`: branch, allocator, scalar compiler helpers, query,
  BB decoder and BB identity checks.

From the repository root with the retained branch compiler:

```bash
source scripts/env.sh
python reports/fused-branches-20261104/generate_fixtures.py
python reports/fused-branches-20261104/check_assembler.py
python reports/fused-branches-20261104/check_codegen.py
bash reports/fused-branches-20261104/build_runtime.sh
```

The exact simulator command uses the dedicated ETISS image with this report
directory mounted at `/experiment` (see `container.json`):

```bash
docker exec -w /experiment isaac-fused-branches-etiss timeout 30s \
  /experiment/etiss/install/bin/run_helper.sh /experiment/branch-tests.elf \
  nodmi -p PrintInstruction -i/experiment/etiss/runtime.ini
python reports/fused-branches-20261104/analyze_trace.py
```

Start the retained stopped container before rerunning. Its compiled helper embeds
`/experiment/etiss/install`, so retain that mount. Retargeting reproduction uses
a disposable LLVM22 checkout at the recorded common stage0; the preparatory
scripts are one-shot scripts that preserve prior state before switching branches.
The earlier scalar compilers remain separately retained in the LLVM-version
experiment. The shared `llvm-project-22/build` now holds the branch compiler.

## Limits

Execution correctness is verified on RV32 / LLVM22.1.8 with the SelectionDAG
selector. RV64 checks cover generation, parsing and encoding only. These are
controlled graph fixtures, not a new live database discovery run or performance
measurement on an application. Other fused arithmetic expressions, memory
branches, register-result branches, additional immediate variants and other LLVM
versions are outside this execution test. The two autogenerated Seal5 tests
cover extension/attribute handling; the separate differential suite supplies
branch semantic coverage. No hardware timing claim is made.
