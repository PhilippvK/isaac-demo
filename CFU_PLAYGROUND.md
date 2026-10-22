# CFU-Playground integration

The initial integration is an opt-in, CFU-constrained ETISS/LLVM flow. Generated
instructions use the CFU-Playground CUSTOM0 R-type interface: up to two RV32 GPR
inputs, one RV32 GPR output, and a 10-bit function ID. Instruction immediates,
tied INOUT operands, memory/control-flow operations, and non-GPR operands are
rejected. Constants can be embedded in instruction behavior. Register aliasing
at execution time remains legal.
Normal and fused CoreDSL emission guard architectural GPR writeback with
`if (rd != 0)` (using each destination's actual operand name). Computations
preceding writeback still execute, and floating-point register zero is writable.

VexRiscv RTL evaluation is available through the separate CFU flow below. Renode,
FPGA execution, and FPGA resource reporting remain subsequent milestones
described in [the integration plan](CFU_PLAYGROUND_PLAN.md). They are not enabled
by the ISS preset. Instruction-count improvements from this preset
are not measurements of CFU hardware speedup. The existing demo_iss flow uses
fake-HLS estimates during selection; those are not FPGA synthesis results.

## Prerequisites and first run

Use the existing ISAAC environment, including Memgraph, LLVM with CDFG support,
ETISS, and Seal5. The preset requires RV32IM soft-float runtime libraries with
the ilp32 ABI. A toolchain containing only ilp32d libraries cannot link it.
The optional `ISAAC_GNU_INSTALL_DIR` override is passed through benchmark,
tracing, comparison, selection, and retracing, without replacing the existing
MLonMCU toolchain cache.

```bash
source scripts/env.sh
export CONFIG="$PWD/cfg/flow/paper/cfu_iss_rv32.env"
source "$CONFIG"

# Run once if this separate toolchain is not installed.
mkdir -p "$ISAAC_GNU_INSTALL_DIR"
curl -fL --retry 2 "$GNU_URL" -o /tmp/isaac-cfu-toolchain.tar.xz
tar -xJf /tmp/isaac-cfu-toolchain.tar.xz -C "$ISAAC_GNU_INSTALL_DIR"

./scripts/full_flow.sh embench_iot/crc32 now demo_iss
```

Use a fresh shell or source `scripts/env.sh` and the intended configuration when
switching between presets; the presets export variables into the caller's shell.
Custom operations remain 32-bit even when compressed base instructions are used
by runtime libraries. The initial base ISA is RV32IM with C/Zicsr/Zifencei support
in the ISS and ilp32 firmware; this is not yet a claim of a pinned VexRiscv variant.

## Encoding artifacts

- `work/cfu_manifest.json` is the run's persistent function-ID allocation ledger.
  IDs must survive candidate filtering and selection. Do not delete it while
  reusing generated compiler, simulator, or firmware artifacts.
- `work/gen*/cfu_manifest.json` snapshots the ledger with each generated core.
- `work/gen*/cfu_encoding_validation.json` records an independent check of
  opcode, function ID, register fields, and agreement between combined ETISS and
  split LLVM input artifacts. It does not claim execution validation.
- Benchmark validation and instruction/code-size comparisons use the normal
  demo reports. Inspect `compare_filtered_selected.csv` and the run CSV reports.

The ledger binds each set/instruction name to a source hash with full comment
lines removed, operand mapping, function ID, opcode value, and mask. Reindexing
comments may change after filtering; changes to source behavior or operand
mapping are rejected. One operation consumes one of 1024 IDs even if it has an
unused source field. Unused source fields are encoded as zero.

## Focused verification

```bash
source scripts/env.sh
python3 -m pytest isaac-toolkit/tests/unit-tests/backend/test_cfu_encoding.py -q
```

The tests exercise actual CoreDSL parsing/writing, ID reuse, function-ID bit
mapping, invalid operand/namespace rejection, production core generation, and
detection of a corrupted split-set encoding. The flow invokes the independent
artifact verifier after CFU core generation. Existing configurations retain
their general encoding policy unless `ISAAC_ENCODING_POLICY=cfu` is selected.

Audit compiler output independently using an instruction disassembly exported
by the comparison flow:

```bash
python3 scripts/verify_cfu_disassembly.py \
  --dump "$RUN/run_compare_filtered_selected/1/generic_mlonmcu.dump" \
  --manifest "$RUN/work/gen_filtered_selected/cfu_manifest.json" \
  --output "$RUN/work/cfu_selected_compiler_words.validation.json"
```

Set `RUN` to the run directory. Use `--baseline` with the baseline disassembly
to require zero CUSTOM0 instructions. This checks static words against allocated
IDs and fixed fields, including unused source fields. It requires objdump `-d`
instruction output, and does not establish dynamic usage or functional behavior.

## VexRiscv Verilator evaluation

For a new end-to-end run, use the general CFU preset and named flow:

```bash
source scripts/env.sh
source cfg/flow/paper/cfu_rv32.env
export CFU_PLAYGROUND_DIR=/path/to/CFU-Playground
export CFU_RUNNER=verilator  # alternatively renode or fpga, configured below
./scripts/full_flow.sh embench_iot/crc32 now demo_cfu
```

`demo_cfu` runs the existing ETISS baseline/tracing, candidate discovery,
compiler generation, and ISS-based filtering/selection, then evaluates the
selected set using `CFU_RUNNER` and generates the report. Runner choice currently
affects the final evaluation stage. Optional Verilator retirement traces belong
to that stage and do not replace the initial ETISS discovery trace. Initial
benchmarking/discovery on VexRiscv remains outstanding. Fake-HLS selection costs
also remain in that selection stage; FPGA resource reports come from the later
actual Vivado builds.

`cfu_rv32.env` includes `cfu_iss_rv32.env` internally. Use the former for the
combined flow; the latter remains appropriate for `demo_iss` alone. These are
environment presets, while `demo_cfu` selects the ordered flow steps. Sourcing
an equivalent custom preset is supported if it sets the CFU encoding policy.

Use a CFU-Playground checkout at revision
`7f8ec4147b39db98534f8a10f9ddb1c26aca5648` with its pinned LiteX/Python submodules
initialized, plus Verilator and its native build dependencies. After a CFU ISS
run has produced its compiler, candidate index, and manifest:

```bash
export CFU_PLAYGROUND_DIR=/path/to/CFU-Playground
# Optional: export retirement traces and load them into ISAAC sessions.
export CFU_INSTRUCTION_TRACE=1
./scripts/full_flow.sh embench_iot/crc32 20261021T203031 cfu_0_filtered_selected
```

Use `cfu_0` for the combined candidate set. This initial runner supports Embench
and the local Seal5 compiler layout. It exports a CFU from typed candidate trees,
elaborates the pinned `full+cfu+debug` LiteX SoC, builds baseline and extended
firmware for ROM boot, audits static encodings, and validates both on Verilator.
Unsupported RTL operations fail export. No Nailgun/HLS synthesis is involved.

Results are under `work/cfu_evaluation_filtered_selected/` (or `_combined/`),
including `compare.csv`, per-build source/command provenance, simulator logs,
and cycle/instruction metrics. Counters measure the benchmark call plus counter
read overhead, excluding initialization and validation. Runtime and cache choices
differ from ETISS; compare baseline and extended within the same hardware run.

Optional traces record retirement cycle, PC, and instruction word using the
pinned CPU's writeback firing signal. The loader checks every word against the
firmware disassembly and resolves custom mnemonics using the manifest. Trace
sessions are saved under each build's `trace_session/`. This currently supports
uncompressed RV32IM firmware and does not capture runtime operand or memory
values. Further analysis integration and simulator runners remain in progress.

## Renode functional evaluation

Set `CFU_RUNNER=renode`, `CFU_RENODE_EXECUTABLE` to the portable Renode binary
pinned by CFU-Playground (`1.14.0+20231102git998250fe`), and `CFU_RENODE_VIL` to
the pinned integration sources prepared by CFU-Playground's setup script.
Disable `CFU_INSTRUCTION_TRACE` for this runner. The same `cfu_0` or
`cfu_0_filtered_selected` step then builds a shared Verilated CFU library and
executes the baseline/extended ELF files under Renode CPU emulation. Results go
to a separate `work/cfu_evaluation_*_renode/` directory.

The local UART extension supplies TX-empty consistently with Renode's
synchronous UART model, and a finish-register model verifies firmware reaches
its termination write. Both the benchmark pass marker and finish marker are
required. Execution uses bounded virtual time and a wall-clock timeout.
The pinned emulator lacks `instreth`; the runner supplies a zero high half and
limits virtual execution to less than 40 seconds at 100 MIPS, below 2^32 retired
instructions. Renode results label cycle counts as `model_cycles`; they are
not measurements of VexRiscv RTL timing or FPGA performance.

## Arty A7-100T synthesis and execution

```bash
export CFU_RUNNER=fpga
export CFU_VIVADO=/usr/local/tools/xilinx/Vivado/2024.1/bin/vivado
export CFU_BOARD_SERIAL=210319C0891F
export CFU_SERIAL_PORT=/dev/serial/by-id/usb-Digilent_Digilent_USB_Device_210319C0891F-if01-port0
export CFU_INSTRUCTION_TRACE=0
# Set to 1 to build and report resources without programming the board.
export CFU_SYNTHESIZE_ONLY=1
./scripts/full_flow.sh embench_iot/crc32 20261021T203031 cfu_0_filtered_selected
```

The initial board configuration uses a 50 MHz system clock, 128 KiB on-chip RAM,
and ROM-boot firmware. Baseline uses the matching full CPU without its CFU plugin;
extended uses full+CFU. UART runs at 115200 baud. The hardware model is distinct
from the larger Verilator memory configuration, so compare counters within each
runner. Trace capture is currently Verilator-only.

FPGA results are under `work/cfu_evaluation_*_fpga/`, with placed resource use,
routed timing, hashes, and a whole-SoC baseline comparison. Hierarchical CFU
counts are reported as Vivado attribution; optimization can move logic across
module boundaries. A met clock constraint establishes operation at that clock,
not a measured maximum frequency. Successful builds cache checksummed bitstreams
and reports using tool versions, tracked source differences, RTL/firmware hashes,
CPU/device configuration, and the build driver as inputs.

With synthesis-only disabled, the runner locks the board, opens UART first,
programs volatile SRAM configuration, and requires benchmark validation plus
counter output. It performs no flash writes. The host account must have UART
read/write access. Both CRC32 board variants have now passed physical validation.
The baseline full+debug run reports 5,922,894 cycles and the extended
full+cfu+debug run 5,400,136 cycles. The baseline differs from the earlier
simulator's CFU-capable CPU configuration and memory map; further attribution
is needed before treating that whole difference as an isolated CFU speedup.
The programming runner clears UART output through a handshake immediately
before configuration, avoiding boot output from the previously loaded image
when the FTDI port opens.
