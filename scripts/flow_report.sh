#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

python3 $SCRIPTS_DIR/gen_ci_summary.py $DIR/experiment.ini --fmt md > $DIR/ci_report.md
