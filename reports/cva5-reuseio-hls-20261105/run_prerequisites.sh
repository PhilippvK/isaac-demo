#!/bin/bash
set -eo pipefail
cd /var/tmp/ga87puy/isaac-demo-new
source scripts/env.sh
source cfg/flow/paper/cva5_reuseio.env
export MLONMCU_HOME=$PWD/reports/cva5-reuseio-hls-20261105/environment
export MPLCONFIGDIR=$PWD/reports/cva5-reuseio-hls-20261105/matplotlib
export LLVM_INSTALL_DIR=$PWD/llvm-project-22/build
export ISAAC_GNU_INSTALL_DIR=$PWD/install/gnu_cfu
export CCACHE=0 BACKEND=none
export MEMGRAPH_HOST=127.0.0.1 MEMGRAPH_PORT=7687
export ISAAC_LOG_LEVEL=info ISAAC_PROGRESS=0
run=$PWD/reports/cva5-reuseio-hls-20261105/runs/crc32/20261105T120000
for stage in load analyze pick; do
 bash "scripts/flow_isaac_${stage}.sh" "$run" > "reports/cva5-reuseio-hls-20261105/${stage}.log" 2>&1
done
