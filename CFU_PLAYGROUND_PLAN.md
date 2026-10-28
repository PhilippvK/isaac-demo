# CFU-Playground integration plan

Status: ISS constraints, experimental native evaluation on Verilator/Renode/FPGA,
and FPGA synthesis are implemented and demonstrated on CRC32. Verilator-based
initial discovery is now implemented through candidate generation. Fully native
candidate filtering/selection and broader validation remain outstanding. The
plan was presented before testing; later sections retain earlier milestone notes.

## Current verification checkpoint

- Named flow `demo_cfu` now composes ETISS discovery/selection with the selected
  final runner and report. General preset `cfg/flow/paper/cfu_rv32.env` includes
  the ISS preset and defaults the final runner to Verilator. Expansion and shell
  syntax checks pass; the composed 34-step flow has not been rerun as a fresh
  benchmark campaign. The opt-in `cfu_verilator_rv32.env` preset now replaces
  initial benchmark/trace stages using `CFU_DISCOVERY_RUNNER=verilator`.
- New `cfu_discover` flow passes baseline benchmarking, tracing, loading,
  analysis, visualization, block selection, Memgraph CDFG/query, and CoreDSL
  generation without ETISS execution. Run `20261022T132649` validates both
  native executions at 5,574,217 cycles / 4,179,652 instructions, analyzes
  4,179,658 in-window retirements, selects two blocks, and emits ten candidates.
  LLVM BB labels and complete compilation artifacts are exported; lowercase
  trace mnemonics preserve control-flow recognition. Three trace/load regression
  tests pass. The broad `run*/` ignore rule previously hid required runtime
  sources; a narrow exception now includes `cfg/cfu_playground/runtime/`.

- Dedicated preset: `cfg/flow/paper/cfu_iss_rv32.env`; separate ilp32 runtime at
  `install/gnu_cfu`, forwarded explicitly through all evaluation scripts.
- Eight focused tests pass, covering CFU allocation, production artifacts,
  persisted-ID replay, operand filtering, and GPR writeback guards.
- CRC32 run `20261021T154523` completed the full ISS flow with 10 initial and 3
  selected operations. Validation passed, but a subsequent targeted test exposed
  an x0-write defect in the generated instruction semantics. This older run is
  preserved as a negative control and is not the final guarded acceptance run.
- Normal and fused CoreDSL emitters now guard each GPR writeback with a nonzero
  destination-index check. Prior computation statements and FPR0 are unaffected;
  the intermediate FLAT representation is unchanged.
- Fresh guarded CRC32 run: `out/embench_iot/crc32/20261021T203031`.
  Full flow log: `/tmp/isaac-cfu-crc32-guarded.log`. Guarded-source compiler and
  ISS retargeting have passed. The initial benchmark comparison reports
  4,005,445 baseline versus 3,483,205 extended run instructions and ROM code
  3,124 versus 3,104 bytes (`compare.csv`). Per-instruction evaluation is running;
  The filtered/selected benchmark also validates with the same figures. Its
  three operations preserve function IDs 4, 5, and 6. Static disassembly audits
  pass for both initial and selected firmware (five CFU sites each), and the
  baseline contains none. Unknown IDs and invalid unused source fields are
  rejected by negative checks of `scripts/verify_cfu_disassembly.py`.
  Retracing/reporting finished with process exit 0; `ci_report.md`, choice
  summaries, and the final comparison CSV exist. Dynamic utilization reports
  174,080 executions each for CUSTOM4, CUSTOM5, and CUSTOM6.
  Recheck the live execution handle and log before resuming work.
- An isolated simulator built from that run's guarded core passes 42 explicit
  operand cases for CUSTOM0 (destination/source aliases, equal sources, x0
  inputs/discarded output, signed boundaries, and wraparound). The same program
  fails on the preserved unguarded simulator. Source, ELF, reference description,
  and `cfu_operand_checks.validation.json` are saved in the fresh run's `work/`.
  This covers one generated operation's operand behavior, not all operations.
