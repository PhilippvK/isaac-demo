# Dynamic ISE utilization before/after fixed BB matching

## Result

**No utilization or performance difference was observed between the old and
corrected BB matching on CRC32 and SHA256.** Both arms generated the same ISE
sets. They produced identical executable `.text` bytes and byte-identical
instruction traces. All six baseline/old/new benchmark runs passed validation.

This is a negative result for an improvement in these workloads, and evidence
against an execution regression on these inputs. It is not a universal regression
clearance. The adversarial wrong-BB example in the earlier identity experiment
still demonstrates a correctness benefit; these two application searches do not
produce different instruction sets under the corrected matching.

### Benchmark-body utilization (old → corrected)

| Metric | CRC32 | SHA256 |
|---|---:|---:|
| Generated ISE definitions | 32 → 32 | 105 → 105 |
| Distinct ISEs used in benchmark body | 4 → 4 | 19 → 19 |
| Used / generated definitions | 12.50% → 12.50% | 18.10% → 18.10% |
| Dynamic custom-instruction executions in benchmark body | 696,320 → 696,320 | 1,161,375 → 1,161,375 |
| Distinct ISEs emitted anywhere in executable | 5 → 5 | 19 → 19 |
| Benchmark-body-used / emitted types | 80% → 80% | 100% → 100% |
| Reported run instructions / cycles | 2,960,964 → 2,960,964 | 2,217,885 → 2,217,885 |
| Run-instruction/cycle reduction against baseline | 26.08% → 26.08% | 41.27% → 41.27% |

Baseline run instructions/cycles are 4,005,445 for CRC32 and 3,776,360 for SHA256.
The reductions are benefits of the generated instruction sets in both arms;
**none of that reduction is an incremental benefit of the BB matching change**.

ETISS reports CPI 1 for this configuration, including custom instructions. These
are functional-simulator instruction/cycle reductions, not hardware speedups.
Host wall-clock simulation duration is not used as application runtime.

### Whole-program utilization

CRC32 additionally executes one generated ISE in instrumentation. Including
startup, setup, measurement and validation code, both arms use **5/32 types
(15.625%)** and execute **696,348** custom instructions. All five statically
emitted types execute somewhere: 100% type utilization among emitted ISEs.

SHA256 uses **19/105 types (18.095%)**, executing **1,161,375** custom instructions,
all within the benchmark body. All 19 emitted types execute.

At the static instruction-site level, whole-program traces execute 11/12 emitted
custom sites for CRC32 (91.67%) and 437/437 for SHA256 (100%), unchanged between
arms. This site count differs from the number of distinct generated ISE types.

The distinction matters: the extra CRC32 instrumentation match is not evidence
of extra workload utilization. Per-ISE counts, emitted instruction sites and
executed site coverage are retained in [results.json](results.json).

## Controls and measurement

The old and corrected sets come from the previous controlled experiment:
`reports/bb-quality-20261102/runs/{crc32,nettle-sha256}/.../work-{old,new}`.
The old arm used Toolkit HEAD's pre-fix decoder, profile annotation and query
orchestration. The corrected arm used the working tree. Both used the same
baseline ELF, trace, compiler and query backend. The common query backend
includes the syntax and endpoint fixes found during the earlier experiment.

Selection used stage 32, path length 1–3, width 2, limit 1000, 30-second query
timeout, identical semantic/encoding filters and automatic MaxMISO partitioning.
As documented in that experiment, **both discovery arms used explicit count
warning mode**. This does not waive identity/provenance verification in the new
arm, or change the production strict count default.

Encoded instruction definitions were checked for equality after ignoring generated
timestamp comments. Top-level simulator CoreDSL differs only in the paths of the
old/new imports; those imported definitions are identical. A single exact-set
compiler/simulator pair per benchmark is consequently used for both arms. This
avoids differences from independently rebuilding identical backend inputs.
The 34-ISE compiler-repair set was not used for these 32-ISE CRC32 measurements.

Each baseline, old and corrected arm was compiled and executed separately:

- RV32IMFD, ILP32D, O3, SelectionDAG, no unrolling, BB sections enabled.
- Baseline architecture disables XIsaac; both extended arms enable `_xisaac`.
- Same generated ETISS core and compiler for all three arms of each benchmark.
- ETISS native semihosting; no proxy kernel.
- Full instruction logging with the PrintInstruction plugin.
- Same MLonMCU environment and benchmark validation for all arms.
- A 60-second simulator timeout after diagnosing the failed initial run below.

