#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
# LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

STAGE="default"
STAGE_DIR=$DIR/$STAGE
# RUN=$STAGE_DIR/run
# SESS=$STAGE_DIR/sess
# WORK=$STAGE_DIR/work

# TODO
