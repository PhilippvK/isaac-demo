# CVA5 on Digilent Arty A7-100

Select the shell in the existing FPGA synthesis flow:

```bash
FPGA_SYN_PYTHON="$PWD/venv/bin/python" FPGA_SYN_BOARD=arty_a7_100 bash scripts/fpga_syn_script.sh \
  OUTPUT_DIR RTL_DIR CVA5 xc7a100tcsg324-1 50
```

`RTL_DIR/files.txt` lists the generated CVA5 core and its extension RTL.
Relative source paths are resolved relative to that file; absolute paths are
also accepted. The `cva5_reuseio_arty_a7_100t` preset selects this board.
Use `cva5_reuseio_mem_branch_arty_a7_100t` to opt into experimental memory
and branch candidates as well. The original `cva5_reuseio` preset uses the
generic FPGA target and disables memory/branch candidates.

The shell derives 20 MHz from the 100 MHz E3 oscillator using an MMCM and
BUFGs. Button 0 (D9, active high) resets the MMCM; core reset is asserted
while unlocked and deasserted through four synchronization stages. UART RX
(A9) and TX (D10) connect to AXI UART Lite at 115200 baud, 8 data bits, no
parity, one stop bit. All package I/O use LVCMOS33. Pin assignments follow
[Digilent's Rev. D/E master XDC](https://github.com/Digilent/digilent-xdc/blob/master/Arty-A7-100-Master.xdc).

The supported CVA5 configuration disables instruction/data caches and the
external instruction bus; the build checks these settings. Their external
AXI ports are inactive and terminated inside the shell. The peripheral AXI
master in the generated CVA5 core issues only single-beat requests
(`ARLEN=AWLEN=0`), so its independent address/data/response channels connect
directly to UART Lite. Burst-capable core configurations require an AXI
protocol converter and are not supported by this shell.

UART Lite registers appear at `0x60000000`:

| Offset | Register |
|---|---|
| 0x0 | Receive FIFO |
| 0x4 | Transmit FIFO |
| 0x8 | Status |
| 0xc | Control |

These registers alias at every 16-byte boundary throughout the configured
peripheral window (currently `0x60000000..0x6fffffff`). Other peripherals,
DDR3 and a runtime firmware loader are not implemented. UART availability
does not make ETISS semihosting firmware work on hardware.

The existing two 256 KiB local memory instances are retained. To initialize
both instruction and data memory from a common linked firmware image, set
`FPGA_SYN_INIT_COE` to an **absolute** Xilinx COE file path. Firmware must be
linked for the core's `0x80000000` reset vector and respect the local memory
capacity. Harvard instruction/data memories are separate copies; dynamic
writes to data RAM do not update instruction RAM. Without an initialization
image the build is suitable for synthesis/physical fit, not workload
execution. No firmware image is supplied by default.

The build retains synthesis and routed checkpoints, utilization, timing,
power and DRC reports and generates `cva5_arty_top.bit`. It does not program
the board. No DRC severity is lowered to force bitstream generation.

UART RX and the reset button are asynchronous inputs and are excluded from
synchronous input timing. The IP synchronizes UART RX; the shell synchronizes
core reset release. UART TX has a conservative zero-delay output constraint
against the board oscillator. This is not an external synchronous AXI timing
budget: AXI stays entirely inside the FPGA.

## Firmware execution

The board preparation step writes corrected copies under `OUTPUT_DIR/board_rtl`:
`CVA5_top.v` converts the generated wrapper's byte addresses to RAM word
indices (`[17:2]`), and `scaiev_unit.sv` uses the active instruction's native
`funct3` for injected memory operations. The latter is required for SB/SH
byte enables, and depends on ISAAC's `scaiev2` encoding policy. The RAM IP
explicitly disables its optional output registers to match CVA5's one-cycle
local-memory interface. Original HLS source files are retained.

Build a freestanding UART/CRC32 image and initialize both memories:

```bash
python3 scripts/fpga_syn/firmware/build.py full /absolute/path/firmware
FPGA_SYN_INIT_COE=/absolute/path/firmware/firmware.coe \
FPGA_SYN_PYTHON="$PWD/venv/bin/python" FPGA_SYN_BOARD=arty_a7_100 \
  bash scripts/fpga_syn_script.sh OUTPUT_DIR RTL_DIR CVA5 xc7a100tcsg324-1 50
```

Firmware variants are `baseline`, `full`, `memory`, `branches`, and `stores`.
The `full` and `memory` variants generate intrinsics from their exact retained
CoreDSL allocations, which differ. These are explicit raw instruction
intrinsics, not automatic compiler selection. The current helper uses the
retained HLS inputs in `reports/cva5-reuseio-hls-20261105`; other allocations
require passing their CoreDSL to `memory_header.py` and rebuilding.

The startup code sets the stack and trap vector, clears BSS, initializes
UART, and reports the Embench CRC32 kernel result (`0x65842ca9`, verification
value 11433). This runtime replaces ETISS semihosting. The GNU toolchain
builds RV32IM/Zicsr/Zifencei ILP32 without an OS or C library.

Capture UART **before** volatile JTAG programming, since firmware prints once:

```bash
python3 scripts/fpga_syn/firmware/run_arty.py \
  OUTPUT_DIR/cva5_arty_top.bit EXECUTION_LOG_DIR \
  --uart-container philippvk/isaac-quickstart-hls:latest
```

The optional container supplies UART access using only the selected device
and its device group, under the host user's UID/GID. Host device permissions
are not changed. Without that option, the host account must have UART access.
Vivado runs on the host and selects the unique serial `210319C08AE1`; override
`--board-serial` and `--port` for a different board. Only FPGA configuration
RAM is programmed; the SPI flash is not written. Raw UART, programming logs
and `execution.json` are retained. A PASS requires successful programming,
the firmware boot banner and completion marker, without a reported trap/fail.

For faster firmware iterations, `firmware/update_init.tcl` synthesizes the
same RAM IP from a new COE, then copies only INIT data/parity properties into
a validated routed checkpoint. It checks all 128 destination primitives,
144 initialization properties per primitive and their width/register/mode
configuration before producing `initialized.dcp` and `firmware.bit`. Run it
in a new output directory with the routed checkpoint and COE as Tcl args.
This preserves the existing logic and routes; it is not an RTL update.
