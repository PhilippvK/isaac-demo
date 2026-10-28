#!/bin/bash
set -e
source "$(dirname "${BASH_SOURCE[0]}")/iss_config.sh"
DIR=$(readlink -f "$1")
WORK=$DIR/work
LABEL=""
if [[ ${FINAL:-0} == 1 ]]; then LABEL=final
elif [[ ${PRELIM:-0} == 1 ]]; then LABEL=prelim
elif [[ ${FILTERED2:-0} == 1 && ${SELECTED:-0} == 1 ]]; then LABEL=filtered2_selected
elif [[ ${FILTERED2:-0} == 1 ]]; then LABEL=filtered2
elif [[ ${FILTERED:-0} == 1 && ${SELECTED:-0} == 1 ]]; then LABEL=filtered_selected
elif [[ ${FILTERED:-0} == 1 ]]; then LABEL=filtered
elif [[ ${MULTI:-0} == 1 ]]; then LABEL=multi
fi
ARGS=()
if [[ -n ${SPIKE_INSTALL_DIR:-} ]]; then ARGS+=(--spike-install-dir "$SPIKE_INSTALL_DIR"); fi
python3 -m isaac_toolkit.retargeting.iss.spike --workdir "$WORK" --label "$LABEL" \
    --spike-core "${ISAAC_CORE_NAME:-XIsaacCore}" --force "${ARGS[@]}"
