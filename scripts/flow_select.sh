#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

# RUN=$DIR/run
# SESS=$DIR/sess
WORK=$DIR/work

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
# PRELIM_FILTERED=${PRELIM_FILTERED-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}

SELECT_TOPK=${SELECT_TOPK:-0}
SELECT_FILTERED_TOPK=${SELECT_FILTERED_TOPK:-0}
SELECT_FILTERED2_TOPK=${SELECT_FILTERED2_TOPK:-0}
SELECT_PRELIM_TOPK=${SELECT_PRELIM_TOPK:-0}
# SELECT_PRELIM_FILTERED_TOPK=${SELECT_PRELIM_FILTERED_TOPK:-0}
SELECT_FINAL_TOPK=${SELECT_FINAL_TOPK:-0}

EXTRA_ARGS=""

SCRIPT=scripts/select_candidates.py
KEEP_NAMES=1
if [[ "$FINAL" == "1" ]]
then
    echo "Select unsupported for FINAL"
# elif [[ "$PRELIM_FILTERED" == "1" ]]
# then
#     INDEX_FILE=$WORK/prelim_filtered_index.yml
#     OUT_FILE=$WORK/final_index.yml
#     TOPK=$SELECT_PRELIM_FILTERED_TOPK
#     NEW_SUFFIX="_final"
elif [[ "$PRELIM" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_index.yml
    OUT_FILE=$WORK/final_index.yml
    TOPK=$SELECT_PRELIM_TOPK
    NEW_SUFFIX="_final"
    KEEP_NAMES=0
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_selected_index.yml
    OUT_FILE=$WORK/final_index.yml
    TOPK=$SELECT_PRELIM_TOPK
    NEW_SUFFIX="_final"
elif [[ "$FILTERED2" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_index.yml
    OUT_FILE=$WORK/filtered2_selected_index.yml
    TOPK=$SELECT_FILTERED2_TOPK
    NEW_SUFFIX="_filtered2_selected"
elif [[ "$FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
    OUT_FILE=$WORK/filtered_selected_index.yml
    TOPK=$SELECT_FILTERED_TOPK
    NEW_SUFFIX="_filtered_selected"
    SPEC_GRAPH=$WORK/spec_graph_filtered.pkl
    SCRIPT=scripts/selection_algo.py
    BENCH_FULL=$(cat $DIR/experiment.ini | grep "benchmark=" | cut -d= -f2)
    # MAX_COST=0.25  # encoding footprint
    TOTAL_BENEFIT_FUNC="speedup"
    INSTR_BENEFIT_FUNC="speedup_per_instr"
    INSTR_COST_FUNC="hls_area_per_instr"
    TOTAL_COST_FUNC="hls_area_per_instr_sum"
    # STOP_BENEFIT=""
    # STRATEGY=""
    # EXTRA_ARGS="$EXTRA_ARGS --spec-graph $SPEC_GRAPH --benchmark $BENCH_FULL --use-mlonmcu --max-cost $MAX_COST --instr-cost-func $INSTR_COST_FUNC --total-cost-func $TOTAL_COST_FUNC --instr-benefit-func $INSTR_BENEFIT_FUNC --total-benefit-func $TOTAL_BENEFIT_FUNC"
    EXTRA_ARGS="$EXTRA_ARGS --spec-graph $SPEC_GRAPH --benchmark $BENCH_FULL --use-mlonmcu --instr-cost-func $INSTR_COST_FUNC --total-cost-func $TOTAL_COST_FUNC --instr-benefit-func $INSTR_BENEFIT_FUNC --total-benefit-func $TOTAL_BENEFIT_FUNC"
    if [[ "$VERBOSE" == "1" ]]
    then
        EXTRA_ARGS="$EXTRA_ARGS --log debug"
    fi
else
    echo "Select unsupported"
fi

if [[ "$TOPK" != "0" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --topk $TOPK"
fi

python3 $SCRIPT $INDEX_FILE --out $OUT_FILE $EXTRA_ARGS --sankey $WORK/sankey${NEW_SUFFIX}.md

NAMES_CSV=$WORK/names${NEW_SUFFIX}.csv

# TODO expose KEEP_NAMES
if [[ "$KEEP_NAMES" == "1" ]]
then
    python3 -m isaac_toolkit.utils.names_helper $OUT_FILE --output $NAMES_CSV
else
    python3 -m isaac_toolkit.utils.assign_names $OUT_FILE --inplace --csv $NAMES_CSV
fi
