# Independent F4PGA / SymbiFlow backend

`FPGA_SYN_TOOL=f4pga` (alias `symbiflow`) selects an independent FPGA
implementation backend in the normal `syn_0` stage. It uses the official XC7
SymbiFlow command interfaces: Yosys synthesis, VPR pack/place/route, FASM and
Project X-Ray bitstream generation. It does not invoke Vivado or LiteX and does
not change the generated core into a CFU Playground SoC.

Supported cores are **VEX_5S and CVA5 on Arty A7-100T**, part
`xc7a100tcsg324-1`, 100 MHz board oscillator and a PLL-generated
20 MHz core clock (50 ns). Other boards/parts/clock periods fail explicitly.
CVA5 additionally needs `sv2v` v0.0.13 and nonempty firmware, as described below.

## Run

Activate a compatible F4PGA XC7 environment with the **full `xc7a100t_test`**
architecture data and Project X-Ray database. It must provide `yosys`, `vpr`
and all six `symbiflow_*` commands. A bare Yosys/nextpnr installation is not
this backend. The command names retain the historical SymbiFlow branding. If the installed
Project X-Ray database is on NFS and `OpenSafeFile` fails with `Bad file descriptor`,
copy its `artix7` directory unchanged onto local storage and export `DATABASE_DIR`
to the local parent directory in the runtime environment script. Project X-Ray
requires exclusive file locks even for reads, which some NFS mounts reject.


```bash
source cfg/flow/paper/vex_5s_arty_a7_100t_f4pga.env
# Optional: source the runtime for each tool invocation.
export FPGA_SYN_F4PGA_ENV_SCRIPT=/absolute/path/to/f4pga-env.sh
# Or run tools through an environment launcher (parsed as argv, never eval):
# export FPGA_SYN_F4PGA_LAUNCHER='conda run --no-capture-output -n xc7'
# Continue the configured experiment through full_flow.sh ... syn_0.
```

The preset disables ASIP synthesis and Nailgun's embedded OpenLane plugin.
Existing baseline/default/shared skip controls and `FPGA_SYN_BASELINE_USE` apply.
`FPGA_SYN_HLS_DIR` overrides the HLS variant root. `FPGA_SYN_OUTPUT_DIR` and
`FPGA_SYN_REPORT_DIR` override work/evidence roots. `FPGA_SYN_F4PGA_TIMEOUT`
sets the total per-design tool timeout, default 7200 seconds.

A standalone build is also supported:

```bash
FPGA_SYN_TOOL=f4pga FPGA_SYN_BOARD=arty_a7_100 \
  bash scripts/fpga_syn_script.sh /absolute/new-output /absolute/rtl \
  VEX_5S xc7a100tcsg324-1 50
```

The RTL directory must contain `files.txt`, `VexRiscv.v` and `Vex_top.sv`.
Sibling `ISAX_*.sv` extension modules and local include headers are copied.
The output must be fresh; intentional baseline reuse validates recorded results
instead of rerunning tools in a directory containing old implementation views.
For a failed final conversion after completed routing, set
`FPGA_SYN_F4PGA_RESUME_ROUTED=1` (or use `run.py --resume-routed`) with the same
runtime environment and inputs. This verifies route completion, input/adapter
hashes, timing and target identity, pins the routed checkpoint, and retries FASM
and bitstream conversion. Original conversion evidence and resume commands are
retained. Changed checkpoints or inputs are rejected.

## Board RTL and firmware

The Vex UART/MMIO shell is retained. The pinned full-100T architecture has a
PLL model but no MMCM model, so staged sources replace the simple MMCM with
PLLE2_ADV (100 MHz × 10 / 50 = 20 MHz, 1 GHz VCO), retaining BUFG feedback and
core clock buffers. Unused dynamic-reconfiguration inputs are tied off. The staged
copies expose the retirement pulse through explicit core/wrapper ports: Yosys
cannot safely synthesize the Vivado shell's cross-hierarchy reference. Source
HLS outputs remain unchanged; original and adapted source hashes are recorded.

`ram.sv` replaces Vivado Block Memory Generator with inferred 64K x 32 block
RAM: synchronous instruction reads and a synchronous, byte-enabled write-first
data port. Accesses use the shell's existing same clock. Simultaneous instruction
fetch and data write to the same address are not a supported self-modifying-code
contract; use separate addresses and the appropriate instruction synchronization.

Set `FPGA_SYN_FIRMWARE_BIN` to a little-endian flat image, or
`FPGA_SYN_INIT_COE` to a hexadecimal COE file. Both are bounded by 256 KiB.
With neither set, RAM is initialized to zeros for implementation/resource
experiments; this is not executable firmware. Firmware is embedded during
synthesis. The Vivado DCP/BRAM-update helper is not used by F4PGA.

