#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

FORCE_ARGS=""

MIN_SUPPORTED=${CHECK_POTENTIAL_MIN_SUPPORTED:-0.15}

THRESHOLD=${CHOOSE_BB_THRESHOLD:-0.9}
MIN_WEIGHT=${CHOOSE_BB_MIN_WEIGHT:-0.05}
MAX_NUM=${CHOOSE_BB_MAX_NUM:-10}

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

# Make choices (func_name + bb_name)
python3 -m isaac_toolkit.generate.ise.choose_bbs --sess $SESS --threshold 0.9 --min-weight 0.05 --max-num 10 $FORCE_ARGS
