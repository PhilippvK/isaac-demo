# CVA5 firmware execution on Arty A7-100

## Verified on the physical FPGA

Board serial `210319C08AE1`, FPGA `xc7a100tcsg324-1`, Vivado 2024.1,
20 MHz core clock, UART 115200 8N1. Programming changes only volatile FPGA
configuration RAM; SPI flash is not written.

| Image | On-board result |
|---|---|
| Baseline | Boot, native RAM checks, CRC32 `0x65842ca9`, verification 11433, PASS |
| Full 116-ISE extension | All five load ISEs across 256 table entries (1280 checks), five matching native/ISE CRC pairs, PASS |
| Store probes | SB/SH/SW, byte/halfword lanes and neighboring words, 48 checks, PASS after width fix |
| Branch probes | Signed displacement export fixed; remaining backward-BGEU stall under investigation |

Latest complete CRC evidence:
[UART](execution/full-final/uart.log), [execution metadata](execution/full-final/execution.json).
Store evidence: [UART](execution/stores-final/uart.log).
Baseline evidence: [UART](execution/baseline-addressed/uart.log).

The final board run on 2026-11-06 restored the validated full CRC32 image
and reproduced every checksum, cycle pair, and PASS above:
[final UART](execution/board-final/uart.log),
[final execution metadata](execution/board-final/execution.json).
The FPGA is left configured with this image; SPI flash remains untouched.

## Hardware cycle comparison

The CRC32 kernel processes the same 1024 BEEBS pseudorandom bytes, with seed
zero and polynomial `0xedb88320`. The checksum matches the Embench CRC32
verification result. The table is initialized before timing; UART output is
outside the measured sections. Hardware `mcycle` supplies cycle counts.

| Pair | Native cycles | Generated load ISE cycles |
|---|---:|---:|
| 0 | 15,392 | 13,348 |
| 1 | 15,384 | 13,336 |
| 2 | 15,384 | 13,336 |
| 3 | 15,384 | 13,336 |
| 4 | 15,384 | 13,336 |

Four steady pairs give **2048 cycles saved, 13.31% cycle reduction,
1.154x speedup**. At 20 MHz that is 0.7692 ms versus 0.6668 ms.
The full CRC32 regression after the memory-width fix reproduces exactly the
same checksums and counts as the earlier successful full-image run.

This is an explicit intrinsic for the generated `CUSTOM17` instruction,
which combines masking, scaling, table addressing and a word load. It is
executed 1024 times per ISE kernel call. GCC 15.1.0 compiles both native and
ISE paths at `-O2`, RV32IM/Zicsr/Zifencei ILP32. This does not measure automatic
LLVM pattern utilization, a retargeted compiler, the full scaled Embench
harness, all 111 arithmetic ISEs, or combined branch/store/CRC instruction sets.

## Runtime fixes

1. **RAM read latency.** The default Block Memory Generator enabled an
   extra primitive output register. CVA5's local-memory data-valid protocol
   expects one synchronous cycle. The synthesis recipe now disables the
   primitive and core output registers explicitly.
2. **RAM address units.** The generated core wrapper exports byte addresses,
   while the RAM IP expects 16-bit word indices. The Arty preparation step
   stages a corrected `CVA5_top.v` using `[17:2]`, with full-width byte wires.
   Original HLS outputs are retained.
3. **Branch immediate decoding.** Legacy HLS CoreDSL omitted signed operand
   declarations, and Treenail packed the encoded branch field without its
   implicit low zero. ISAAC now normalizes its private HLS model to unsigned
   packed fields and reconstructs signed, scaled immediates explicitly in
   behavior. Fixed encoding code and mask are checked unchanged. The new
   RTL includes correct sign extension and the low zero. Compiler/ISS models
   remain the original typed models.
4. **Subword stores.** CVA5's SCAIE-V injected-memory path forced word accesses,
   clearing adjacent bytes on SB/SH. Its staged adapter now derives `fn3`
   from the active instruction. This relies on ISAAC `scaiev2` allocation
   preserving native memory `funct3`. The original failing SB produced
   `0x00000033` instead of `0xa5c36f33`; all 48 lane/neighbor checks now pass.

The adapters are in
[scripts/fpga_syn/boards/arty_a7_100](../../scripts/fpga_syn/boards/arty_a7_100/README.md).
They preserve the raw HLS source and place actual synthesis inputs in each
build's `board_rtl/` directory. Earlier physical-only synthesis results do
not establish firmware execution correctness.

## Branch investigation

- Original HLS branches stopped at the first probe.
- Correct signed/scaled displacements allow all earlier branch types and
  both directions to return correct results, but a taken backward BGEU stops.
- A detailed firmware trace shows 71 correct return values before that call.
  Moving BGEU first reproduces the failure on its first backward call, which
  rules out a simple repeated-execution-count threshold.
- An experimental issue-handshake gate did not fix it and was removed from
  the production preparation step. Its source and bitstreams are retained
  under `experiments/` and `builds/branches-handshake` for review.
- An on-chip ILA snapshot of the halted design records both PC probes at
  word address `0x20000013` (byte address `0x8000004c`, the trap-entry address),
  with both redirect flags low. This locates the stopped state; it does not
  establish the preceding fault or prove that the trap handler executed.
  A delayed-start conditional capture did not produce a transition trace
  within the execution timeout. These debug images are not validated firmware.
- UART diagnostics, failed execution metadata, original and normalized HLS
  inputs, and generated RTL are retained. A complete branch PASS is not claimed.

## Reproduction and artifacts

- [Firmware build/program instructions](../../scripts/fpga_syn/boards/arty_a7_100/README.md#firmware-execution).
- `scripts/fpga_syn/firmware/build.py` emits startup, ELF, disassembly, raw
  binary, 256 KiB COE and source/build manifests for each variant.
- `run_arty.py` opens UART before JTAG configuration and retains raw bytes,
  decoded text, programming logs and `execution.json`. The host account lacks
  UART permissions; a non-root device-scoped Docker helper with the device
  group provides access without changing host permissions.
- `update_init.tcl` supports firmware-only iterations against a routed design.
  It synthesizes the identical RAM IP, validates 64 primitives per bank and
  their configuration, and copies all 144 data/parity initialization
  properties for all 128 destinations. It preserves logic and routes.
- [Results JSON](results.json), [source/firmware/bitstream hashes](sha256.json).
- Validated full-image bitstream:
  `builds/full-final/cva5_arty_top.bit`.
  Validated store image: `builds/stores-sized/cva5_arty_top.bit`.
  Validated baseline: `builds/baseline-addressed/cva5_arty_top.bit`.
- Failed and intermediate images remain explicitly separate. They are not
  substitutes for the validated images above. Reports remain in this repo.
