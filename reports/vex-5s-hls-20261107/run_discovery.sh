#!/bin/bash
set -eo pipefail
cd /var/tmp/ga87puy/isaac-demo-new
source scripts/env.sh
source cfg/flow/paper/vex_5s_mem_branch.env
report=$PWD/reports/vex-5s-hls-20261107
export MLONMCU_HOME=$report/environment MPLCONFIGDIR=$report/matplotlib
export LLVM_INSTALL_DIR=$PWD/llvm-project-22/build ISAAC_GNU_INSTALL_DIR=$PWD/install/gnu_cfu
export CCACHE=0 BACKEND=none USE_MLONMCU_DOCKER=0 USE_MLONMCU_MIN_DOCKER=0
export MEMGRAPH_HOST=127.0.0.1 MEMGRAPH_PORT=7687
export ISAAC_LOG_LEVEL=info ISAAC_PROGRESS=0 FORCE_PURGE_DB=0
run=${RUN_DIR:-$report/runs/crc32/$(date -u +%Y%m%dT%H%M%S)}
mkdir -p "$run"
for stage in trace isaac_load isaac_analyze isaac_pick; do
 echo "START $stage"
 bash "scripts/flow_${stage}.sh" "$run" > "$report/${stage}.log" 2>&1
 echo "DONE $stage"
done
# Preserve the complete report and enforce errors for every queried block.
label=isaac-demo-$(basename "$(dirname "$run")")-$(basename "$run")
python3 -m isaac_toolkit.generate.cdfg.memgraph --sess "$run/sess" --label "$label" --stage 32 > "$report/cdfg-generate.log" 2>&1
python3 "$report/annotate_selected.py" "$run" > "$report/selected-validation.log" 2>&1
for stage in query generate etiss; do
 bash "scripts/flow_isaac_${stage}.sh" "$run" > "$report/isaac_${stage}.log" 2>&1
done
printf 'RUN_DIR=%s\n' "$run"
