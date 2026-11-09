# VEX_5S without reuse-I/O: CRC32 HLS and RTL execution

Experiment started 2026-11-07; backend repair and final RTL runs completed
2026-11-09. Target: Nailgun's `VEX_5S` / SCAIE-V's `VexRiscv_5s`.
**Real HLS and functional generated-core RTL execution passed. No FPGA synthesis
or physical Vex execution was performed. The board's CVA5 image was untouched.**

## Configuration and discovery

The original `vex_5s` query policy is unchanged. New opt-in preset:
`cfg/flow/paper/vex_5s_mem_branch.env`, with separate query and Toolkit YAML.
Reuse-I/O is disabled, `max_inout_operands=0`, and all 32 discovered candidates
use separate input/output operand fields. No candidate has an INOUT operand.
SCAIE-V allocation preserves native memory funct3 and checks decoder collisions.
ASIP/FPGA synthesis and OpenLane implementation are disabled; CBC schedules
against the compact operator model at a 100 ns target period.

CRC32 was compiled/traced freshly using LLVM22 SelectionDAG and RV32IM with
Zicsr/Zifencei. ETISS functional validation passed. Discovery selected two
blocks and produced **27 arithmetic and five load candidates**. Compare with
116 candidates in the prior reuse-I/O experiment only as a discovery count,
not as a controlled core-performance comparison.

Both selected blocks pass BB identity/count validation within the existing
configured tolerance. Two unselected frame-heavy blocks fail the full count
check; these are retained in `bb-validation-all.csv`, and strict error checking
is enforced on every selected block before querying. No shared database purge
was performed. See `selected-validation.log` and `bb-validation-selected.csv`.

CRC32 did not produce a supported effect-only branch. Six arithmetic/branch
probes and three XOR/store probes are separate supplemental instruction sets;
they are not claimed as discovered CRC32 instructions or merged encodings.

## Functional results

Icarus executes the generated SCAIE-V-integrated Vex core and extension RTL,
with AHB RAM, an emulated UART register interface, and a wrapper cycle counter.
Firmware uses real encoded instructions. These are not ISS-only checks.

| Image / checks | No extra data wait | One data wait |
|---|---|---|
| Baseline RAM and native CRC32 | PASS | Native CRC passes in each extended image |
| Full 32-instruction CRC32 set | 1280 load checks, x0 check, five matching CRC pairs PASS | Same checks PASS |
| Six branch probes | 1344 checks PASS (16 repetitions) | 1344 checks PASS |
| SB/SH/SW probes | 48 injected checks + six native lane checks PASS after fix | Same checks PASS |
| Original store RTL, control | FAIL at SB lane 1 | FAIL at SB lane 1 |

Every CRC checksum is `0x65842ca9`, Embench verification 11433. All five
load ISEs are exercised across all 256 table entries. The x0 check attempts
to write the nonzero value of table entry 1 through a load ISE to register zero
and observes zero afterwards.

Branch cases cover BEQ/BNE/BLT/BGE/BLTU/BGEU, taken/not-taken, signed and
unsigned boundary inputs, and forward/backward displacement. **Backward BGEU
passes on Vex**, unlike the unresolved CVA5 case. This does not fix CVA5.
Only the five load instructions in the full 32-instruction set were explicitly
exercised; the other 27 arithmetic ISEs are integrated but not individually
functionally validated. Spawn/decoupled memory is not covered.

## Performance: fewer instructions, no cycle reduction

The same GCC 15.1.0 `-O2` firmware processes 1024 BEEBS pseudorandom bytes
(seed zero, polynomial `0xedb88320`). Native and explicit `CUSTOM0` kernels
run on the same extended Vex core, with five paired repetitions. This does not
measure automatic LLVM pattern selection or full scaled Embench execution.

Retirement observations use `writeBack_arbitration_isFiring`, actual function
address ranges from the ELF, and the returning instruction. Each ISE kernel
retires **1024 CUSTOM0 instructions**.

| Kernel metric | Native | ISE |
|---|---:|---:|
| Retired instructions | 13,325 | 10,253 |
| Retirement interval, zero extra data wait | 15,374 cycles | 15,374 cycles |
| Retirement interval, one data wait | 16,398 cycles | 16,398 cycles |
| Timer measurement, zero extra data wait | 15,383 cycles | 15,384 cycles |
| Timer measurement, one data wait | 16,408 cycles | 16,409 cycles |

**3072 fewer retired instructions (23.05%), essentially identical cycles.**
The ISE has 3072 additional non-retirement cycles over the same retirement
interval, offsetting the three instructions saved per iteration. Timer readings
include caller/boundary overhead and differ by one cycle. No meaningful speedup
or slowdown is established by that one-cycle difference.

The bundled Vex configuration returns zero for `mcycle`. Firmware therefore
reads the simulation wrapper's counter at `0x60000010`; direct retirement
observations independently confirm the result. UART output/table initialization
are outside the measured kernels. These are cycle counts under the documented
AHB model, not FPGA timing, area, or wall-clock board measurements.

