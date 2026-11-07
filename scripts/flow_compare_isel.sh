#!/bin/bash
# Reuse the discovered instruction set; compare selectors during evaluation.
set -euo pipefail
DIR=$(readlink -f "$1")
for variant in dag gisel; do
    if [[ "$variant" == gisel ]]; then selector=1; else selector=0; fi
    for stage in compare retrace reanalyze; do
        GLOBAL_ISEL=$selector ISAAC_ISEL=$variant ISEL_VARIANT=$variant \
            bash "$(dirname "${BASH_SOURCE[0]}")/flow_${stage}.sh" "$DIR"
    done
done
suffix=""
if [[ ${FINAL:-0} == 1 ]]; then suffix=_final
elif [[ ${PRELIM:-0} == 1 ]]; then suffix=_prelim
elif [[ ${FILTERED2:-0} == 1 && ${SELECTED:-0} == 1 ]]; then suffix=_filtered2_selected
elif [[ ${FILTERED2:-0} == 1 ]]; then suffix=_filtered2
elif [[ ${FILTERED:-0} == 1 && ${SELECTED:-0} == 1 ]]; then suffix=_filtered_selected
elif [[ ${FILTERED:-0} == 1 ]]; then suffix=_filtered
fi
python3 "$(dirname "${BASH_SOURCE[0]}")/compare_isel_results.py" \
    --dag "$DIR/sess_new${suffix}_isel_dag" \
    --gisel "$DIR/sess_new${suffix}_isel_gisel" \
    --output "$DIR/isel-comparison${suffix}.json"
