#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

SESS=$DIR/sess
WORK=$DIR/work

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
    GEN_DIR=$WORK/gen_final/
    INDEX_FILE=$WORK/final_index.yml
    SUFFIX="_final"
elif [[ "$PRELIM" == "1" ]]
then
    GEN_DIR=$WORK/gen_prelim/
    INDEX_FILE=$WORK/prelim_index.yml
    SUFFIX="_prelim"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == 1 ]]
then
    GEN_DIR=$WORK/gen_filtered2_selected/
    INDEX_FILE=$WORK/filtered2_selected_index.yml
    SUFFIX="_filtered2_selected"
elif [[ "$FILTERED2" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered2/
    INDEX_FILE=$WORK/filtered2_index.yml
    SUFFIX="_filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == 1 ]]
then
    GEN_DIR=$WORK/gen_filtered_selected/
    INDEX_FILE=$WORK/filtered_selected_index.yml
    SUFFIX="_filtered_selected"
elif [[ "$FILTERED" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered/
    INDEX_FILE=$WORK/filtered_index.yml
    SUFFIX="_filtered"
else
    GEN_DIR=$WORK/gen/
    INDEX_FILE=$WORK/combined_index.yml
    SUFFIX=""
fi


# TODO: move to flow_analyze_enc.sh
python3 -m isaac_toolkit.utils.analyze_encoding $INDEX_FILE -o $WORK/total_encoding_metrics${SUFFIX}.csv --score $WORK/encoding_score${SUFFIX}.csv

python3 -m isaac_toolkit.generate.ise.generate_cdsl --sess $SESS --workdir $WORK --gen-dir $GEN_DIR --index $INDEX_FILE $FORCE_ARGS
