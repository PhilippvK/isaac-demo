#!/bin/bash
set -eo pipefail
REPORT=$(cd -- "$(dirname -- "$0")" && pwd)
REPO=$(cd -- "$REPORT/../.." && pwd)
cd "$REPO"
# The repository environment supplies pandas for hierarchy/metric CSVs.
export PATH="$REPO/venv/bin:/nfs/tools/xilinx/Vivado/2024.1/bin:$PATH"
export FPGA_SYN_BOARD=arty_a7_100
for variant in baseline crc32-scaiev2-final memory-cva5-final branches-fixed store-probes; do
    bash scripts/fpga_syn_script.sh "$REPORT/builds/$variant" \
        "$REPO/reports/cva5-fpga-20261105/$variant" CVA5 xc7a100tcsg324-1 50 \
        > "$REPORT/build-$variant.log" 2>&1
done
python3 "$REPORT/summarize_builds.py"
