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

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
PRELIM_FILTERED=${PRELIM_FILTERED:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}

if [[ "$FINAL" == "1" ]]
then
    INDEX_FILE=$WORK/final_index.yml
    SORT_BY="final_score"
elif [[ "$PRELIM_FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_filtered_index.yml
    SORT_BY="prelim_filtered_score"
elif [[ "$PRELIM" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_index.yml
    SORT_BY="prelim_score"
elif [[ "$FILTERED2" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_index.yml
    SORT_BY="filtered2_score"
elif [[ "$FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
    SORT_BY="filtered_score"
else
    INDEX_FILE=$WORK/combined_index.yml
    SORT_BY="score"
fi


python3 scripts/sort_index.py $INDEX_FILE --inplace --by $SORT_BY

# NAMES_CSV=$WORK/names_final.csv
# python3 scripts/assign_names.py $INDEX_FILE --inplace --csv $NAMES_CSV
