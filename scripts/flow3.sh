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
MIN_SUPPORTED_WEIGHT=${CHOOSE_BB_MIN_SUPPORTED_WEIGHT:-0.02}
MAX_NUM=${CHOOSE_BB_MAX_NUM:-10}

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

python3 -m isaac_toolkit.flow.demo.stage.pick --session $SESS $FORCE_ARGS

# OLD:
# python3 -m isaac_toolkit.generate.ise.check_ise_potential_per_llvm_bb --sess $SESS --allow-compressed --min-supported $MIN_SUPPORTED $FORCE_ARGS $EXTRA_ARGS
# python3 -m isaac_toolkit.generate.ise.check_ise_potential --sess $SESS --allow-compressed --min-supported $MIN_SUPPORTED $FORCE_ARGS $EXTRA_ARGS
# ENABLE_VEXT=${ENABLE_VEXT:-0}
#
# EXTRA_ARGS=""
#
# # TODO: use config
# if [[ "$ENABLE_VEXT" == "1" ]]
# then
#     EXTRA_ARGS="$EXTRA_ARGS --allow-rvv"
# fi

# TODO: do not allow compressed?

SUITABLE=$(python3 -c "import pandas as pd; print(1 if pd.read_pickle('$SESS/table/ise_potential.pkl')['has_potential'].all() else 0, end='')")

if [[ $SUITABLE == "0" ]]
then
    touch $DIR/unsuitable.txt
    exit 1
fi

# Make choices (func_name + bb_name)
# python3 -m isaac_toolkit.generate.ise.choose_bbs --sess $SESS --threshold $THRESHOLD --min-weight $MIN_WEIGHT --min-supported-weight $MIN_SUPPORTED_WEIGHT --max-num $MAX_NUM $FORCE_ARGS

NUM_CHOICES=$(python3 -c "import pandas as pd; print(len(pd.read_pickle('$SESS/table/choices.pkl')), end='')")
echo "NUM_CHOICES=$NUM_CHOICES"

if [[ $NUM_CHOICES -eq 0 ]]
then
    touch $DIR/unsuitable2.txt
    exit 1
fi