The native execution wrapper also accepts `--tool f4pga` or reads
`FPGA_SYN_TOOL=f4pga`. It embeds its firmware and selects openFPGALoader by
default. `--programmer vivado` remains an explicit option. Standalone programming
uses `run_arty.py --programmer openfpgaloader`; it selects the Arty-100 board
and USB serial and configures SRAM only, with UART capture and the existing
board lock. `--openfpgaloader` selects the executable. A current loader with
`--usb-serial-num` is required. No hardware programming is performed by `syn_0`.

## Results and constraints

F4PGA work defaults to `work/docker/fpga_syn_f4pga/` (or `work/local/`), separate
from Vivado. PRELIM/FINAL/FILTERED/FILTERED2/SELECTED and EVAL_SUFFIX selections
are preserved. `fpga_syn_f4pga*/` outside `work/` retains bitstreams, mapped
netlists, staged sources, native logs/constraints, versions, hashes and aggregate
CSV. `report_0` links those measurements. Preserved results can serve as baselines;
changed artifacts or incompatible backend/part/clock/board metadata are rejected.

Mapping/implementation completion is separate from timing closure. Negative
setup slack remains a measured failure; missing hold analysis is `null`, not a
pass. Native hardware execution requires both setup and hold to pass.

The F4PGA XDC contains board pins, I/O standards and the 100 MHz oscillator.
Its synthesis-generated SDC, including the explicit 20 MHz core-net constraint, is
passed explicitly to pack, place and route and verified in the results. Clock
aliases that refer to the same synthesized net bits are deduplicated before VPR;
conflicting periods/waveforms are rejected. FASM conversion uses the official
Python API's explicit genfasm arguments: the console wrapper parses `-s` but
fails to forward it. The adapter forwards `--sdc_file constraints.sdc` and checks
for both implemented logic and BRAM features before allowing bitstream conversion.
An empty or I/O-only FASM result is rejected even if the wrapper returns success.
The native SDC, effective
`constraints.sdc` and `clock-aliases.json` remain separate evidence. Native
VPR setup/hold slack covers constrained paths; asynchronous reset/UART inputs
and UART output have no external timing requirements in this backend. This is
not an identical constraint set to the Vivado board flow or a signoff result.

CSV keeps the existing total/component/overhead columns and adds backend, part,
clock, timing status and `brams_18k_equivalent`. `luts_total` counts F4PGA mapped
LUT atoms before packing (including native `$lut` cells); it is **not equivalent
to Vivado's post-route physical LUT usage**. F4PGA can split a LUT6 into smaller
atoms and pack them together. The exact native primitive histogram and resource
basis are retained. Flattened ISAX/SCAIE-V component counts are unknown, not zero.
The legacy `brams_total` is RAMB18+RAMB36 instances; the new field weights RAMB36
as two 18K blocks. No Fmax search is implemented; explicit period sweeps are needed
for targets that support variable clocks.

## Toolchain provenance

