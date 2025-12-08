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

MIN_SEAL5_SCORE=${MIN_SEAL5_SCORE:-0.5}
FILTER_MIN_RUNTIME_REDUCTION_REL=${FILTER_MIN_RUNTIME_REDUCTION_REL:-0.005}

# TODO: topk
# TODO: sort?

FILTER_ARGS="--min-seal5-score ${MIN_SEAL5_SCORE} --min-runtime-reduction-rel ${FILTER_MIN_RUNTIME_REDUCTION_REL}"

# TODO: handle float comparisons


# TODO: move to filter_0
python3 scripts/filter_index.py $WORK/combined_index.yml --out $WORK/filtered_index.yml $FILTER_ARGS --sankey $WORK/sankey_filtered.md

python3 -m isaac_toolkit.utils.names_helper $WORK/filtered_index.yml --output $WORK/names_filtered.csv