## Backend issues found and fixed

### Unwanted destination-read port despite no reuse-I/O

The original HLS export has `if (rd != 0) X[rd] = result`. HLS implements the
other branch by reading the old destination, creating an `RdRD` interface.
Vex rejects it because that port is unsupported. Initial failure is retained in
`hls-crc32.log` and `hls-run/crc32/`.

Toolkit now has explicit `--hls-core-discards-x0-writes` support. It removes
only canonical zero-write guards in a private HLS model and rejects genuine
destination reads. Compiler/ISS behavior and instruction bits remain unchanged.
The Vex decoder itself suppresses x0 writes (`RegFilePlugin.scala`), and the
nonzero-result x0 firmware probe passes. `XIsaac.hls_core_contract.json` records
all 32 removed guards. The fixed HLS YAML contains no `RdRD` interface.
The option is off by default; Vex's preset enables it, CVA5 reuse-I/O resets it.

### Injected subword stores lacked native bus formatting

SCAIE-V's Vex generator passed `WrMem` data straight to DBusSimpleBus. Native
Vex stores repeat byte/halfword values across the 32-bit bus before byte-lane
selection. The injected path did not, so SB lane 1 wrote zero: got
`0xa5c30018` instead of `0xa5c35418`.

`cfg/hls/patches/scaiev-vex-subword-stores.patch` changes the generator to use
native-style byte/halfword replication. The local patched image is built with
`docker/Dockerfile_hls_vex`. HLS was rerun through that image; the passing RTL
is regenerated from the patched Java source, not patched in the testbench.

The unpatched control and patched run load **identical firmware memory bytes**
(SHA256 `6c6becc14856b7fe9ab75dbf086d7d4534e7791505966b7f858bc9b2315f6a50`
for the raw binary). Both pass the six native lane checks; only patched RTL
passes all 48 injected checks. ELF metadata hashes differ, but loaded code/data
bytes are identical. The result also passes with a data wait state.

Upstream the generator patch to the SCAIE-V repository containing
`src/scaiev/backend/VexRiscv.java`. The expression also covers spawn generation,
but spawn behavior was not tested. Toolkit's x0 contract is a separate change.

## Reproduction and artifacts

- `run_discovery.sh`: fresh trace, analysis, strict selected-BB validation,
  queries, CoreDSL generation, constrained encoding and private HLS export.
  Needs the existing local tool installations and localhost Memgraph access.
  It creates a new timestamp unless `RUN_DIR` is supplied. Names/encodings
  from a fresh discovery may differ; the retained HLS fixtures below are the
  exact inputs for the recorded firmware experiment.
- `hls-inputs/`: original and fixed 32-instruction sets, plus separate branch
  and store probe sets. `run_hls.sh` drives the actual image entrypoint.
- Base image digest:
  `philippvk/isaac-quickstart-hls@sha256:40e063cb86db7a6c36c5c1f11a412506a6866423df06087a36e82ba598d54c79`.
  The corrected store image is `isaac-quickstart-hls-vex5:local`; image IDs and
  generator patch hashes are in `image-versions.json`.
- Build the patched image from the repository root:
  `docker build -f docker/Dockerfile_hls_vex -t isaac-quickstart-hls-vex5:local .`.
  The experimental preset selects it; override with `VEX5_HLS_IMAGE`.
- `sim/run.py` builds exact firmware, compiles generated RTL, runs it, and
  retains logs, hashes and `execution.json`. Examples:

```sh
python3 reports/vex-5s-hls-20261107/sim/run.py crc32-fixed
python3 reports/vex-5s-hls-20261107/sim/run.py crc32-fixed --data-wait 1
python3 reports/vex-5s-hls-20261107/sim/run.py branches --branch-repeats 16 --data-wait 1
python3 reports/vex-5s-hls-20261107/sim/run.py stores-fixed
```

`results.json` contains numerical results, HLS latencies/IIs and all execution
outcomes, including failed controls. Firmware sources/manifests, source patches,
selected RTL and logs are committed; bulk traces, compiler caches and simulation
executables stay local. `selected-generated-rtl.tar.gz` restores its original
repository-relative paths with `tar -xzf` from the repo root.

## Saved commits and upstreaming

- Toolkit `723433e`: explicit x0-safe HLS writeback contract. The incremental
  `isaac-toolkit.bundle` and mail patch preserve it against Toolkit `4e9da97`.
- Demo `3f38b1a`: isolated Vex effect preset, local patched HLS image, portable
  SCAIE-V generator patch, and core-specific contract settings. Original query
  policies and generic FPGA defaults are preserved.
- Demo `5c53904`: target labels, cycle-counter selection, instruction-role
  mapping, x0 probe and native lane controls in the execution firmware.
- A subsequent evidence commit contains this report and selected artifacts.
  Nothing was pushed. Upstream Toolkit and the SCAIE-V Java backend changes
  separately; the demo keeps the patch until the HLS image includes it.

The completed experiment containers were stopped. The corrected local image
and committed inputs allow regeneration; neither the stock image nor the
physical board configuration was changed.
