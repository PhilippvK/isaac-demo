#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

FORCE_ARGS=""

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

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
elif [[ "$FILTERED2" == "1" && "$SELECTED" == 1 ]]
then
    STAGE="filtered2_selected"
elif [[ "$FILTERED2" == "1" ]]
then
    STAGE="filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == 1 ]]
then
    STAGE="filtered_selected"
elif [[ "$FILTERED" == "1" ]]
then
    STAGE="filtered"
else
    STAGE="default"
fi
DEFAULT_STAGE_DIR=$DIR/default
STAGE_DIR=$DIR/$STAGE

SESS=$DEFAULT_STAGE_DIR/sess
WORK=$STAGE_DIR/work

GEN_DIR=$WORK/gen
INDEX_FILE=$WORK/index.yml


# TODO: move to flow_analyze_enc.sh
python3 scripts/analyze_encoding.py $INDEX_FILE -o $WORK/total_encoding_metrics.csv --score $WORK/encoding_score.csv

python3 -m isaac_toolkit.generate.ise.generate_cdsl --sess $SESS --workdir $WORK --gen-dir $GEN_DIR --index $INDEX_FILE $FORCE_ARGS
