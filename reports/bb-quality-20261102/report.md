# BB decoder and mapping quality experiment

## Conclusion

The fixes improve correctness in the cases that exercise the original bugs. They
have **not demonstrated a runtime speedup or increased executed-ISE utilization**.
On fresh CRC32 and SHA256 profiles, the controlled comparison produces identical
generated instruction semantics and profile metrics. No candidate-generation
regression was observed in those two bounded searches.

End-to-end runtime regression clearance is **incomplete**: strict count checking
stops both workloads, and the local compiler-retargeting service fails before
producing an extended compiler. These failures are retained, not counted as passes.

## Controlled comparison

Both arms use the same freshly built ELF, ETISS trace, CDFG database, compiler and
current `memgraph_experiments` backend. The old arm executes Toolkit decoder,
annotation and query orchestration from the recorded Git HEAD; the new arm uses
the working tree. The legacy subprocess receives an endpoint-only override so
it queries the isolated database. The common backend includes the Memgraph syntax
fix discovered during this experiment. This isolates the BB changes from a
compiler-version migration and from changes in query filtering or export logic.

Settings: RV32IMFD/ILP32D, O3, SelectionDAG, no loop unrolling, CDFG stage 32,
path length 1–3, width 2, at most 1000 traversal-order results, 30-second query
timeout, identical predicate/encoding filters, automatic MaxMISO partitioning.
Both arms explicitly use count-warning mode. The production strict default is
unchanged. These are bounded searches, not an exhaustive exploration of all ISEs.

| Measurement | CRC32 old → new | SHA256 old → new |
|---|---:|---:|
| Selected/generated CoreDSL definitions | 32 → 32 | 105 → 105 |
| Definition semantic multiset | identical | identical |
| Instruction count, frequency, Weight, IsoWeight and iso metrics | identical | identical |
| Definitions with positive source-profile frequency | 32 → 32 | 105 → 105 |
| Reported source-pattern frequency per definition | 174080 → 174080 | 2850 → 2850 |
| Discovery wall time, single observation | 15.20 → 16.08 s | 53.11 → 55.12 s |

CoreDSL comparison ignores the generated timestamp comment and normalizes custom
instruction names before hashing. Matching includes multiplicities. Frequency
metrics are compared per semantic hash. See [output-comparison.json](output-comparison.json).
The initial raw comparison failed solely because timestamp comments differ;
[output-comparison-normalized.log](output-comparison-normalized.log) records the
corrected comparison. There is no inference of a discovery-speed regression from
one ordered observation; export worker settings differ and these timings include
export/browser startup and verification.

**Positive source frequency is an opportunity indicator, not an executed custom
instruction count.** CoreDSL definitions are not evidence that a retargeted
compiler emitted their opcodes, or that a simulator executed them. Overlapping
candidate weights/frequencies must not be summed into predicted speedup.

The separate initial CRC32 search at path length 9 generated 34 definitions. It
is retained under `work/` but is not compared to the length-3 arms.

## Correctness and regression checks

- The decoder was compared with `llvm-readobj --bb-addr-map` on 16 linked ELFs:
  eight DAG/GlobalISel × O0/O1/O2/O3 fixtures, one aligned fixture, five saved
  benchmark ELFs and two fresh benchmark ELFs. The corrected decoder matches all
  ranges. The old decoder fails on the aligned fixture. On the other 15 ELFs the
  ranges agree. See [decoder-results.json](decoder-results.json). This validates
  ranges and sizes; the oracle does not independently validate every disassembly
  instruction count.
- A live GlobalISel fixture requests fixed BB 3. The new lookup returns MIR
  `%bb.2` with fixed ID 3. The legacy name join returns MIR `%bb.3` with fixed ID
  2: a concrete wrong-block lookup. Fixed BB 1 remains correct in both arms.
- Live negative checks pass for changed source, changed session ELF, wrong
  compilation ID, duplicate BB, modified graph receipt and a late-created block
  unavailable at stage 32. See [identity-results.json](identity-results.json).
  The first ELF-mutation test targeted the original input rather than the session
  copy; its failed test-harness result is retained in `identity.log`. The corrected
  test mutates the actual session artifact and passes in `identity-v2.log`.
- 37 focused unit tests pass, including scoped annotation and endpoint forwarding:
  [unit-tests.log](unit-tests.log).
- Three live query tests pass, including exhaustive path enumeration for positive
  load/store/memory/branch caps with filtering enabled/disabled. A node that both
  loads and stores counts twice for the memory cap. Tests explicitly roll back:
  [live-query-tests.log](live-query-tests.log).
