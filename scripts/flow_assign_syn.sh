#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

FILTERED=${FILTERED:-0}

if [[ "$FILTERED" == 1 ]]
then
    STAGE="filtered"
else
    STAGE="default"
fi
STAGE_DIR=$DIR/$STAGE

# RUN=$DIR/run
# SESS=$DIR/sess
WORK=$DIR/work
SYN_SCORE_CSV=$WORK/hls_score.csv
INDEX_FILE=$WORK/index.yml

# python3 scripts/annotate_hls_score.py $INDEX_FILE --inplace --hls-score-csv $SYN_SCORE_CSV
