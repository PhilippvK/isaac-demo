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
LOGS_DIR=$DIR/logs
SESS=$DIR/sess
SESS_NEW=${SESS}_new
WORK=$DIR/work
DOCKER=$WORK/docker

CLEANUP_ENABLE=${CLEANUP_ENABLE:-0}
CLEANUP_DOCKER=${CLEANUP_DOCKER:-1}
CLEANUP_SESS=${CLEANUP_SESS:-1}
CLEANUP_RUN=${CLEANUP_RUH:-1}

if [[ "$CLEANUP_ENABLE" == "0" ]]
then
    echo "Skipping Cleanup!"
    exit 0
fi

# TODO: move artifacts out of docker dir!
test -d $LOGS_DIR && rm -rf $LOGS_DIR || echo "Skipping logs dir removal"
if [[ "$CLEANUP_DOCKER" == "1" ]]
then
    test -d $DOCKER && rm -rf $DOCKER || echo "Skipping docker dir removal"
fi
# TODO: handle sudo
# TODO: handle filtered etc
# TODO: move hls/syn reports to subdirs
# TODO: refactor run/sess to subdirs
if [[ "$CLEANUP_RUN" == "1" ]]
then
    test -d $RUN && rm -rf $RUN || echo "Skipping run dir removal"
    test -d $RUN_NEW && rm -rf $RUN_NEW || echo "Skipping run_new dir removal"
    test -d $RUN_COMPARE && rm -rf $RUN_COMPARE || echo "Skipping run_compare dir removal"
    test -d $RUN_COMPARE_MEM && rm -rf $RUN_COMPARE_MEM || echo "Skipping run_compare_mem dir removal"
    test -d $RUN_COMPARE_OTHERS && rm -rf $RUN_COMPARE_OTHERS || echo "Skipping run_compare_others dir removal"
    test -d $RUN_COMPARE_OTHERS_MEM && rm -rf $RUN_COMPARE_OTHERS_MEM || echo "Skipping run_compare_others_mem dir removal"
fi
if [[ "$CLEANUP_SESS" == "1" ]]
then
    test -d $SESS && rm -rf $SESS || echo "Skipping sess dir removal"
    test -d $SESS_NEW && rm -rf $SESS_NEW || echo "Skipping sess_new dir removal"
fi
