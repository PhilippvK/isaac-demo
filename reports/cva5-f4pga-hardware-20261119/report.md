# CVA5 F4PGA hardware validation, 2026-11-19

Both completed F4PGA bitstreams pass on Arty A7-100T serial `210319C08AE1`
(`xc7a100t`, 20 MHz core, UART 115200 8N1). Vivado 2024.1 was used only
for JTAG programming; synthesis through bitstream generation used F4PGA.
Programming changed volatile FPGA configuration only; SPI flash was untouched.
The board was left running the five-load design.

| Check | Baseline | Five-load design |
|---|---|---|
| Programming and boot banner | PASS | PASS |
| Firmware scratch RAM check | PASS | PASS |
| CRC32 / verification | 65842ca9 / 00002ca9 | 65842ca9 / 00002ca9 |
| Native/custom load comparisons | — | 1280 passed |
| Native/custom CRC pairs | — | 5 matched |
| Final firmware result | PASS | PASS |

The initial native CRC takes 15396 cycles in both designs. Five-load pair zero
uses 15392 native and 13348 custom cycles, matching frontend simulation. Pairs
1–4 each use 15388 native and 13340 custom cycles, four cycles above simulation
for each path. The steady saving remains 2048 cycles (about 13.31%, 1.154×).
The four-cycle difference has not been diagnosed; exact steady cycle agreement
with simulation is not claimed.

[Structured results](results.json) include cycle differences and SHA-256 hashes
verified against the original [implementation manifests](../cva5-f4pga-20261113/report.md).
The bitstreams remain in that report's baseline and load5 evidence archives.
Raw evidence is retained in [baseline](baseline/uart.log) and
[five-load](load5/uart.log), with execution metadata and Vivado programming logs.

The RAM firmware checks 16 scratch words, and load comparisons exercise a
256-entry CRC table. This does **not** establish full 256 KiB capacity or
cross-bank/boundary correctness on hardware. Dedicated boundary firmware remains
needed. Successful execution also does not resolve the implementation report's
unconstrained timing endpoints or establish complete timing signoff. The
116-instruction design remains unrouted and was not programmed.

## Repeat

On the host with this board connected, use the matching completed build outputs:

```bash
python3 scripts/fpga_syn/firmware/run_arty.py \
  work/f4pga-cva5-baseline-v5/cva5_arty_top.bit /tmp/cva5-baseline-hardware \
  --timeout 120 --uart-container python:3.12-bookworm
python3 scripts/fpga_syn/firmware/run_arty.py \
  work/f4pga-cva5-load5-v2/cva5_arty_top.bit /tmp/cva5-load5-hardware \
  --timeout 120 --uart-container python:3.12-bookworm
```

The container helper runs as the caller with the serial device's group added;
only the selected UART is passed into the container. Initial direct UART access
failed with PermissionError before any programming; the container-assisted runs
above completed successfully. Device discovery and execution required host
access outside the workspace sandbox.
