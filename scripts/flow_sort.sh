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
# PRELIM_FILTERED=${PRELIM_FILTERED:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}

if [[ "$FINAL" == "1" ]]
then
    INDEX_FILE=$WORK/final_index.yml
    SORT_BY="final_score"
# elif [[ "$PRELIM_FILTERED" == "1" ]]
# then
#     INDEX_FILE=$WORK/prelim_filtered_index.yml
#     SORT_BY="prelim_filtered_score"
elif [[ "$PRELIM" == "1" ]]
then
    INDEX_FILE=$WORK/prelim_index.yml
    SORT_BY="prelim_score"
    NAMES_CSV=$WORK/names_prelim.csv
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_selected_index.yml
    SORT_BY="filtered2_selected_score"
    NAMES_CSV=$WORK/names_filtered2_selected.csv
elif [[ "$FILTERED2" == "1" ]]
then
    INDEX_FILE=$WORK/filtered2_index.yml
    SORT_BY="filtered2_score"
    NAMES_CSV=$WORK/names_filtered2.csv
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_selected_index.yml
    SORT_BY="filtered_selected_score"
    NAMES_CSV=$WORK/names_filtered_selected.csv
elif [[ "$FILTERED" == "1" ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
    SORT_BY="filtered_score"
    NAMES_CSV=$WORK/names_filtered.csv
else
    INDEX_FILE=$WORK/combined_index.yml
    NAMES_CSV=$WORK/names.csv
    SORT_BY="score"
fi


python3 scripts/sort_index.py $INDEX_FILE --inplace --by $SORT_BY
python3 scripts/names_helper.py $INDEX_FILE --output $NAMES_CSV

# python3 scripts/assign_names.py $INDEX_FILE --inplace --csv $NAMES_CSV
