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

mkdir -p $WORK/docker/
docker run -it --rm -v $(pwd):$(pwd) isaac-quickstart-seal5:latest $WORK/docker/ $WORK/XIsaac.core_desc $(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml $(pwd)/cfg/seal5/riscv.yml

python3 scripts/seal5_score.py --output $WORK/seal5_score.csv --seal5-status-csv $WORK/docker/seal5_reports/status.csv --seal5-status-compact-csv $WORK/docker/seal5_reports/status_compact.csv

python3 scripts/locs_helper.py --seal5-diff-csv $WORK/docker/seal5_reports/diff.csv --output $WORK/combined_locs.csv
