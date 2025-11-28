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

# RUN=$STAGE_DIR/run
# SESS=$STAGE_DIR/sess
WORK=$STAGE_DIR/work

INDEX_FILE=$WORK/index.yml

python3 scripts/annotate_per_instr_metrics.py $INDEX_FILE --inplace --report ${STAGE_DIR}/compare_per_instr.csv
