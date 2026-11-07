# CVA5 / SCAIE-V 2.0 HLS preparation — CRC32

## Status

**Real HLS and SCAIE-V 2.0 integration into CVA5 completed successfully.**
The image is `philippvk/isaac-quickstart-hls:latest`, pinned for this experiment
by digest `sha256:40e063cb86db7a6c36c5c1f11a412506a6866423df06087a36e82ba598d54c79`.
Its bundled README identifies SCAIE-V 2.0; generated integration uses its CVA5 backend.

| HLS job | Instructions | Scheduled latency | II | Result |
|---|---:|---:|---:|---|
| Full CRC32 set | 116 | 4 cycles | 1 | HLS and CVA5 integration passed |
| CRC32 load subset | 5 | 4 cycles | 1 | HLS and CVA5 integration passed |
| Supplemental branch probes | 6 | 2 cycles | 1 | HLS and CVA5 integration passed |
| Supplemental SB/SH/SW probes | 3 | 3 cycles | 1 | HLS and CVA5 integration passed |

These are scheduler results, not measured RTL execution latencies or workload
speedups. Jobs use CBC, a 100 ns target period, the compact cell library and
OL2 operator estimates. `SIM_ENABLE` and `OL2_ENABLE` are disabled in saved
configs. No functional RTL simulation, ASIP synthesis or FPGA synthesis ran.
Instructions were scheduled in separate groups; shared-resource synthesis of
the combined set was not run. The baseline CVA5 generation also passed.

`hls-results.json` records results; `hls-run/` retains schedules, generated
extension RTL, SCAIE-V YAML, CVA5 wrapper/glue RTL and file lists.

The run uses the updated **cva5_reuseio** preset, CRC32, RV32IM with
Zicsr/Zifencei, ILP32, LLVM22 and SelectionDAG. The functional baseline runs
on ETISS with native semihosting; it is not a CVA5 RTL simulation.

Completed stages:

1. Fresh compile, functional validation and instruction trace.
2. Toolkit load, static/dynamic analysis and basic-block selection.
3. CDFG import into Memgraph with unique compilation/session identity.
4. Candidate queries with register reuse enabled.
5. CoreDSL generation, shared automatic encoding and ETISS core model export.
6. Self-contained HLS export and parse/encoding roundtrip checks.
7. Real Treenail/Longnail scheduling and SCAIE-V/CVA5 RTL integration.

Compiler retargeting and extended-ISA workload execution were not prerequisites
for preparing these HLS inputs and were not repeated in this run.

## Inputs and encoding policy

Current full-set input: `hls-inputs/crc32-scaiev2-final/XIsaac.hls.core_desc`.
The following earlier handoff inputs are retained as preparation evidence:

| Input | Instructions | Purpose |
|---|---:|---|
| `hls-inputs/crc32/XIsaac.hls.core_desc` | 116 | Full discovered CRC32 set |
| `hls-inputs/crc32/XMemoryCRC32.hls.core_desc` | 5 | Memory-only subset of that set |
| `hls-inputs/branch-probes/XBranch.hls.core_desc` | 6 | Supplemental BEQ/BNE/BLT/BGE/BLTU/BGEU probes |

`handoff.json` records input hashes, target/interface requirements and checks.
The regular flow directory is
`runs/crc32/20261105T120000`; its HLS input is
`work/gen/XIsaac.hls.core_desc`. Configuration snapshots are in `config/`.
The subset retains the full set's instruction encodings; it does not reallocate
them. The supplemental branch set is a separate HLS job and must not be merged
with CRC32 without reallocating/checking its encodings.

The CRC32 query selected **111 arithmetic and five memory candidates**.
All five memory accesses retain their inclusive byte ranges, and the 116
instruction code/mask pairs agree before and after HLS export. The full HLS
model declares X and MEM; the six branch probes declare X and PC. All parse
as nonempty instruction sets. The current type inference reports non-static
slice-width warnings for affine memory bounds. The bounds are preserved;
the supplied HLS backend still needs to establish its own handling of them.

**No branch ISE was selected from CRC32.** Its relevant decrement/branch has a
live register result. Current branch generation permits an effect with no
register output, so this candidate is correctly filtered. The six probes reuse
the previously executed branch regression definitions and are supplemental
coverage, not CRC32 discovery results. Supporting decrement-and-branch with
register writeback is separate generator work.

## Configuration and fixes made before handoff

- Created the missing `cfg/isaac_toolkit/cva5_reuseio.yml`, enabling memory,
  loads, stores and branches during potential analysis.
- Set `max_mems=1` and `min_outputs=0` in the reuse-I/O query config. Retained
  the existing two-register-input limit; three-input memory operations require
  confirmation against the actual CVA5/SCAIE-V interface.
- Enabled fused-memory/branch compiler configuration and disabled FPGA
  synthesis in the flow preset. ASIP synthesis was already disabled.
- Fixed Toolkit query defaults that overrode the YAML memory/output limits.
  Runs without query YAML retain the old wrapper defaults.
