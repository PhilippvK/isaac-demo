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

USE_SEAL5_DOCKER=${USE_SEAL5_DOCKER:-1}
if [[ "$USE_SEAL5_DOCKER" == "1" ]]
then
  DOCKER_DIR=$WORK/docker
else
  DOCKER_DIR=$WORK/local
fi

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}

if [[ "$FINAL" == "1" ]]
then
    INDEX_FILE=$WORK/final_index.yml
    DEST_DIR=$DOCKER_DIR/seal5_final/
elif [[ "$PRELIM" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_index.yml
    DEST_DIR=$DOCKER_DIR/seal5_prelim/
elif [[ "$FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
    DEST_DIR=$DOCKER_DIR/seal5_filtered/
else
    INDEX_FILE=$WORK/combined_index.yml
    DEST_DIR=$DOCKER_DIR/seal5/
fi

SEAL5_SCORE_CSV=$DEST_DIR/seal5_score.csv

python3 -m isaac_toolkit.utils.annotate_seal5_score $INDEX_FILE --inplace --seal5-score-csv $SEAL5_SCORE_CSV
