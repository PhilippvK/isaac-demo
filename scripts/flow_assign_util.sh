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
FILTERED=${FILTERED:-0}

if [[ "$FINAL" == "1" ]]
then
    INDEX_FILE=$WORK/final_index.yml
    SUFFIX="_final"
elif [[ "$PRELIM" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_index.yml
    SUFFIX="_prelim"
elif [[ "$FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
    SUFFIX="_filtered"
else
    INDEX_FILE=$WORK/combined_index.yml
    SUFFIX=""
fi

UTIL_SCORE_CSV=$WORK/util_score${SUFFIX}.csv

python3 scripts/annotate_util_score.py $INDEX_FILE --inplace --util-score-csv $UTIL_SCORE_CSV
