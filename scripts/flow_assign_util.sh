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
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}

if [[ "$FINAL" == "1" ]]
then
    INDEX_FILE=$WORK/final_index.yml
    SUFFIX="_final"
elif [[ "$PRELIM" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_index.yml
    SUFFIX="_prelim"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_selected_index.yml
    SUFFIX="_filtered2_selected"
elif [[ "$FILTERED2" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_index.yml
    SUFFIX="_filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_selected_index.yml
    SUFFIX="_filtered_selected"
elif [[ "$FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
    SUFFIX="_filtered"
else
    INDEX_FILE=$WORK/combined_index.yml
    SUFFIX=""
fi

UTIL_SCORE_CSV=$WORK/util_score${SUFFIX}.csv

python3 -m isaac_toolkit.utils.annotate_util_score $INDEX_FILE --inplace --util-score-csv $UTIL_SCORE_CSV
