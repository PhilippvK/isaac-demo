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
DOCKER=$WORK/docker

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}

if [[ "$FINAL" == "1" ]]
then
    INDEX_FILE=$WORK/final_index.yml
    # SUFFIX="_final"
    SUFFIX=""
elif [[ "$PRELIM" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_index.yml
    # SUFFIX="_prelim"
    SUFFIX=""
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_selected_index.yml
    # SUFFIX="_filtered2_selected"
    SUFFIX=""
elif [[ "$FILTERED2" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_index.yml
    # SUFFIX="_filtered2"
    SUFFIX=""
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_selected_index.yml
    # SUFFIX="_filtered_selected"
    SUFFIX=""
elif [[ "$FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
    # SUFFIX="_filtered"
    SUFFIX=""
else
    INDEX_FILE=$WORK/combined_index.yml
    SUFFIX=""
fi

# TODO: handle sharing and total metrics
python3 scripts/annotate_hls_score.py $INDEX_FILE --inplace --hls-schedules-csv $DOCKER/hls${SUFFIX}/default/hls_schedules.csv --hls-selected-schedules-yaml $DOCKER/hls${SUFFIX}/default/output/selected_solutions.yaml
