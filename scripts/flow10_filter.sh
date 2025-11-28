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

IN_STAGE_DIR=$WORK/default
OUT_STAGE_DIR=$WORK/filtered

# TODO: move to filter_0
python3 scripts/filter_index.py $IN_STAGE_DIR/index.yml --out $IN_STAGE_DIR/index.yml $FILTER_ARGS --sankey $OUT_STAGE_DIR/sankey.md

python3 scripts/names_helper.py $OUT_STAGE_DIR/index.yml --output $OUT_STAGE_DIR/names.csv