- The guarded CRC32 end-to-end run, static encoding audit, benchmark validation,
  and final reports pass. Broader operation/benchmark coverage remains useful
  but does not replace the outstanding hardware milestones.
  A second benchmark, nettle-sha256, was proposed for broader coverage; its
  baseline/tracing/candidate preparation is running in `20261021T203457`.
  No compiler build has been started for it. Following the user's scope question,
  do not advance it to compiler retargeting until that scope is settled.
  Hardware execution and synthesis milestones remain outstanding.

## Goal and milestones

Integrate ISAAC candidate discovery, compiler/ISS retargeting, generated CFU RTL,
execution on CFU-Playground, and FPGA synthesis/resource reporting. Completing
the ISS milestone does not complete the overall backend.

| Milestone | Deliverable | Working-day estimate |
| --- | --- | --- |
| 1 | CFU-constrained ISS generation and evaluation | 4–7 |
| 2 | Generated CFU RTL and VexRiscv execution under Verilator | 10–18 |
| 3 | Selectable Renode, full-system Verilator, and FPGA execution | 8–14 |
| 4 | Baseline/extended FPGA synthesis and resource/timing reports | 5–10 |

Allow approximately 8–12 working weeks for one experienced developer, including
integration contingency. RTL lowering, board access, and toolchain compatibility
are the largest uncertainties. Revisit estimates at each milestone.

## Proposed initial interface contract

- RV32 integer operations with no hidden state or side effects.
- At most two 32-bit GPR source values and exactly one 32-bit GPR result.
- Fixed 32-bit R-type instruction: funct7[31:25], rs2[24:20], rs1[19:15],
  funct3[14:12], rd[11:7], CUSTOM0[6:0] = 0x0b.
- function_id = (funct7 << 3) | funct3; at most 1024 IDs before reservations.
- Missing sources use a documented canonical representation; unused source
  fields must not become additional function-ID or immediate bits.
- Architectural rd/rs1/rs2 aliasing is legal. Initially exclude generated tied
  INOUT operands, which need separate mapping and compiler-constraint handling.
- Constants may be embedded in the operation; no instruction-immediate operands.
- No memory accesses, branches, CSR operations, FP registers, or implicit CPU
  state inside generated operations. Width and signedness must be explicit.
- Preserve IDs across filtering/selection. Record encoding, operand mapping,
  semantics identity, and source provenance in a manifest shared by ISS, LLVM,
  and RTL generation. Reject collisions and namespace exhaustion.
- Base-ISA instructions may be compressed when supported by the chosen CPU and
  runtime; the generated CFU instructions themselves remain 32-bit.
- Stateful, multi-invocation, and memory-connected accelerators remain future
  extensions requiring a new contract and compiler/selection support.

## Current-code findings

- `memgraph_experiments/tool/gen/cdsl.py` emits `encoding: auto`.
- `isaac-toolkit/.../generate/iss/generate_etiss_core.py` invokes the general
  `M2-ISA-R/m2isar/transforms/encode_instructions/encoder.py` allocator.
- `memgraph_experiments/tool/stages/filter_subs_operands.py` counts register
  operands and explicitly does not reject immediate operands.
- `isaac-toolkit/.../generate/ise/query_candidates_from_db.py` supplies explicit
  query CLI defaults, including operand and memory limits. A new YAML alone is
  insufficient: verify precedence and propagate the CFU contract end to end.
- `scripts/flow_assign_enc.sh` annotates scores; it does not enforce a format.
- The general allocator's opcode pool includes multiple custom opcodes and
  reserved opcode spaces; allocation depends on mutable module-level state.
  Restricting operand counts does not restrict allocation to CUSTOM0. The CFU
  policy must use an explicit namespace independent of that global allocator.
- Register-class masks are flags: GPR is `2`, whereas `3` also admits UNKNOWN.
  Use the exact GPR class and validate the generated operand metadata.
- Existing Vex presets use ETISS/ETISS-perf. They do not establish identity with
  a particular CFU-Playground VexRiscv hardware variant.

## Step 1 implementation and verification plan

1. Introduce dedicated CFU query/toolkit/flow presets without changing existing
   preset behavior. Select an RV32 integer ABI and compatible runtime libraries.
2. Propagate constraint settings through query CLI construction. Add explicit
   validation of GPR directions, widths, immediates, and prohibited side effects.
