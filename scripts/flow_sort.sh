#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
# PRELIM_FILTERED=${PRELIM_FILTERED:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}

if [[ "$FINAL" == "1" ]]
then
    STAGE="final"
    INDEX_FILE=$WORK/final_index.yml
    SORT_BY="final_score"
# elif [[ "$PRELIM_FILTERED" == "1" ]]
# then
#     INDEX_FILE=$WORK/prelim_filtered_index.yml
#     SORT_BY="prelim_filtered_score"
elif [[ "$PRELIM" == "1" ]]
then
    STAGE="prelim"
    SORT_BY="prelim_score"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    STAGE="filtered2_selected"
    SORT_BY="filtered2_selected_score"
elif [[ "$FILTERED2" == "1" ]]
then
    STAGE="filtered2"
    SORT_BY="filtered2_score"
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    STAGE="filtered_selected"
    SORT_BY="filtered_selected_score"
elif [[ "$FILTERED" == "1" ]]
then
    STAGE="filtered"
    SORT_BY="filtered_score"
else
    STAGE="default"
    SORT_BY="score"
fi
STAGE_DIR=$DIR/$STAGE

WORK=$STAGE_DIR/work

INDEX_FILE=$WORK/index.yml
NAMES_CSV=$WORK/names.csv

python3 scripts/sort_index.py $INDEX_FILE --inplace --by $SORT_BY
python3 scripts/names_helper.py $INDEX_FILE --output $NAMES_CSV

# python3 scripts/assign_names.py $INDEX_FILE --inplace --csv $NAMES_CSV
