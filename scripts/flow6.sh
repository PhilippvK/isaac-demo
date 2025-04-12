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

DOCKER_DIR=$WORK/docker/
mkdir -p $DOCKER_DIR

SET_NAME=${ISAAC_SET_NAME:-XIsaac}

SPLITTED=${SPLITTED:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FINAL=${FINAL:-0}


if [[ "$FINAL" == "1" ]]
then
    GEN_DIR=$WORK/gen_final/
    DEST_DIR=$DOCKER_DIR/seal5_final/
elif [[ "$PRELIM" == "1" ]]
then
    GEN_DIR=$WORK/gen_prelim/
    DEST_DIR=$DOCKER_DIR/seal5_prelim/
elif [[ "$FILTERED" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered/
    DEST_DIR=$DOCKER_DIR/seal5_filtered/
else
    GEN_DIR=$WORK/gen/
    DEST_DIR=$DOCKER_DIR/seal5/
fi

if [[ "$SPLITTED" == "1" ]]
then
    CDSL_FILE=$GEN_DIR/$SET_NAME.splitted.core_desc
else
    CDSL_FILE=$GEN_DIR/$SET_NAME.core_desc
fi

mkdir -p $DEST_DIR

# docker run -it --rm -v $(pwd):$(pwd) isaac-quickstart-seal5:latest $DEST_DIR $CDSL_FILE $(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml $(pwd)/cfg/seal5/riscv.yml
docker run -it --rm -v $(pwd):$(pwd) isaac-quickstart-seal5:latest $DEST_DIR $CDSL_FILE $(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml $(pwd)/cfg/seal5/riscv.yml
# NEW:
# python3 -m isaac_toolkit.retargeting.llvm.seal5 --sess $SESS --workdir $WORK --set-name $SET_NAME --xlen 32 --docker

python3 scripts/seal5_score.py --output $DEST_DIR/seal5_score.csv --seal5-status-csv $DEST_DIR/seal5_reports/status.csv --seal5-status-compact-csv $DEST_DIR/seal5_reports/status_compact.csv

# TODO: handle locs in final separate step!
# ARGS=""
# if [[ -f $DEST_DIR/seal5_reports/diff.csv ]]
# then
#     ARGS="$ARGS --seal5-diff-csv $DEST_DIR/seal5_reports/diff.csv"
# fi
# if [[ -f $DEST_DIR/etiss_patch.stat ]]
# then
#     ARGS="$ARGS --etiss-patch-stat $DEST_DIR/etiss_patch.stat"
# fi
# if [[ -f $WORK/docker/hls_metrics.csv ]]
# then
#     ARGS="$ARGS --hls-metrics-csv $WORK/docker/hls_metrics.csv"
# fi
# python3 scripts/locs_helper.py $ARGS --output $WORK/combined_locs.csv