- Fresh baseline benchmark validation passes on ETISS for both programs. CRC32:
  4,005,445 run instructions/cycles. SHA256: 3,776,360. ETISS reports CPI 1 in this
  configuration; these are baseline simulator measurements, not hardware timing
  and not baseline-versus-ISE speedups.

## Failures and fixes exposed by the experiment

1. The initial RV32IM/ILP32 baseline failed because the installed libc uses a
   different floating-point ABI. The fresh experiment uses the existing
   RV32IMFD/ILP32D configuration consistently in both arms. See `baseline.log` and
   `baseline-rv32imfd.log`.
2. Strict count annotation rejects two cold CRC32 blocks and six SHA256 blocks.
   Stage-32 instruction counts differ from final ELF counts. Both old and new
   warning-mode reports retain the same failures; the identity changes do not
   resolve count differences introduced by later compiler passes. See `cdfg.log`,
   `sha-cdfg.log`, `ab.log` and each session's `bb_cdfg_validation` table.
3. Positive predicate caps used list-comprehension syntax unsupported by the
   installed Memgraph 2.14.1. Replaced the count with `reduce` and `CASE`, preserving
   load/store union semantics. The live exhaustive test covers the replacement.
4. Toolkit did not forward the resolved database host/port to `tool.main`.
   Added explicit forwarding with regression assertions. Earlier failed read
   queries therefore used the YAML endpoint; candidate evaluation after the fix
   explicitly uses port 28763. Workload imports and profile writes used the
   isolated endpoint throughout.
5. The root `flow_seal5.sh` service call initially failed because its CLI form did
   not match the client. Retried directly with `--tag llvm --output ...`.
6. Both the repository-config and default-config retargeting jobs then failed at
   `Marker not found: llvm/lib/Target/RISCV/AsmParser/RISCVAsmParser.cpp, None`.
   Job logs are retained under `retarget/`. No extended compiler was produced.
   Consequently there are no valid extended runtime measurements, dynamic opcode
   counts, executed/emitted ISE ratios or speedup claims in this report.

## Evidence and reproduction

All reports, logs, fresh sessions, ELF fixtures and generated definitions are
under this repository directory. They survive cleaning `/tmp`. No shared graph
was purged. The isolated database is disposable; its graph can be regenerated.

- [ab_experiment.py](ab_experiment.py): executes both Toolkit arms; raw outcomes
  in [ab-results.json](ab-results.json).
- [compare_outputs.py](compare_outputs.py): generates/compares CoreDSL and metrics.
- [decoder_experiment.py](decoder_experiment.py): rebuilds its fixtures locally;
  compiler/linker commands are in `decoder-commands.json`.
- [identity_experiment.py](identity_experiment.py): fresh live import and rejection
  checks. Its session output directory must be unused when rerun.
- [source-versions.json](source-versions.json): source revisions and fingerprints.

Source `scripts/env.sh` for the Python environment. Fresh baseline sessions were
created with `cfg/flow/paper/iss_only.env`, `ISS=etiss`, `BACKEND=none`, and
`OUT_DIR_BASE=$PWD/reports/bb-quality-20261102/runs`, running `full_flow.sh` with
`bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_pick`. CDFGs were imported
using `MEMGRAPH_HOST=127.0.0.1 MEMGRAPH_PORT=28763` and `flow_isaac_cdfg.sh`.

The isolated Memgraph used image
`sha256:949154d9b4186e08143ccfeacb049e93109cd259ade10fe2ecaef8df13da22c3`,
container `isaac-bb-quality-20261102`, host port 28763, 1 GiB container memory,
512 MiB graph limit, and temporary storage with WAL/snapshots disabled.

Fresh source/build directories must still exist for provenance verification.
If MLonMCU cleans them, rebuild fresh sessions rather than bypassing receipts.
To establish runtime/utilization quality, repair the retargeting-service marker
configuration, compile both generated sets with the same backend, validate
outputs, and measure dynamic opcode use and cycles. This experiment cannot
substitute source-profile opportunities for those measurements.

## Subsequent compiler repair

The retargeting blocker was subsequently repaired; see [compiler repair and static emission checks](../compiler-retargeting-20261103/report.md). The compiler now builds and emits custom instructions in the real CRC32 sources. This does not add extended runtime measurements to the original A/B experiment.

Subsequent dynamic old/new utilization measurements are in [the utilization comparison](../bb-utilization-20261103/report.md).
