#!/bin/bash

# Cleanup temporary artifacts (llvm build, trace,...)

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
RUN_NEW=${RUN}_new
RUN_COMPARE=${RUN}_compare
RUN_COMPARE_MEM=${RUN}_compare_mem
RUN_COMPARE_OTHERS=${RUN}_compare_others
RUN_COMPARE_OTHERS_MEM=${RUN}_compare_others_mem
SESS=$DIR/sess
SESS_NEW=${SESS}_new
WORK=$DIR/work
DOCKER=$WORK/docker

test -d $DOCKER && rm -rf $DOCKER || echo "Skipping docker dir removal"
test -d $RUN && rm -rf $RUN || echo "Skipping run dir removal"
test -d $RUN_NEW && rm -rf $RUN_NEW || echo "Skipping run_new dir removal"
test -d $RUN_COMPARE && rm -rf $RUN_COMPARE || echo "Skipping run_compare dir removal"
test -d $RUN_COMPARE_MEM && rm -rf $RUN_COMPARE_MEM || echo "Skipping run_compare_mem dir removal"
test -d $RUN_COMPARE_OTHERS && rm -rf $RUN_COMPARE_OTHERS || echo "Skipping run_compare_others dir removal"
test -d $RUN_COMPARE_OTHERS_MEM && rm -rf $RUN_COMPARE_OTHERS_MEM || echo "Skipping run_compare_others_mem dir removal"
test -d $SESS && rm -rf $SESS || echo "Skipping sess dir removal"
test -d $SESS_NEW && rm -rf $SESS_NEW || echo "Skipping sess_new dir removal"