- Filtered unsupported global-symbol relocation operands instead of treating
  every label as a branch target and aborting discovery.
- Added referenced MEM/PC state to self-contained HLS exports.
- Fixed M2-ISA-R CoreDSL serialization dropping the lower bound of indexed
  ranges. Without this, exported word accesses became single-byte accesses.
- Fixed `flow_hls.sh` reading the misspelled `ISAAX_SET_NAME`; it now honors
  `ISAAC_SET_NAME`, with the old spelling retained as a fallback.

The first baseline attempt used a hard-float-only GNU library installation and
failed to link ILP32. The successful run uses the existing `install/gnu_cfu`
RV32 ILP32 toolchain and an isolated MLonMCU environment under this report.

## Basic-block validation qualification

The two selected hot blocks pass existing strict identity/count checks:

| Block | ELF instructions | CDFG nodes | Allowed difference | Result |
|---|---:|---:|---:|---|
| `benchmark_body %bb.3` | 10 | 15 | 6.0 | tolerated |
| `rand_beebs %bb.0` | 13 | 14 | 6.3 | tolerated |

The initial all-block annotation stopped on two unselected cold entry/exit
blocks. Final ELF includes stack setup/teardown that stage-32 CDFG does not.
Disassembly shows the additional stack operations. For this run, annotation
was explicitly repeated with warnings, followed by strict validation of the
selected blocks. Production validation defaults were not weakened. Full and
selected reports are retained as `bb-validation-all.csv` and
`bb-validation-selected.csv`; `annotate_selected.py` records this procedure.

## Interface constraints now honored by ISAAC

The original unconstrained CRC32 encodings were rejected by Longnail: word
memory accesses require `funct3=010` (bits 14:12). The real SCAIE-V decoder also
ignores fixed unused register-field bits as discriminators. The first full-set
run therefore failed its encoding-overlap DRC even though complete 32-bit
patterns were collision-free. Both failures are retained in the logs.

The shared allocator now supports per-instruction fixed bits and a target
decoder mask. Toolkit exposes `--encoding-interface scaiev2`, forwarded from
`ISAAC_ENCODING_INTERFACE=scaiev2` in the CVA5 reuse-I/O preset. It constrains
memory funct3 values from the source opcode and allocates the full instruction
set with decoder mask `0xfe00707f` (opcode, funct3, funct7). Fixed bits must not
consume operand bits. Incompatible pins and projected decoder overlaps are
rejected. Generic allocation retains its full 32-bit policy.

All **116** regenerated instructions passed full-pattern and projected-decoder
collision checks, including the five constrained word loads. The resulting
compiler, simulator and HLS exports share this plan. The successful full-set
HLS run used that ISAAC allocation, not the earlier manually adjusted memory
probe. See `encoding-plan-scaiev2-final.json`,
`encoding-interface-scaiev2-final.json`, and the current run's `work/gen/`.
Compiler retargeting and execution of the newly re-encoded set have not been
repeated; no software speedup is claimed.

Two source compatibility fixes were also required:

- Branch PC updates now explicitly wrap to XLEN. Treenail otherwise rejected
  its widened signed addition assigned to a 32-bit PC.
- The CoreDSL writer emits canonical affine memory bounds such as
  `MEM[addr+3:addr]`. Treenail failed to infer width from the equivalent
  `MEM[(addr)+(3):addr]`. This formatting is now generated from the model,
  including when the model contains parenthesized reference nodes.

The successful load job produces `RdMem`, address, size, request/response and
register-writeback interfaces. Store probes produce `WrMem`, address, size and
valid-request interfaces. Branch probes produce PC-write, valid-request and
flush interfaces. These demonstrate backend integration; they do not establish
functional RTL correctness.

## Reproduction

After sourcing `scripts/env.sh` and `cfg/flow/paper/cva5_reuseio.env`, regenerate
with `scripts/flow_isaac_etiss.sh RUN_DIR`. The preset now selects the proposed
HLS image and SCAIE-V encoding mode. Allocation emits `encoding_interface.json`
alongside `encoding_plan.json`.

`run_hls_image.sh` records the real image invocation for `crc32`, `memory`,
`branches` and `stores`. It expects the dedicated container to be running with
this report mounted at `/experiment`; the container is stopped after the run.
The reproduction script selects CBC explicitly, while the preset's Gurobi
setting remains available for users supplying a license. Physical synthesis
and simulation were not part of this HLS run; the subsequent FPGA run is linked below.

Logs of each stage, earlier failures, configuration snapshots, image metadata
and source patches remain in this repository. No unit-test suite was added or
run during this preparation; verification used actual allocation, HLS execution
and artifact checks.

## Subsequent FPGA evaluation

After authorization to use Vivado 2024.1, these retained RTL outputs were used
for [FPGA synthesis and implementation](../cva5-fpga-20261105/report.md).
The CVA5 preset now enables FPGA synthesis with a fresh baseline at 50 ns.
