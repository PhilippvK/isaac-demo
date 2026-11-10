#!/usr/bin/env bash
set -euo pipefail
ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
OUT=${OUT:-$ROOT/reports/vex-arty-fpga-20261110}
MODE=${1:-baseline}
case "$MODE" in
 baseline) RTL=baseline; COE="$OUT/firmware/sine.coe"; DEST=baseline-final ;;
 extended) RTL=crc32-fixed; COE="$ROOT/reports/vex-5s-hls-20261107/firmware/crc32-fixed/firmware.coe"; DEST=extended-crc32 ;;
 *) echo 'Usage: bash run.sh [baseline|extended]' >&2; exit 2 ;;
esac
mkdir -p "$OUT/firmware"
"$ROOT/install/gnu_cfu/bin/riscv32-unknown-elf-objcopy" -O binary "$ROOT/reports/tvmaot-sine-rtl-20261110/vex/generic_mlonmcu" "$OUT/firmware/sine.bin"
python3 scripts/fpga_syn/firmware/bin_to_coe.py "$OUT/firmware/sine.bin" "$OUT/firmware/sine.coe"
FPGA_SYN_INIT_COE="$COE" FPGA_SYN_PYTHON="$ROOT/venv/bin/python" FPGA_SYN_BOARD=arty_a7_100 \
 bash scripts/fpga_syn_script.sh "$OUT/$DEST" "$ROOT/reports/vex-5s-hls-20261107/hls-run/$RTL/VexRiscv_5s" VEX_5S xc7a100tcsg324-1 50
# Programming is separate: use run_arty.py as documented in the board README.
