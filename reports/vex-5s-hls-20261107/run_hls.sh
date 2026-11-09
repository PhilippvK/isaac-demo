#!/bin/bash
set -euo pipefail
job=${1:?Choose crc32, branches or stores}
case "$job" in
 crc32) input=crc32; set_name=XISAAC.HLS ;;
 crc32-fixed) input=crc32-fixed; set_name=XISAAC.HLS ;;
 branches) input=branch-probes; set_name=XBRANCH.HLS ;;
 stores) input=store-probes; set_name=XSTOREPROBE.HLS ;;
 stores-fixed) input=store-probes; set_name=XSTOREPROBE.HLS ;;
 *) exit 2 ;;
esac
docker exec "${HLS_CONTAINER:-isaac-vex5-hls}" /isax-tools/hls_script.sh "/experiment/hls-run/$job" "/experiment/hls-inputs/$input" \
 CORE=VEX_5S ISAXES="$set_name" SIM_EN=n OL2_ENABLE=n SKIP_AWESOME_LLVM=y \
 LN_ILP_SOLVER=CBC USE_OL2_MODEL=y CELL_LIBRARY=/experiment/config/compact.yaml \
 CLOCK_TIME=100 SCHEDULE_TIMEOUT=60 REFINE_TIMEOUT=60 \
 SCHED_ALGO_MS=y SCHED_ALGO_PA=y SCHED_ALGO_RA=y SCHED_ALGO_MI=y
