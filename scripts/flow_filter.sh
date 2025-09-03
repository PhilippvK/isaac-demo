#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

MIN_SEAL5_SCORE=${MIN_SEAL5_SCORE:-0.5}
FILTER_MIN_RUNTIME_REDUCTION_REL=${FILTER_MIN_RUNTIME_REDUCTION_REL:-0.005}
MIN_UTIL_SCORE=${MIN_UTIL_SCORE:-0.005}

# TODO: topk
# TODO: sort?

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}

if [[ "$FINAL" == "1" ]]
then
    echo "Filter FINAL unsupported!"
    exit 1
elif [[ "$PRELIM" == "1" ]]
then
    echo "Filter PRELIM unsupported!"
    exit 1
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    echo "Filter FILTERED2&SELECTED skipped!"
    exit 0
elif [[ "$FILTERED2" == "1" ]]
then
    echo "Filter FILTERED2 skipped!"
    exit 0
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    IN_STAGE="filtered_selected"
    OUT_STAGE="filtered2"
    FILTER_ARGS="--min-util-score ${MIN_UTIL_SCORE}"
elif [[ "$FILTERED" == "1" ]]
then
    IN_STAGE="filtered"
    OUT_STAGE="filtered2"
    FILTER_ARGS="--min-util-score ${MIN_UTIL_SCORE}"
else
    IN_STAGE="default"
    OUT_STAGE="filtered"
    FILTER_ARGS="--min-seal5-score ${MIN_SEAL5_SCORE} --min-runtime-reduction-rel ${FILTER_MIN_RUNTIME_REDUCTION_REL}"
fi
STAGE_IN_DIR=$DIR/$IN_STAGE
STAGE_OUT_DIR=$DIR/$OUT_STAGE
mkdir -p $STAGE_OUT_DIR

# RUN=$DIR/run
# SESS=$DIR/sess
WORK_IN=$STAGE_IN_DIR/work
WORK_OUT=$STAGE_OUT_DIR/work
mkdir -p $WORK_OUT

INDEX_FILE=$WORK_IN/index.yml
OUT_FILE=$WORK_OUT/index.yml

# TODO: topk
# TODO: sort?


# TODO: handle float comparisons

# if [[ "$FILTER_ARGS" == "" ]]
# then
#     echo "Missing FILTER_ARGS!"
#     exit 1
# fi


# TODO: handle float comparisons

python3 scripts/filter_index.py $INDEX_FILE --out $OUT_FILE $FILTER_ARGS --sankey $WORK_OUT/sankey.md

# TODO: names?
python3 scripts/names_helper.py $OUT_FILE --output $WORK_OUT/names.csv
