# Fused scalar memory patterns — 2026-11-04

## Result

Implemented generation, automatic encoding, compiler retargeting and ETISS
execution of scalar integer memory fusions. **Both SelectionDAG and GlobalISel
select all 16 RV32 fixtures from C.** This uses ordinary TableGen patterns and
LLVM's normal GI importer. PatternGen's experimental direct GISel-table support
is not used.

| Check | SelectionDAG | GlobalISel |
|---|---:|---:|
| C fixtures selecting the intended ISE | 16/16 | 16/16 |
| Differential cases passed | 4,096 | 4,096 |
| Actual fused executions | 2,048 | 2,048 |
| Sites executed | 16 | 16 |
| Total traced harness instructions | 5,277,301 | 5,277,301 |

Each fixture runs 128 inputs with the fused extension and 128 with native
instructions. Results and memory bytes are compared with an independent
bytewise reference. The tests cover byte/halfword/word accesses, sign and zero
extension, edge values, deterministic random data, positive and negative
register address offsets, truncation on stores, and unchanged neighboring
bytes. Selected loads reuse the address input register as their destination.
ETISS uses its own semihosting; there is no proxy kernel.

The two selectors produce identical `.text` and instruction traces for this
harness. Every fused fixture replaces two native operations with one custom
instruction. These are correctness fixtures; this is **not a workload runtime
or cycle speedup measurement**.

The final compiler was rebuilt after test-generation fixes. Both final
selector builds reproduce the exact executed `.text`; see
`final-compiler-execution-check.json`. Generated compiler tests pass **18/18**:
16 memory tests check both selectors, plus extension and attribute tests.
GlobalISel checks use `-global-isel-abort=1`, preventing silent fallback.
The focused regression suite passes **123 tests and 32 subtests**.

## Supported generation

- Address arithmetic fused with LB/LBU/LH/LHU/LW and SB/SH/SW.
- Load followed by integer arithmetic; fixtures use ADD.
- Arithmetic feeding store data; fixtures use XOR.
- RV64 generation additionally covers indexed LWU/LD and SD. In total,
  **35 RV32/RV64 definitions** pass generation, parsing and shared automatic
  encoding. RV64 was not compiled or executed in this experiment.
- One memory access per candidate, no branch, up to three GPR inputs.
  Loads have one register result; stores have none. Volatile/atomic/ordered
  candidates, unsupported operations and multiple memory accesses are filtered.
  Generic G_LOAD nodes without access-width metadata are rejected explicitly.
- Existing scalar arithmetic generation and branch regression tests still pass.
  Existing branch selection remains DAG-specific; this does not impose that
  restriction on memory patterns or on selector choice for evaluation.

Loads/stores now use the actual byte width rather than the old byte-only
emission for wider operations. Signed loads extend correctly to XLEN.
Address arithmetic wraps at XLEN. A named address temporary keeps inclusive
memory slices suitable for Seal5 normalization. Loads are evaluated before
the architectural x0 writeback guard; stores do not acquire a fake `rd`.
The shared allocator handles the resulting two/three-register encodings.
Effectful candidates skip generic operand/immediate variations.

## Compiler findings and fixes

The first compiler selected only load-plus-add fixtures: indexed memory and
store patterns lost to native patterns. The optional memory configuration now
sets `AddedComplexity=10`, and all 16 intended patterns are selected.

Initial generated tests requested GI despite an unintended DAG-only setting.
That setting is now **false** in the memory configuration. The explicit
`dag_only_memory` option remains available if a particular experiment needs it.

Four GI tests then selected a different valid ISE: synthetic input-pointer loads
let the word-load/add pattern absorb one of the test's register inputs. The
test generator now takes register inputs as scalars for memory fixtures and
checks both selectors. No selector C++ changes were needed.

## Selector consistency and optional evaluation comparison

`scripts/isel_config.sh` accepts `GLOBAL_ISEL=0|1` or `ISAAC_ISEL=dag|gisel`.
Conflicting settings are rejected. `flow_trace.sh` records the selected mode
in `run/instruction-selector.json`. Normal compare/retrace stages inherit it
unless explicitly overridden; legacy runs without metadata default to DAG.
These records describe the requested compiler mode, not proof that an arbitrary
compiler never falls back. The compiler probes above explicitly prohibit GI
fallback.

Run the same discovered instruction set through both evaluation selectors:

```bash
FINAL=1 bash scripts/flow_compare_isel.sh RUN_DIR
```

The wrapper runs compare, retrace and reanalysis for DAG and GI, preserving
separate `_isel_dag` and `_isel_gisel` outputs. It writes
`isel-comparison_final.json` with actual retraced instruction counts, custom
executions, static sites, utilized instruction counts and GI-minus-DAG deltas.
It includes unused ISEs and avoids double-counting utilization aggregate rows.
Comparison CSVs retain the regular native-versus-extension benchmark metrics.
Final/filtered suffixes now select the corresponding compare reports during
reanalysis. Static utilization scoring now reads the static table rather than
reading the dynamic table a second time.

The wrapper's stage order, selector settings, output separation, policy
inheritance and summary aggregation have automated tests. **A full MLonMCU
compare/retrace/reanalysis workload was not run here.** Runtime validation
above is a standalone bare-metal C/ETISS test. Comparison shares discovery;
separately discovering candidates with both selectors is a different experiment.

## Reproduction and retained evidence

```bash
source scripts/env.sh
python reports/fused-memory-20261104/generate_fixtures.py
# Retarget into the prepared disposable LLVM22 checkout:
bash reports/fused-memory-20261104/retarget.sh
GLOBAL_ISEL=0 bash reports/fused-memory-20261104/build_runtime.sh
GLOBAL_ISEL=1 bash reports/fused-memory-20261104/build_runtime.sh
```

For production runs, use `cfg/isaac/query/fused-memory.yml` for candidate
filtering and `FUSED_MEMORY=1 LLVM_MAJOR=22 scripts/flow_seal5.sh RUN_DIR` for
retargeting. The normal runner manages its own setup/reset; the report runner
resumes an already prepared disposable checkout.

Evidence retained in this directory:

- `generated-rv32/`, `generated-rv64/`: CoreDSL, trees and encoding plans.
- `compiler/llvm_install/`: independent final compiler; `compiler/seal5.tar.gz`:
  retarget export; `compiler/seal5_reports/`: generated test results.
- `final-retarget.log`: successful normal generation/build/test/export.
- `runtime-results-{dag,gisel}.json`, `runtime-{dag,gisel}.log`: execution results.
- `{dag,gisel}-memory-tests.{elf,dump}` and compressed instruction traces.
- `generation-results.json`, `codegen-results.json`, regression logs.
- Earlier failing build logs and archived state retain the diagnostic history.

LLVM22 common base: `646fe13e`; final generated source commit:
`cad0b2de32c91d20d4e0c39b7de194894f307107`.
