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

ENC_WEIGHT=${ENC_WEIGHT:-1.0}
UTIL_WEIGHT=${UTIL_WEIGHT:-1.0}

# --runtime-weight $RUNTIME_WEIGHT --code-size_weight $CODE_SIZE_WEIGHT

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}

if [[ "$FINAL" == "1" ]]
then
    echo AAA
    INDEX_FILE=$WORK/final_index.yml
    # PREFIX="final_"
    EXTRA_ARGS="--final"
elif [[ "$PRELIM" == "1" ]]
then
    echo BBB
    INDEX_FILE=$WORK/prelim_index.yml
    # PREFIX="prelim_"
    EXTRA_ARGS="--prelim --util-weight $UTIL_WEIGHT --enc-weight $ENC_WEIGHT"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    echo CCC
    INDEX_FILE=$WORK/filtered2_selected_index.yml
    # PREFIX="prelim_"
    EXTRA_ARGS="--prelim --util-weight $UTIL_WEIGHT --enc-weight $ENC_WEIGHT"
elif [[ "$FILTERED2" == "1" ]]
then
    echo DDD
    INDEX_FILE=$WORK/filtered2_index.yml
    # PREFIX="filtered2_"
    EXTRA_ARGS="--filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    echo EEE
    INDEX_FILE=$WORK/filtered_selected_index.yml
    # PREFIX="filtered_"
    EXTRA_ARGS="--filtered"
elif [[ "$FILTERED" == "1" ]]
then
    echo FFF
    INDEX_FILE=$WORK/filtered_index.yml
    # PREFIX="filtered_"
    EXTRA_ARGS="--filtered"
else
    echo GGG
    INDEX_FILE=$WORK/combined_index.yml
    # PREFIX=""
    EXTRA_ARGS=""
fi

python3 scripts/annotate_score.py $INDEX_FILE --inplace $EXTRA_ARGS
