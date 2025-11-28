#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

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
elif [[ "$PRELIM" == "1" ]]
then
    IN_STAGE="prelim"
    OUT_STAGE="final"
    TOPK=$SELECT_PRELIM_TOPK
    KEEP_NAMES=0
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    IN_STAGE="filtered2_selected"
    OUT_STAGE="final"
    TOPK=$SELECT_PRELIM_TOPK
elif [[ "$FILTERED2" == "1" ]]
then
    IN_STAGE="filtered2"
    OUT_STAGE="filtered2_selected"
    TOPK=$SELECT_FILTERED2_TOPK
elif [[ "$FILTERED" == "1" ]]
then
    IN_STAGE="filtered"
    OUT_STAGE="filtered_selected"
    TOTAL_BENEFIT_FUNC="speedup"
    INSTR_BENEFIT_FUNC="speedup_per_instr"
    HLS_ENABLE=${HLS_ENABLE:-1}
    if [[ "$HLS_ENABLE" == "0" ]]
    then
        INSTR_COST_FUNC="enc_weight_per_instr"
        TOTAL_COST_FUNC="enc_weight_per_instr_sum"
    else
        INSTR_COST_FUNC="hls_area_per_instr"
        TOTAL_COST_FUNC="hls_area_per_instr_sum"
    fi
    TOPK=$SELECT_FILTERED_TOPK
    SPEC_GRAPH=$WORK/$IN_STAGE/spec_graph_filtered.pkl
    SCRIPT=scripts/selection_algo.py
    BENCH_FULL=$(cat $DIR/experiment.ini | grep "benchmark=" | cut -d= -f2)
    # MAX_COST=0.25  # encoding footprint
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
IN_STAGE_DIR=$DIR/$STAGE/
OUT_STAGE_DIR=$DIR/$STAGE/

WORK_IN=$IN_STAGE_DIR/work
WORK_OUT=$OUT_STAGE_DIR/work

INDEX_FILE=$WORK_IN/index.yml
OUT_FILE=$WORK_OUT/index.yml


if [[ "$TOPK" != "0" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --topk $TOPK"
fi

python3 $SCRIPT $INDEX_FILE --out $OUT_FILE $EXTRA_ARGS --sankey $WORK_OUT/sankey.md

NAMES_CSV=$WORK_OUT/names.csv

# TODO expose KEEP_NAMES
if [[ "$KEEP_NAMES" == "1" ]]
then
    python3 scripts/names_helper.py $OUT_FILE --output $NAMES_CSV
else
    python3 scripts/assign_names.py $OUT_FILE --inplace --csv $NAMES_CSV
fi
