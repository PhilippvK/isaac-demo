#!/usr/bin/env bash
# Reproduce independent baseline/CRC32 implementation from retained source RTL.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
REPORT=$ROOT/reports/f4pga-integration-20261112
OUT=${OUT:-$REPORT/reproduction}
: "${FPGA_SYN_F4PGA_ENV_SCRIPT:?Set to the compatible installation env.sh}"
[[ ! -e $OUT ]] || { echo 'Choose a new OUT directory' >&2; exit 2; }
mkdir -p "$OUT/inputs"
tar -xzf "$ROOT/reports/openlane-asip-20261112/rtl-inputs.tar.gz" -C "$OUT/inputs"
ln -s "$OUT/inputs/crc32-fixed" "$OUT/inputs/default"
export ASIP_SYN_ENABLE=0 FPGA_SYN_ENABLE=1 FPGA_SYN_TOOL=f4pga
export FPGA_SYN_BOARD=arty_a7_100 FPGA_SYN_F4PGA_CORE_NAME=VEX_5S
export FPGA_SYN_F4PGA_PART=xc7a100tcsg324-1 FPGA_SYN_F4PGA_CLOCK_NS=50
export FPGA_SYN_SKIP_BASELINE=0 FPGA_SYN_SKIP_DEFAULT=0 FPGA_SYN_SKIP_SHARED=1
export FPGA_SYN_HLS_DIR=$OUT/inputs
export FPGA_SYN_PYTHON=${FPGA_SYN_PYTHON:-$ROOT/venv/bin/python}
bash "$ROOT/scripts/flow_syn.sh" "$OUT"
