#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE
STAGE=32  # 32 -> post finalizeisel/expandpseudos

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

python3 -m isaac_toolkit.visualize.pie.runtime --sess $SESS --legend
python3 -m isaac_toolkit.visualize.pie.mem_footprint --sess $SESS --legend

# Create workdir
mkdir -p $WORK

# Make choices (func_name + bb_name)
python3 -m isaac_toolkit.generate.ise.choose_bbs --sess $SESS --threshold 0.9 --min-weight 0.05 --max-num 3 --force