3. Add an opt-in CFU encoding policy and stable manifest. Ensure combined and
   split CoreDSL sets consumed by ETISS and Seal5 share the exact encodings.
4. Make filtering/selection preserve IDs and update their encoding-cost model
   to the fixed CFU namespace instead of variable register/immediate footprints.
5. After approval: verify operand rejection, encoding fields, collisions,
   namespace limits, and deterministic IDs. Exercise unary/binary operations,
   source/destination aliasing, x0, signed boundaries, and overflow behavior.
6. Run a small integer benchmark through the full ISS flow, then the previously
   exercised nettle-sha256 benchmark. Inspect machine encodings and require
   baseline/custom validation plus matching compiler and simulator manifests.

Gate: CFU legality proven from generated artifacts and execution, with reports
labeling instruction-count reduction separately from hardware speedup.

### Step 1 implementation map

| Location | Proposed responsibility |
| --- | --- |
| `cfg/flow/`, `cfg/isaac/query/`, `cfg/isaac_toolkit/` | Dedicated, opt-in CFU preset and contract selection |
| `isaac_toolkit/generate/ise/query_candidates_from_db.py` | Forward contract settings without silently overriding YAML; validate candidate metadata |
| `isaac_toolkit/generate/iss/generate_etiss_core.py` | Apply CFU allocation, export manifest, validate generated combined/split sets |
| `m2isar/transforms/encode_instructions/` | Reuse metamodel encoding primitives; preserve the general allocator for existing targets |
| `scripts/flow_isaac_etiss.sh` | Forward the selected policy and manifest for initial, filtered, and selected variants |
| Encoding-score annotation and selection | Account for fixed function-ID consumption and preserve original IDs |
| Verification | Compare manifest masks/values and field mappings to compiler artifacts and executed code |

The existing ETISS-core generator already emits a combined encoded set,
per-instruction split sets, and candidate `cdsl_encoded` artifacts from the same
encoded definitions. Seal5 consumes the split set. This is the preferred point
to assign and verify IDs once, rather than adding separate allocators to LLVM and
RTL export. Filtering must reload the original assignments; enumeration of a
filtered candidate list must never determine its new IDs. Store the original
candidate identity as well as its current list index and instruction name.

Define canonical absent-source bits, full match mask, and operand field mapping
in the manifest. Reject malformed persisted assignments rather than replacing
them silently. Ensure postprocessing cannot change an encoded instruction's
semantics or function ID without invalidating downstream cached artifacts.

First test sequence: focused contract/encoding cases,
artifact roundtrip through the existing CoreDSL writer/parser, then a small
end-to-end benchmark, followed by nettle-sha256. Inspect emitted instruction
words and both baseline/extended validation results; a successful build alone
does not pass the milestone. Focused tests and initial CRC32 artifact checks now
pass; compiler/ISS end-to-end verification is still in progress.

## Steps 2–4 design decisions and acceptance gates

### RTL and platform integration

Initial implementation: `isaac_toolkit.generate.hardware.cfu` exports typed
candidate trees with manifest IDs into `cfu.sv` and `cfu_rtl.json`. It currently
supports RV32 add/subtract, low multiply, bitwise logic, and masked shifts;
unsupported operations fail explicitly. All ten guarded CRC32 candidates export
and pass Verilator lint. A separately written C++ reference test passes 11,264
cases (1,024 per operation plus unknown-ID cases), with response stalls,
simultaneous consumption/replacement, draining, and reset. Generated RTL,
provenance, reference test, and validation log are preserved under the guarded
CRC32 run's `work/cfu_rtl/`. This is standalone CFU validation, not execution on
VexRiscv. Broader operation coverage, reproducible regression integration, tree
versus ISS equivalence, and whole-system integration remain necessary.

