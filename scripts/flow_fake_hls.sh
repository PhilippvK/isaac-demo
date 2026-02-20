#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

WORK=$DIR/work

# TODO: expose
SET_NAME=${ISAAX_SET_NAME:-XIsaac}

FAKE_HLS_ENABLE=${FAKE_HLS_ENABLE:-1}
FAKE_HLS_TOOL=${FAKE_HLS_TOOL:-fake}

PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}
FINAL=${FINAL:-0}

if [[ "$FAKE_HLS_ENABLE" == "0" ]]
then
    echo "FAKE_HLS disabled. Skipping step!"
    exit 0
fi

if [[ "$FINAL" == "1" ]]
then
    GEN_DIR=$WORK/gen_final/
    INDEX_FILE=$WORK/final_index.yml
elif [[ "$PRELIM" == "1" ]]
then
    GEN_DIR=$WORK/gen_prelim/
    INDEX_FILE=$WORK/prelim_index.yml
elif [[ "$FILTERED2" == "1" && "$SELECTED" == 1 ]]
then
    GEN_DIR=$WORK/gen_filtered2_selected/
    INDEX_FILE=$WORK/filtered2_selected_index.yml
elif [[ "$FILTERED2" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered2/
    INDEX_FILE=$WORK/filtered2_index.yml
elif [[ "$FILTERED" == "1" && "$SELECTED" == 1 ]]
then
    GEN_DIR=$WORK/gen_filtered_selected/
    INDEX_FILE=$WORK/filtered_selected_index.yml
elif [[ "$FILTERED" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered/
    INDEX_FILE=$WORK/filtered_index.yml
else
    GEN_DIR=$WORK/gen/
    INDEX_FILE=$WORK/combined_index.yml
fi

# CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}

if [[ $FAKE_HLS_TOOL == "fake" ]]
then
    HLS_FAKE_CORE_NAME=cv32e40p
    SESS=$DIR/sess
    DEST_DIR=$WORK/local/fake_hls
    mkdir -p $DEST_DIR
    FAKE_HLS_STRATEGY=${FAKE_HLS_STRATEGY:-best}

    python3 -m isaac_toolkit.retargeting.fake_hls --sess $SESS --workdir $WORK --set-name $SET_NAME --core $HLS_FAKE_CORE_NAME --index $INDEX_FILE --strategy $FAKE_HLS_STRATEGY
else
    echo "Unsupported FAKE_HLS_TOOL: $FAKE_HLS_TOOL"
    exit 1
fi
# NEW:
# python3 -m isaac_toolkit.retargeting.fake_hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME
