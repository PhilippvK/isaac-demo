#!/usr/bin/env bash
set -euo pipefail
ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
OUT=${OUT:-$ROOT/reports/vex-fpga-followup-20261110/reproduction}
mkdir -p "$OUT"
python3 scripts/fpga_syn/firmware/build.py full "$OUT/firmware" \
  --core-label VEX_5S --cycle-counter-address 0x60000010 \
  --memory-coredsl reports/vex-5s-hls-20261107/hls-inputs/crc32-fixed/XIsaac.hls.core_desc \
  --memory-names CUSTOM0 CUSTOM5 CUSTOM3 CUSTOM15 CUSTOM16 --crc-index-name CUSTOM2
FPGA_SYN_INIT_COE="$OUT/firmware/firmware.coe" FPGA_SYN_PYTHON="$ROOT/venv/bin/python" \
FPGA_SYN_BOARD=arty_a7_100 bash scripts/fpga_syn_script.sh "$OUT/synthesis" \
  "$ROOT/reports/vex-5s-hls-20261107/hls-run/crc32-fixed/VexRiscv_5s" VEX_5S xc7a100tcsg324-1 50
python3 scripts/fpga_syn/firmware/run_arty.py "$OUT/synthesis/vex_arty_top.bit" \
  "$OUT/board" --boot-banner 'ISAAC VEX_5S BOOT' \
  --uart-container "${FPGA_RUN_UART_CONTAINER:-philippvk/isaac-quickstart-hls:latest}"