The pinned CFU-Playground checkout and its pinned LiteX dependencies now
elaborate a `full+cfu+debug` SimSoC using that generated RTL. The adapter
`scripts/cfu_playground_sim.py` isolates dependency imports, checks initialized
gitlinks, and records revisions, hashes, command, log, and exit status. Verified
elaboration output is `/tmp/isaac-cfu-litex-adapter`, including `csr.json` and
generated software headers/linker regions. The full-system Verilator build now
passes and executes a ROM-boot assembly smoke test: 40 independent arithmetic
checks across all ten generated operations, simulated UART pass output, and
termination through LiteX's finish CSR. The initial build caught a missing RTL
timescale, now fixed in the emitter. Firmware, source, execution log, CSR map,
and revision/hash record are preserved in the guarded run's `work/cfu_vex_smoke/`.
The launcher supports ROM boot and process-group timeout cleanup, and can require
an explicit success token. This verifies actual VexRiscv CPU RTL execution;
benchmark runtime/linker integration, trace export, cycle metrics, and normal
flow orchestration remain outstanding. Existing ETISS firmware uses a different
memory map and cannot simply be reused.

Benchmark checkpoint: `scripts/cfu_build_embench.py` and the runtime in
`cfg/cfu_playground/runtime/` now build Embench firmware for ROM boot with RAM
data initialization and stack, UART validation output, finish CSR, and 64-bit
cycle/instruction counters. CSR addresses and memory bounds come from the
elaborated SoC JSON. The baseline and selected-extension CRC32 firmware both
validate on full-system Verilator. With identical SoC and runtime, baseline is
5,574,216 cycles / 4,179,652 retired instructions, versus extended
5,400,136 cycles / 3,657,412 retired instructions: 3.12% fewer cycles and 12.49%
fewer retired instructions. These counters include read/call overhead around the
benchmark and exclude initialization/validation. They are specific to ROM boot,
this CPU/cache configuration, and the one-cycle registered CFU response.
Artifacts and comparison CSV are preserved under `work/cfu_vex_benchmark/` in
the guarded CRC32 run. The launcher now exports parsed benchmark metrics and
requires validation when those metrics are present. General flow integration,
trace export, other simulator runners, and synthesis are still outstanding.

Flow/trace checkpoint: `cfu_0` and `cfu_0_filtered_selected` are now recognized
by `full_flow.sh` and invoke the Embench evaluation orchestrator. The selected
CRC32 orchestration passes from RTL export through both firmware runs and
encoding audits, reproducing the measurements above. `CFU_INSTRUCTION_TRACE=1`
enables a bound retirement monitor and imports traces into ISAAC sessions.
The traced extended benchmark validates with unchanged metrics; its 3,658,388
retirements match static words/PCs, including 174,080 occurrences of each selected
operation. The loader's regression test rejects wrong words, unknown PCs, and
nonmonotonic cycles across chunks. Operand/memory values and deeper analysis
orchestration remain unimplemented. Renode, FPGA, and synthesis remain open.

Assess whether existing HLS output can supply operation datapaths. Generate a
CFU decoder and ready/valid wrapper, including reset and result backpressure.
Compare RTL results against the ISS semantics for each operation before running
benchmark firmware. Stateful latency control must not alter the pure-operation
contract. Record fixed/variable latency and measure its performance impact.

Source inspection for the first implementation:

- The toolkit's `generate/hardware/hls/nailgun.py` has an empty
  `SUPPORTED_CORES` list and an unimplemented output-copying path. The separate
  shell HLS flow exists, but neither establishes a working CFU export contract.
  Do not assume that ISS fake-HLS selection produced usable hardware.
- Candidate indexes already carry `artifacts.tree`, a typed operation tree
  containing declarations, casts, operations, input-register reads, and a final
  architectural write. For example, guarded CRC32 CUSTOM0 references
  `benchmark_body_%bb.3_0/tree28.pkl` and computes
  `rs2 + ((rs1 & 255) << 2)` modulo 2^32.
- Use this typed representation for a dedicated, initially combinational RTL
  datapath emitter. Preserve explicit width truncations and signed extensions;
  reject unsupported nodes rather than silently removing candidates. Implement
  the instruction semantics selected by the tree, including RV32 shift-count
  masking and division corner cases where those operations occur.
- Resolve register reads using the manifest's source mapping. Lower the final
  architectural write to the result output; the CFU has no destination-index
  port. The CPU handles discarded x0 writes, while CoreDSL retains its guard.