The reference interfaces are the official
[F4PGA examples](https://github.com/chipsalliance/f4pga-examples/blob/main/common/common.mk)
and [F4PGA wrappers](https://github.com/chipsalliance/f4pga/tree/main/f4pga/wrappers).
A pinned Linux x86-64 installer is included:

```bash
bash scripts/fpga_syn/f4pga/install.sh /absolute/dedicated/f4pga /path/to/conda
export FPGA_SYN_F4PGA_ENV_SCRIPT=/absolute/dedicated/f4pga/env.sh
```

It verifies both official architecture archive SHA256s, installs the legacy
2022 VPR/device data, pinned 2023 Yosys/plugins and compatible base ABIs in a separate Conda prefix, and pins the
F4PGA Python wrappers. No system installation or sudo is used. The base
packages include defaults-channel TBB 2020.3, required by this VPR build.
`conda-explicit.txt` and `pip-freeze.txt` retain the resolved environment.
Allow several GiB of disk space, additional working space and sufficient RAM
for the full 100T routing graph. The installer does not install openFPGALoader.

Follow the [official installation guide](https://f4pga.readthedocs.io/en/latest/getting-started.html)
for a compatible XC7 runtime. The device package must be `xc7a100t_test`, not the
Arty-35 default `xc7a50t_test`.

See the committed validation report for the exact tested runtime, installation
attempts, RTL validation and remaining implementation/hardware limitations.

## CVA5

```bash
bash scripts/fpga_syn/f4pga/install_sv2v.sh "$PWD/install/sv2v"
source cfg/flow/paper/cva5_reuseio_arty_a7_100t_f4pga.env
export FPGA_SYN_F4PGA_ENV_SCRIPT=/absolute/path/to/f4pga-env.sh
export FPGA_SYN_F4PGA_SV2V="$PWD/install/sv2v/sv2v-Linux/sv2v"
export FPGA_SYN_FIRMWARE_BIN=/absolute/path/to/cva5-firmware.bin
# Continue through syn_0, or invoke fpga_syn_script.sh with core CVA5.
```

The CVA5 input directory contains its ordered `files.txt` and generated
`CVA5_top.v`; sibling `ISAX_*.sv` files are included. Caches and the instruction
bus must be disabled (`INCLUDE_ICACHE`, `INCLUDE_DCACHE`, `INCLUDE_IBUS` zero).
Supervisor mode/MMUs may remain enabled. Firmware is mandatory because a blank,
read-only instruction memory can optimize away meaningful CPU logic. Both
independent 64K × 32 memories receive the same initial image, matching the
original Vivado flow; each implements synchronous, byte-enabled WRITE_FIRST.

The staged board shell uses the same PLL, pins and reset synchronization as Vex.
An open RTL UART replaces the Vivado AXI UART Lite IP: independent AW/W capture,
held AXI responses, 16-byte TX/RX FIFOs, 115200 baud 8N1, UARTLite offsets
0/4/8/12, byte strobes, FIFO resets, overflow/framing flags and interrupt enable.
Parity is disabled. The interrupt output is a level indicating RX data or an
idle transmitter; it is unconnected in this board shell. Polling firmware is
supported; this is not a drop-in replacement for software relying on UARTLite
interrupt pulse behavior.

CVA5's package/interface RTL is converted with upstream
[sv2v v0.0.13](https://github.com/zachjs/sv2v/releases/tag/v0.0.13).
The installer verifies the pinned release archive SHA-256. Both raw and
normalized converted Verilog are retained: a narrow normalization folds
fully known, in-range literal bit-selects that this sv2v release leaves in its
output and the pinned Yosys cannot parse. No variable selects are rewritten.
Intel `ramstyle` hints are removed from staged sources so they do not force
the Xilinx mapper to find Intel MLAB resources; Xilinx `ram_style` hints remain.
The original generated RTL is preserved and checksummed.

Staged defaults define unused writeback slots and selector padding, absent cache
request fields, and the renamer suppression flag when decoupled writeback/WAW
protection is disabled. Active datapath assignments remain generated by CVA5.
The frontend runs hierarchy, process lowering, flattening and optimization,
then `check -assert`; unresolved drivers or conflicting assignments fail the run.
The existing CVA5 address-unit and injected-memory funct3 adapters are also
applied. These changes are local to the F4PGA target.

Result validation uses core identity as well as backend, part, clock and board;
a Vex baseline cannot be reused as CVA5. CVA5 synthesis support does not enable
the separate Vex runtime-counter/MLonMCU execution adapter in `fpga_syn/run.py`.

The adapter rewrites whole-array RAM initialization as element-wise loops so
sv2v retains inferable memories, rather than packing them into large vectors.
It similarly resets the two multiply-valid entries individually. The preserved
`frontend-netlist.v` is exported after `splitnets -ports`: the pinned Yosys
Verilog writer otherwise mis-emits references to ascending packed arrays, even
though the internal netlist connections are correct. The exporter workaround
is covered by a two-stage pipeline simulation regression.

Each CVA5 local memory is split into two 32K-word banks, initialized from
`firmware-0.hex` and `firmware-1.hex`. These are exact halves of the retained
`firmware.hex`. This avoids the pinned flow's incompatible 64K-depth RAMB36
cascade mapping, which can silently discard half of a large inferred memory.
The mapped result is rejected unless cells belonging to the data RAM provide
at least 256 KiB (64 RAMB36 or the equivalent RAMB18 capacity). Source RAM tests
exercise byte writes and both ends of the address range.

For a CPU/firmware smoke test, use a current Verilator installation from the
completed build directory (so the firmware hex files resolve):

```bash
verilator -cc --exe --build -Wno-fatal --top-module cva5_arty_top \
  frontend-netlist.v /absolute/repo/tests/rtl/cva5_clock_stubs.v \
  /absolute/repo/tests/rtl/cva5_boot.cpp
obj_dir/Vcva5_arty_top
```

The harness decodes the serial TX pin, requires a complete `PASS` line, fails
on a firmware `FAIL` line, and has a ten-million-cycle limit. It provides ideal
clock primitive stubs; it does not verify the PLL or replace post-mapping
memory equivalence and physical FPGA execution tests.
