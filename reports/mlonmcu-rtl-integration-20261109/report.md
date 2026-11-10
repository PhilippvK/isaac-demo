# Native MLonMCU / Nailgun integration and GISel workaround

## GISel fallback result

Both `-global-isel-abort=0` (allow fallback) and `=2` (fallback with diagnostics)
still terminate LLVM22 in `RegBankSelect` on MLIF's `start_bench()`:

```
RegisterBankInfo.cpp:569
MeaningfulBitWidth.isScalable() || OrigValueBitWidth >= MeaningfulBitWidth
"Meaningful bits not covered by the mapping"
```

An assertion aborts the compiler before normal selector fallback can recover.
This is not an RTL failure. The underlying register-bank mapping bug is not fixed.

MLIF now appends `-mllvm -global-isel=0` **only to `lib/bench/bench.c`** when
GISel is enabled and `GLOBAL_ISEL_BENCH_DAG` is enabled. The option defaults on;
`nailgun.bench_dag=0` disables it for reproducing the compiler bug. All benchmark
sources retain GISel flags and its normal fallback policy. The actual compile
commands confirm precisely one explicit DAG exception; see
`per-source-selectors.json`. The legacy replay builder has the same exception.

## Native integration

- New MLonMCU `nailgun` target: generated CVA5 or VEX_5S RTL, normal MLIF
  compile/link/run and metrics/validation interfaces, preserved RTL artifacts.
- Native MLIF target/toolchains: GCC or LLVM, configurable RAM/heap/stack,
  newlib services, C++ constructor/destructor initialization and shutdown.
- Model I/O: ROM input data and binary stdout output. MLIF's automatic output
  selection now consults `supports_stdout`, rather than `supports_stdin`.
  Interactive stdin and a filesystem are not supplied.
- ISAAC `rtl_sim_0` now defaults to native MLonMCU execution. This preserves
  frontend/backend generation, dependencies, linking, requested validation and
  postprocessing. Historical compile-command replay remains opt-in.
- Normal setup installs the version-controlled MLIF patch. An existing setup
  can use `prepare_mlif.py ... --environment ...`; patch application was checked
  on pristine MLIF revision `9f0b47e8` and a second invocation was idempotent.
- Native model output arrays and build metadata are included in preserved
  reports outside disposable work directories.

## Validation performed

| Execution | Compiler/selector | Result |
|---|---|---|
| MLonMCU Embench CRC32 / Vex | LLVM22 GISel, bench.c DAG | Validation True |
| MLonMCU Embench SHA256 / Vex | LLVM22 GISel, bench.c DAG | Validation True |
| MLonMCU Embench CRC32 / CVA5 | LLVM22 GISel, bench.c DAG | Validation True |
| MLonMCU example hello_world / Vex | LLVM22 GISel, bench.c DAG | Validation True |
| MLonMCU example hello_world / Vex | GCC | Validation True |
| Same GCC workload, 512 KiB RAM / 16 KiB stack | GCC | Validation True |
| Full ISAAC rtl_sim_0 / Vex example | Native MLonMCU, GISel | Pass |
| Full ISAAC rtl_sim_0 / CVA5 CRC32 | Native MLonMCU, GISel | Pass |
| C++ vector/global constructor, heap, destructor fixture / Vex | Native MLIF CMake/toolchain | Pass |
| Same fixture, NUL/0xff/0x80 UART bytes through target API | Native MLIF CMake/toolchain | Exact bytes retained |

The C++ fixture is a component check, not a TFLM/TVM model. Full neural-network
frontend execution still needs validation with the corresponding framework and
backend dependencies; this report does not claim every MLonMCU frontend works.
ISA support and available simulated RAM remain hardware constraints.

The timing numbers are simulation measurements, not FPGA frequency estimates.
These checks establish integration correctness and do not measure automatic ISE
speedups. The known CVA5 backward fused BGEU problem is unchanged.

## Repositories and upstreaming

1. **isaac-demo-new**: native stage orchestration, runtime capacity/binary-output
   handling, setup integration, dependency patch, documentation and evidence.
2. **mlonmcu submodule**: target registration/adapter and automatic stdout output
   capability selection. This needs upstreaming.
3. **mlonmcu-sw / MLIF dependency**: native runtime/toolchains and per-file GISel
   workaround. This is not a submodule of isaac-demo-new. Its changes are committed
   in the local dependency and preserved as `cfg/mlif/nailgun.patch` for fresh
   installations; this needs upstreaming separately.

No compiler, Nailgun or SCAIE-V source was changed for this task. Source revisions
and portable dependency backups are preserved alongside this report.