- Decode all ten function-ID bits from the existing allocation ledger. A
  one-entry registered response wrapper should accept a command only when its
  result slot is free or being consumed, hold data stable under backpressure,
  and clear response-valid on reset. Record this latency explicitly. Verify
  back-to-back commands, stalls, and reset as well as operation values.
- Verilator, Yosys, and Vivado executables are available in the current host's
  PATH. This establishes tool availability only, not working versions, licenses,
  device support, or successful whole-system builds.

Prefer CFU-Playground's existing LiteX integration with an MLonMCU adapter.
Decide focused backport versus MLonMCU upgrade after checking compatibility with
the local CDFG and compiler changes. Pin CPU variant, ISA/ABI, memory layout,
caches, clocks, and all relevant revisions. Avoid custom CPU/LiteX changes unless
the pinned configuration demonstrably requires them.

Gate: baseline and generated CFU firmware validate on actual VexRiscv RTL under
Verilator, and tracing supplies the artifacts required by ISAAC analysis. Confirm
availability of ELF/DWARF, disassembly, linker map, compile commands, LLVM BB
mapping, and normalized instruction traces; adapt the loader where necessary.

### Execution targets

Renode checkpoint: the portable version pinned by CFU-Playground
(`1.14.0+20231102git998250fe`) is downloaded at `/tmp/isaac-renode-pinned`.
Pinned Verilator bridge sources are prepared at `/tmp/isaac-renode-vil`,
including CFU-Playground's renode.h import patch. The shared library build
succeeds; its reproducible CMake entry point is
`cfg/cfu_playground/renode/CMakeLists.txt`. Renode executes all 40 arithmetic
smoke checks using the same CFU RTL and ELF as the VexRiscv smoke and prints
`ISAAC_CFU_PASS_40`. The stock UART model's missing TX-empty register has now
been addressed by `cfg/cfu_playground/renode/IsaacLiteX.cs`, which also models the
finish CSR. The corrected smoke reaches its finish write. The bounded runner
`scripts/cfu_renode.py` validates both baseline and extended CRC32 ELF files,
with retired-instruction counts 4,179,652 and 3,657,412 matching the Verilator
runs. It requires pass and finish markers and has process-group timeout cleanup.
The pinned emulator omits `instreth`; a custom zero high half is used only with
bounded virtual execution below 2^32 instructions at an explicit 100 MIPS.
Renode CPU cycles are labeled `model_cycles`, not VexRiscv RTL cycles.
`CFU_RUNNER=renode` selects this path in the evaluation orchestrator, with
separate output directories. End-to-end orchestration verification passes with
exit 0 (`/tmp/isaac-cfu-renode-flow.log`), including the bridge build, both static
encoding audits, both benchmark/finish validations, and comparison CSV export.
Results are in the guarded run's `work/cfu_evaluation_filtered_selected_renode/`.
Board selection is now Digilent Arty A7-100T, connected with Digilent serial
`210319C0891F`. Vivado 2024.1 is at
`/usr/local/tools/xilinx/Vivado/2024.1/bin/`. Host JTAG discovery confirms an
XC7A100T. `scripts/cfu_arty.py` builds matching full/full+CFU CPU configurations
at 50 MHz with 128 KiB integrated RAM and ROM-boot firmware. Both baseline and
extended builds finish synthesis, placement, routing, and bitstream generation,
with timing met (routed WNS 1.246 ns each). `scripts/cfu_fpga_report.py` extracts
measured whole-SoC resources and routed timing, plus separately labeled hierarchy
attribution. The extended-minus-baseline delta is 30 LUTs, 44 FFs, zero BRAM
tiles, and zero DSPs. Artifacts are under the guarded run's `work/cfu_fpga/`.

`scripts/cfu_fpga_run.py` is prepared for volatile programming and UART capture
with board locking and validation. Its first attempt stops before programming:
the host account ga87puy cannot open `/dev/ttyUSB1` (device ACL only grants
root/plugdev/sddm). Requested `sudo setfacl -m u:ga87puy:rw /dev/ttyUSB1` from the
user. Access has since been granted and both physical CRC32 runs validate.
Baseline full+debug reports 5,922,894 cycles / 4,179,652 instructions; extended
full+cfu+debug reports 5,400,136 cycles / 3,657,412 instructions. These use the
board-specific ROM/RAM/CSR map. The baseline cycle difference versus the earlier
CFU-capable simulator baseline still needs attribution; do not characterize the
whole difference as an isolated CFU effect. The extended result matches the
earlier full-system Verilator result. No flash write has been attempted.

