#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

FORCE_ARGS=""

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

python3 -m isaac_toolkit.flow.demo.stage.visualize --session $SESS $FORCE_ARGS

# OLD:
# python3 -m isaac_toolkit.visualize.pie.runtime --sess $SESS --legend $FORCE_ARGS
# python3 -m isaac_toolkit.visualize.pie.mem_footprint --sess $SESS --legend $FORCE_ARGS
# python3 -m isaac_toolkit.visualize.pie.disass_counts --sess $SESS --legend $FORCE_ARGS
