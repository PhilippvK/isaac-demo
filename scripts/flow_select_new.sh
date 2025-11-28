#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
PRELIM_FILTERED=${PRELIM_FILTERED-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}

SELECT_TOPK=${SELECT_TOPK:-0}
SELECT_FILTERED_TOPK=${SELECT_FILTERED_TOPK:-0}
SELECT_FILTERED2_TOPK=${SELECT_FILTERED2_TOPK:-0}
SELECT_PRELIM_TOPK=${SELECT_PRELIM_TOPK:-0}
SELECT_PRELIM_FILTERED_TOPK=${SELECT_PRELIM_FILTERED_TOPK:-0}
SELECT_FINAL_TOPK=${SELECT_FINAL_TOPK:-0}

if [[ "$FINAL" == "1" ]]
then
    echo "Select unsupported for FINAL"
    exit 1
elif [[ "$PRELIM_FILTERED" == "1" ]]
then
    IN_STAGE="prelim_filtered"
    OUT_STAGE="final"
    TOPK=$SELECT_PRELIM_FILTERED_TOPK
elif [[ "$PRELIM" == "1" ]]
then
    IN_STAGE="prelim"
    OUT_STAGE="final"
    TOPK=$SELECT_PRELIM_TOPK
elif [[ "$FILTERED2" == "1" ]]
then
    IN_STAGE="filtered2"
    OUT_STAGE="prelim"
    TOPK=$SELECT_FILTERED2_TOPK
elif [[ "$FILTERED" == "1" ]]
then
    echo "Select unsupported for FILTERED"
    exit 1
else
    echo "Select unsupported"
    exit 1
fi
IN_STAGE_DIR=$DIR/$IN_STAGE
OUT_STAGE_DIR=$DIR/$OUT_STAGE

WORK_IN=$IN_STAGE_DIR/work
WORK_OUT=$OUT_STAGE_DIR/work

INDEX_FILE=$WORK_IN/index.yml
OUT_FILE=$WORK_OUT/index.yml


EXTRA_ARGS=""

if [[ "$TOPK" != "0" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --topk $TOPK"
fi

python3 scripts/select_candidates.py $INDEX_FILE --out $OUT_FILE $EXTRA_ARGS --sankey $WORK_OUT/sankey.md

NAMES_CSV=$WORK_OUT/names.csv

python3 scripts/assign_names.py $OUT_FILE --inplace --csv $NAMES_CSV
