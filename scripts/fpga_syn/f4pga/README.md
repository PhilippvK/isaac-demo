# Independent F4PGA / SymbiFlow backend

`FPGA_SYN_TOOL=f4pga` (alias `symbiflow`) selects an independent FPGA
implementation backend in the normal `syn_0` stage. It uses the official XC7
SymbiFlow command interfaces: Yosys synthesis, VPR pack/place/route, FASM and
Project X-Ray bitstream generation. It does not invoke Vivado or LiteX and does
not change the generated core into a CFU Playground SoC.

The initial supported configuration is **VEX_5S on Arty A7-100T**, part
`xc7a100tcsg324-1`, 100 MHz board oscillator and a PLL-generated
20 MHz core clock (50 ns). Other boards/parts/clock periods fail explicitly.
CVA5 is not yet supported: its board shell also needs an open AXI UART Lite
replacement and validation of the CVA5 SystemVerilog frontend.

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
