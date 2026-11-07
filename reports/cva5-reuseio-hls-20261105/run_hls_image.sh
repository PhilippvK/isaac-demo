#!/bin/bash
set -euo pipefail
# An existing dedicated container mounts this report directory at /experiment.
container=${HLS_CONTAINER:-isaac-cva5-hls}
job=${1:?Choose branches, memory, stores or crc32}
case "$job" in
 branches) input=branch-probes; set_name=XBRANCH.HLS; output=branches-fixed ;;
 memory) input=memory-cva5; set_name=XMEMORYCRC32.HLS; output=memory-cva5-final ;;
 stores) input=store-probes; set_name=XSTOREPROBE.HLS; output=store-probes ;;
 crc32) input=crc32-scaiev2-final; set_name=XISAAC.HLS; output=crc32-scaiev2-final ;;
 *) echo "Unknown HLS job: $job" >&2; exit 2 ;;
esac
docker exec "$container" /isax-tools/hls_script.sh "/experiment/hls-run/$output" "/experiment/hls-inputs/$input" \
 CORE=CVA5 ISAXES="$set_name" SIM_EN=n OL2_ENABLE=n SKIP_AWESOME_LLVM=y \
 LN_ILP_SOLVER=CBC USE_OL2_MODEL=y CELL_LIBRARY=/experiment/config/compact.yaml \
 CLOCK_TIME=100 SCHEDULE_TIMEOUT=60 REFINE_TIMEOUT=60 \
 SCHED_ALGO_MS=y SCHED_ALGO_PA=y SCHED_ALGO_RA=y SCHED_ALGO_MI=y
