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

SET_NAME=${ISAAC_SET_NAME:-XIsaac}

mkdir -p $WORK/docker/
docker run -it --rm -v $(pwd):$(pwd) isaac-quickstart-seal5:latest $WORK/docker/ $WORK/$SET_NAME.core_desc $(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml $(pwd)/cfg/seal5/riscv.yml
# NEW:
# python3 -m isaac_toolkit.retargeting.llvm.seal5 --sess $SESS --workdir $WORK --set-name $SET_NAME --xlen 32 --docker

python3 scripts/seal5_score.py --output $WORK/seal5_score.csv --seal5-status-csv $WORK/docker/seal5_reports/status.csv --seal5-status-compact-csv $WORK/docker/seal5_reports/status_compact.csv

ARGS=""
if [[ -f $WORK/docker/seal5_reports/diff.csv ]]
then
    ARGS="$ARGS --seal5-diff-csv $WORK/docker/seal5_reports/diff.csv"
fi
if [[ -f $WORK/docker/etiss_patch.stat ]]
then
    ARGS="$ARGS --etiss-patch-stat $WORK/docker/etiss_patch.stat"
fi
if [[ -f $WORK/docker/hls_metrics.csv ]]
then
    ARGS="$ARGS --hls-metrics-csv $WORK/docker/hls_metrics.csv"
fi
python3 scripts/locs_helper.py $ARGS --output $WORK/combined_locs.csv