FPGA orchestration now accepts `CFU_RUNNER=fpga` and
`CFU_SYNTHESIZE_ONLY=1`. It elaborates the board map, compiles and audits both
firmware variants, builds matching gateware, extracts resource/timing reports,
and optionally invokes the locked UART/programming runner. Build records now
cache completed bitstreams/reports using source/configuration fingerprints and
verify output checksums on reuse. The synthesis-only integration passes with
exit 0 (`/tmp/isaac-cfu-fpga-flow.log`). A second run verifies both cache hits
without resynthesis (`/tmp/isaac-cfu-fpga-cache-check.log`). Opening the FTDI UART
can reset the previous image; an initial baseline capture correctly rejected
two boot reports. The programming runner now handshakes with Vivado and clears
UART output at the programming boundary. The corrected baseline capture passes;
extended revalidation with that handshake also passes with unchanged counters.
`work/cfu_fpga/board_compare.csv` records the verified physical measurements.
Physical artifacts are under `work/cfu_fpga/{baseline_run,extended_run}/`.

- Renode with a Verilated CFU: functional execution; label timing-model limits.
- Full-system Verilator: execute the pinned VexRiscv RTL and measure cycles.
- FPGA: program one agreed board, run firmware, capture output and counters.

Use common validation/metric artifacts but record measurement provenance.
Add reliable exit detection, timeouts, isolated build directories, and board
locking. Reuse the same generated RTL/manifest across runners. Compare firmware
binaries where memory maps permit; record differences where they do not.

Gate: cross-target output agreement and baseline-relative measurements. Renode
CPU emulation must not be reported as execution of VexRiscv CPU RTL. Obtain board
and toolchain choices before hardware-dependent work.

### FPGA synthesis

Build baseline and extended versions of the same SoC configuration. Collect
LUTs, FFs, BRAM, DSPs, timing constraints/slack, and achieved frequency, with
explicit whole-SoC and CFU contributions where available. Use implementation
timing for frequency claims and distinguish it from synthesis estimates. Include
cycle and clock-frequency changes when calculating speedup. Cache builds using
RTL, manifest, tool version, device, constraints, and CPU configuration identities.

Gate: reproducible baseline/extended reports for one device and end-to-end flow
documentation; no fake-HLS estimates presented as measured FPGA resources.

## Inspected upstream references

CFU-Playground revision: `7f8ec4147b39db98534f8a10f9ddb1c26aca5648`.
MLonMCU revision: `2d86b00f93221eaa5049196ae7fc525289e052bc`.

- [CFU RTL ports](https://github.com/google/CFU-Playground/blob/7f8ec4147b39db98534f8a10f9ddb1c26aca5648/proj/proj_template_v/cfu.v)
- [Instruction encoding](https://github.com/google/CFU-Playground/blob/7f8ec4147b39db98534f8a10f9ddb1c26aca5648/third_party/SaxonSoc/riscv.h)
- [Software interface](https://github.com/google/CFU-Playground/blob/7f8ec4147b39db98534f8a10f9ddb1c26aca5648/common/src/cfu.h)
- [CPU variants](https://github.com/google/CFU-Playground/blob/7f8ec4147b39db98534f8a10f9ddb1c26aca5648/soc/vexriscv/README.md)
- [MLonMCU platform](https://github.com/tum-ei-eda/mlonmcu/blob/2d86b00f93221eaa5049196ae7fc525289e052bc/mlonmcu/platform/cfu_playground/cfu_playground.py)
- [Renode integration](https://cfu-playground.readthedocs.io/en/latest/renode.html)

Upstream MLonMCU has `cfu_full` and `cfu_full_rtl` targets, but its platform
explicitly rejects FPGA execution, contains incomplete timeout/exit handling,
and has a hardcoded hello-world path for the `none` backend. The default project
template resource is absent in the inspected tree. Reusing this code requires
integration work; its existence is not evidence of an operational ISAAC backend.
