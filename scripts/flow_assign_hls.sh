#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

HLS_ENABLE=${HLS_ENABLE:-1}
if [[ "$HLS_ENABLE" == "0" ]]
then
    echo "HLS disabled. Skipping step!"
    exit 0
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

# RUN=$DIR/run
# SESS=$DIR/sess
WORK=$DIR/work

INDEX_FILE=$WORK/index.yml

DOCKER=$WORK/docker
# TODO: handle local

# TODO: handle sharing and total metrics
python3 scripts/annotate_hls_score.py $INDEX_FILE --inplace --hls-schedules-csv $DOCKER/hls/default/hls_schedules.csv --hls-selected-schedules-yaml $DOCKER/hls/default/output/selected_solutions.yaml
