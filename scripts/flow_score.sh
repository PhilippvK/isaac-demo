#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

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
    STAGE="final"
    EXTRA_ARGS="--final"
elif [[ "$PRELIM" == "1" ]]
then
    STAGE="prelim"
    INDEX_FILE=$WORK/prelim_index.yml
    EXTRA_ARGS="--prelim --util-weight $UTIL_WEIGHT --enc-weight $ENC_WEIGHT"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    STAGE="filtered2_selected"
    EXTRA_ARGS="--prelim --util-weight $UTIL_WEIGHT --enc-weight $ENC_WEIGHT"
elif [[ "$FILTERED2" == "1" ]]
then
    STAGE="filtered2"
    EXTRA_ARGS="--filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    STAGE="filtered_selected"
    EXTRA_ARGS="--filtered"
elif [[ "$FILTERED" == "1" ]]
then
    STAGE="filtered"
    EXTRA_ARGS="--filtered"
else
    STAGE="default"
    EXTRA_ARGS=""
fi
STAGE_DIR=$DIR/$STAGE

# RUN=$STAGE_DIR/run
# SESS=$STAGE_DIR/sess
WORK=$STAGE_DIR/work

INDEX_FILE=$WORK/index.yml

python3 scripts/annotate_score.py $INDEX_FILE --inplace $EXTRA_ARGS
