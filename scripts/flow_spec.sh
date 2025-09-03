#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}

if [[ "$FINAL" == "1" ]]
then
    STAGE="final"
elif [[ "$PRELIM" == "1" ]]
then
    STAGE="prelim"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    STAGE="filtered2_selected"
elif [[ "$FILTERED2" == "1" ]]
then
    STAGE="filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    STAGE="filtered_selected"
elif [[ "$FILTERED" == "1" ]]
then
    STAGE="filtered"
else
    STAGE="default"
fi
STAGE_DIR=$DIR/$STAGE

WORK=$STAGE_DIR/work

INDEX_FILE=$WORK/index.yml
SPEC_GRAPH=$WORK/spec_graph.pkl

python3 -m tool.detect_specializations $INDEX_FILE --graph $SPEC_GRAPH --noop
