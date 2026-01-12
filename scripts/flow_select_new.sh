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
elif [[ "$PRELIM_FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_filtered_index.yml
    OUT_FILE=$WORK/final_index.yml
    TOPK=$SELECT_PRELIM_FILTERED_TOPK
    NEW_SUFFIX="_final"
elif [[ "$PRELIM" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_index.yml
    OUT_FILE=$WORK/final_index.yml
    TOPK=$SELECT_PRELIM_TOPK
    NEW_SUFFIX="_final"
elif [[ "$FILTERED2" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_index.yml
    OUT_FILE=$WORK/prelim_index.yml
    TOPK=$SELECT_FILTERED2_TOPK
    NEW_SUFFIX="_prelim"
elif [[ "$FILTERED" == "1" ]]
then
    echo "Select unsupported for FILTERED"
else
    echo "Select unsupported"
fi


EXTRA_ARGS=""

if [[ "$TOPK" != "0" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --topk $TOPK"
fi

python3 scripts/select_candidates.py $INDEX_FILE --out $OUT_FILE $EXTRA_ARGS --sankey $WORK/sankey${NEW_SUFFIX}.md

NAMES_CSV=$WORK/names${NEW_SUFFIX}.csv

python3 -m isaac_toolkit.utils.assign_names $OUT_FILE --inplace --csv $NAMES_CSV
