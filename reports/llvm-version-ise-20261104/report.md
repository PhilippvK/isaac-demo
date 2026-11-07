# ISE performance across LLVM versions: CRC32 and SHA256

## Results

**CRC32: same. SHA256: LLVM22 has a larger relative ISE benefit, but its final
ISE-enabled program executes 1.46% more instructions than LLVM19.**

| Workload | LLVM | Native run instructions | With ISEs | ISE reduction | Estimated speedup |
|---|---:|---:|---:|---:|---:|
| CRC32 | 19.1.7 | 4,005,445 | 2,960,964 | 26.08% | 1.353× |
| CRC32 | 22.1.8 | 4,005,442 | 2,960,961 | 26.08% | 1.353× |
| SHA256 | 19.1.7 | 3,776,360 | 2,217,885 | 41.27% | 1.703× |
| SHA256 | 22.1.8 | 4,289,357 | 2,250,182 | 47.54% | 1.906× |

Lower instruction counts are better. Each reduction uses its own compiler's
native baseline. All eight runs pass benchmark output validation. SHA256's
native LLVM22 code executes 13.58% more instructions; its extended code executes
1.46% more. The higher 47.54% relative reduction therefore does not mean the
extended LLVM22 program outperforms the extended LLVM19 program.

CRC32 saves exactly 1,044,481 reported instructions on both versions. Its
benchmark-body trace interval is exactly 4,005,407 native and 2,960,927 extended
on both versions; the three-instruction difference in the reported counters
falls outside this interval. Treat CRC32 as unchanged.

### Actual ISE utilization

| Workload | Used/generated ISE types, both versions | Body custom executions, both versions |
|---|---:|---:|
| CRC32 | 4/32 (12.50%) | 696,320 |
| SHA256 | 19/105 (18.10%) | 1,161,375 |

Per-ISE execution counts within the benchmark body are identical across
versions for both workloads. There is no utilization improvement or regression
on these inputs. SHA256's extended body interval increases from 2,217,847 to
2,250,147 trace instructions while its custom executions stay unchanged: the
additional executed instructions are ordinary instructions. This observation
identifies where the count difference occurs, not its underlying optimization
cause.

Whole-program CRC32 static custom sites decrease from 12 to 9 and instrumentation
custom23 executions decrease from 24 to 12; these are outside benchmark-body
utilization. SHA256 has 437 static custom sites on both versions.

### Compiler checks

The local LLVM22 SHA256 retarget generated all 105 definitions and passed all
84 generated tests (82 instruction fixtures plus two extension/attribute tests).
The 23 immediate-operand definitions without generated fixtures are covered
only where exercised by benchmark validation, not individually proven.
SHA256 native `.text` is byte-identical before/after changing the retargeted
set from CRC32 to SHA256, and its reported count reproduces exactly
(`native-retarget-control.json`).

Both workload-specific LLVM22 compilers are retained: `crc32-llvm22/` and
`sha256-llvm22/compiler/`. The working `llvm-project-22/build` now contains the
SHA256 variant; the earlier CRC32 port remains available in its saved compiler
and source commit. The LLVM19 sources/installations are unchanged.

## Experiment

Compare the locally ported LLVM22.1.8 with retained LLVM19.1.7 retargeted
compilers on Embench CRC32 and nettle-sha256. For each workload, use exactly the
same previously generated CoreDSL instruction set across compiler versions (32 CRC32
instructions; 105 SHA256 instructions). The retained LLVM19 input differs only in its import directory prefix;
`input-fingerprints.json` verifies equality after normalizing that prefix.
No new discovery is performed: this
measures how compiler version affects the benefit and utilization of a fixed
ISE set. It does not measure the quality of ISEs discovered afresh by each version.

Each compiler/workload runs with and without XIsaac. Common settings are
RV32IMFD, ILP32D, O3, SelectionDAG, no loop unrolling and BB labels. Matching
ETISS cores are identical across versions and native/extended arms within a
workload. The cores support C because the shared libc contains compressed
instructions. GCC sysroot, libc, linker script, benchmark input, timing and
validation code are shared. ETISS uses native semihosting and no proxy kernel.

The CMake wrapper supplies an explicit RISC-V target and a static-library
try-compile because this LLVM22 build defaults to `unknown` and contains only
the RISC-V backend. Both versions use the same wrapper. This changes CMake's
compiler probe; actual workload compilation, linking and execution are retained
and validated. It does not suppress benchmark output validation.

ETISS has CPI 1 including custom instructions in this configuration. Reported
cycles therefore equal dynamic instructions; reductions and speedup factors are
functional instruction-count estimates, not measured hardware speedups or host
simulation wall times. Single runs suffice for these deterministic counts; no
statistical wall-clock claim is made.

## Evidence

- `summary.csv` / `summary.json`: native and extended instruction counts,
  absolute savings, relative reduction and estimated speedup.
- `results.csv` / `results.json`: detailed utilization, code/trace hashes,
  per-ISE executions and static sites.
- `runs/WORKLOAD/VERSION/{baseline,ise}/`: linked ELF, compile commands,
  validation, counter reports, disassembly and compressed instruction trace.
- `run.sh`, `cmake.sh`, `docker_etiss.py`: benchmark and simulator runner.
- `prepare_sha22.py`, `retarget_sha22.sh`: local SHA256 retargeting using the
  common stage0 of the completed LLVM22 port. CRC32 tools and state are saved
  under `crc32-llvm22/` before reusing the compiler build tree.
- `sha256-llvm22/`: generated model export, tests and retargeting reports.
- `analyze.py`: count actual dynamic custom PCs against matching disassembly.

Body utilization uses the trace interval from `mlonmcu_run` until `stop_bench`,
excluding setup and timing helpers. Whole-program counts include instrumentation
matches; these are kept separate. Reported run counters and trace interval
lengths cover slightly different scopes and are retained separately.

## Reproduction

From the repository root, run `run.sh WORKLOAD VERSION ARM` in this directory,
where WORKLOAD is `crc32` or `nettle-sha256`, VERSION is 19 or 22, and ARM is
`baseline` or `ise`. A matching ETISS container named `isaac-llvm-version-ise`
must mount the retained simulator installations at the original job prefixes;
see `docker_etiss.py` and `source-versions.json`. All compiler execution and
retargeting are local. The container supplies the simulator's matching libraries.

Then source `scripts/env.sh` and run this directory's `analyze.py`.
Reports and compressed traces remain in the repository and survive temp cleanup.

## Recorded failures and limitations

The old service worker container no longer existed. An isolated container using
the retained worker image and read-only mounts of the saved simulator installs
replaced it. Initial CMake compiler checks failed on the unknown default target;
only successful validated benchmark runs enter the results. Local Seal5 needs
a localhost logging socket, requiring execution outside the filesystem sandbox.
Reusing its state initially retained stale CRC32 patch/input registrations;
those were cleared before SHA256 generation. CRC32 binaries and state were
archived first, and no user compiler/source checkout was reset.

LLVM20/21 have Toolkit compatibility probes but no retargeted ISE compiler in
this experiment. Results compare 19 and 22 only. Neither workload is evidence
for universal compiler quality or for every instruction's semantics.

## Subsequent branch verification

The fused-branch experiment reuses the disposable `llvm-project-22/build` for
the branch compiler. The independently saved scalar compilers remain unchanged.
See `../fused-branches-20261104/report.md` for the current build and evidence.
