#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
REPORT=$ROOT/reports/openlane-asip-20261112
TOOL=${1:-librelane}
case "$TOOL" in librelane|ol2|openlane2) ;; *) echo 'Usage: run.sh [librelane|ol2]' >&2; exit 2 ;; esac
OUT=${OUT:-$REPORT/reproduction-$TOOL}
mkdir -p "$OUT/hls"
tar -xzf "$REPORT/rtl-inputs.tar.gz" -C "$OUT/hls"
ln -s "$OUT/hls/crc32-fixed" "$OUT/hls/default"
export ASIP_SYN_ENABLE=1 ASIP_SYN_TOOL=$TOOL FPGA_SYN_ENABLE=0
export ASIP_SYN_SKIP_BASELINE=0 ASIP_SYN_SKIP_DEFAULT=0 ASIP_SYN_SKIP_SHARED=1
export ASIP_SYN_OL2_CORE_NAME=VEX_5S ASIP_SYN_OL2_PDK=sky130A ASIP_SYN_OL2_CLOCK_NS=10
export ASIP_SYN_OL2_PDK_ROOT=${ASIP_SYN_OL2_PDK_ROOT:-$ROOT/install/asip-pdks}
export ASIP_SYN_PYTHON=${ASIP_SYN_PYTHON:-$ROOT/venv/bin/python}
export ASIP_SYN_HLS_DIR=$OUT/hls
if [[ $TOOL == librelane && -z ${ASIP_SYN_OL2_COMMAND:-} && -z ${ASIP_SYN_OL2_DOCKER_IMAGE:-} ]]; then
    export ASIP_SYN_OL2_DOCKER_IMAGE=ghcr.io/librelane/librelane@sha256:4bc9042ba177f73f275b5b39e7d372a07d3f4043f548a0ba7f640097b7205051
fi
bash "$ROOT/scripts/flow_syn.sh" "$OUT"