`analyze.py` decodes the actual linked ELF with its matching retargeted
`llvm-objdump`. Each dynamic custom instruction is checked against the custom
instruction at that exact disassembled PC; unexpected custom PCs or mismatched
names fail analysis. Counts are not inferred from source-level profile weights.

The benchmark-body trace interval begins at the single `mlonmcu_run` entry and
ends at the next `stop_bench` entry. This excludes initialization and the timing
helper itself. It contains the return-to-caller bookkeeping before `stop_bench`;
it is a clearly defined trace scope, not an attempt to reconstruct the exact
counter-read interval. Both arms have exactly one start and one end.

Printed trace-entry totals differ from ETISS's aggregate simulated-instruction
counter by a few entries. Both quantities are retained separately. Utilization
counts use decoded trace entries; run-cycle/instruction reductions use the
benchmark's reported counter measurements.

## Regressions and failures recorded

- Validation is true for all six successful runs. Old and corrected arms match
  in benchmark instructions, cycles, dynamic counts by ISE, executable `.text`
  hashes and full trace hashes on both workloads.
- The initial attempt to execute a downloaded ETISS installation on the host
  failed because its helper embeds the container installation prefix and the
  host lacks the image's Boost 1.71 libraries. Simulation therefore runs inside
  the matching service container, with ELFs/configs copied in and traces copied
  back. No library or timing-model difference is introduced between arms.
- The first generated core omitted C support while the installed libc contains
  compressed instructions. That baseline entered a trap loop. Its trace reached
  45,509,412,584 bytes and exhausted disk space; the run was stopped and its
  oversized invalid trace removed after inspecting the start and tail. The tail
  repeatedly entered the trap handler. No data from that run enters the results.
- Both simulators were regenerated with C support for libc. Benchmark compiler
  flags remain RV32IMFD for all arms. The corrected baseline terminates normally
  and reproduces the prior baseline counters on each workload.
- Initial SHA256 submissions affected by the disk-full condition produced no
  usable jobs. Successful retry job IDs are recorded below. Logs from failed
  attempts remain alongside the successful measurements.

## Evidence and reproduction

Everything below is stored in this repository and survives `/tmp` cleanup:

- [results.csv](results.csv), [results.json](results.json): raw metrics, per-ISE
  counts, emitted/executed sites, code and trace hashes.
- `runs/{benchmark}/{baseline,old,new}/`: linked ELF, disassembly, reports,
  validation output, build commands and compressed full instruction traces.
- [analyze.py](analyze.py): trace/disassembly counting and old/new assertions.
- [run_crc32.sh](run_crc32.sh): runner; accepts `ARM [BENCHMARK]` despite its name.
- [docker_etiss.py](docker_etiss.py): simulator transport and timeout.
- [retarget.py](retarget.py): exact-set retargeting and selective tool recovery.
- [compress_traces.py](compress_traces.py): lossless trace retention.
- `llvm/`, `etiss/`, `nettle-sha256/{llvm,etiss}/`: selected compiler/simulator
  tools, generated model exports where available, job logs and compiler reports.
- [source-versions.json](source-versions.json): source revisions and fingerprints.

Successful jobs:

| Benchmark | Compiler | Simulator |
|---|---|---|
| CRC32 | `29be52d7-0369-4e9a-9d37-f7b4068a1280` | `eacb0c1a-a4cf-44ae-a6bd-e5d6d42fe417` |
| SHA256 | `0b93f315-4b92-4f20-bf43-fdbd2eda4112` | `f1f11e2a-fac2-4790-b04f-130ec68d6d8f` |

Source `scripts/env.sh`, then run `run_crc32.sh baseline`, `old`, `new`, optionally
adding `nettle-sha256`. The matching ETISS worker installation must still exist
at the recorded job prefix, or be rebuilt from the retained CoreDSL/model inputs.
Then compress traces with `compress_traces.py BENCHMARK ARM` and run `analyze.py`.
Source/build inputs must remain available to regenerate discovery receipts.
Completed compiler-job server duplicates were removed only after recovering the
selected tools, models and reports; service logs and repository evidence remain.
