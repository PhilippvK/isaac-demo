# CVA5 Arty A7-100 board identification

Board target: `xc7a100tcsg324-1`. The previous synthesis report used
`xc7a200tffv1156-1`; its placement, timing and device utilization percentages
must not be treated as Arty results.

Host USB inspection confirms VID:PID `0403:6010`, serial `210319C08AE1`,
interface 0 at `/dev/ttyUSB0` and interface 1 at `/dev/ttyUSB1`.
Use the stable interface-1 path recorded in the [board metadata](../../cfg/fpga/boards/arty_a7_100.json)
for UART; interface 0 is used for JTAG. Presence of a UART device does not
establish that the currently loaded gateware implements a UART.

[Digilent master constraints](https://github.com/Digilent/digilent-xdc/blob/master/Arty-A7-100-Master.xdc)
identify a 100 MHz oscillator at E3, FPGA UART TX at D10, and FPGA UART RX at
A9, all LVCMOS33. The intended 20 MHz core clock requires clock generation
from that oscillator; applying a 50 ns constraint directly to the 100 MHz
board input would be incorrect.

Read-only Vivado JTAG discovery confirmed target
`Digilent/210319C08AE1A` and device `xc7a100t_0` (`PART=xc7a100t`).
The connection was closed without programming.

## Required integration

The existing generated `cva5_top` exposes 380 I/O signals including two AXI
interfaces. It is a synthesis harness, not an Arty SoC top. The board build
requires an internal AXI interconnect/termination with UART, synchronized
reset and clock generation, and initialized instruction/data memories or a
firmware loader. A part/pin substitution alone is insufficient. The existing
core configuration resets at `0x80000000`; firmware must match that map.

The earlier design consumes 130 BRAM36-equivalent tiles; the Arty A7-100 has
135. Memory usage is therefore close to capacity before adding a loader or
other board logic. A fresh implementation is needed on the actual target.

The JSON metadata records the identified target and pins; it is not yet
consumed by the generic CVA5 synthesis flow. No board bitstream was built or
programmed during identification. Read-only JTAG probe logs are retained
alongside this report.

## Board implementation follow-up

The required shell, clocking, UART and constraints have now been implemented.
See [actual Arty implementation results](build-results.md) and the
[reusable board shell](../../scripts/fpga_syn/boards/arty_a7_100/README.md).
The integration requirements above describe the state at identification.
