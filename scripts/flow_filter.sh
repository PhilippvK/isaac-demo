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
#     INDEX_FILE=$WORK/prelim_index.yml
#     OUT_FILE=$WORK/prelim_filtered_index.yml
#     # PREFIX="prelim_"
#     SUFFIX="_prelim"
#     FILTER_ARGS=""
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    # echo "Filter FILTERED2&SELECTED unsupported!"
    echo "Filter FILTERED2&SELECTED skipped!"
    exit 0
elif [[ "$FILTERED2" == "1" ]]
then
    # echo "Filter FILTERED2 unsupported!"
    echo "Filter FILTERED2 skipped!"
    exit 0
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_selected_index.yml
    OUT_FILE=$WORK/filtered2_index.yml
    SUFFIX="_filtered2"
    FILTER_ARGS="--min-util-score ${MIN_UTIL_SCORE}"
elif [[ "$FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
    OUT_FILE=$WORK/filtered2_index.yml
    SUFFIX="_filtered2"
    FILTER_ARGS="--min-util-score ${MIN_UTIL_SCORE}"
else
    INDEX_FILE=$WORK/combined_index.yml
    OUT_FILE=$WORK/filtered_index.yml
    SUFFIX="_filtered"
    FILTER_ARGS="--min-seal5-score ${MIN_SEAL5_SCORE} --min-runtime-reduction-rel ${FILTER_MIN_RUNTIME_REDUCTION_REL}"
fi

# TODO: topk
# TODO: sort?


# TODO: handle float comparisons

# if [[ "$FILTER_ARGS" == "" ]]
# then
#     echo "Missing FILTER_ARGS!"
#     exit 1
# fi


# TODO: handle float comparisons

python3 scripts/filter_index.py $INDEX_FILE --out $OUT_FILE $FILTER_ARGS --sankey $WORK/sankey${SUFFIX}.md

# TODO: names?
python3 -m isaac_toolkit.utils.names_helper $OUT_FILE --output $WORK/names${SUFFIX}.csv
