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

FILTERED=${FILTERED:-0}

if [[ "$FILTERED" == 1 ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
else
    INDEX_FILE=$WORK/combined_index.yml
fi

python3 scripts/annotate_per_instr_metrics.py $INDEX_FILE --inplace --report ${DIR}/compare_per_instr.csv
