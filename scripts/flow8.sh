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

# TODO: expose
# CORE_NAME=VEX_4S
CORE_NAME=VEX_5S

cp $WORK/XIsaac.hls.core_desc /work/git/tuda/isax-tools-integration/nailgun/isaxes/isaac.core_desc  # TODO: do not hardcode
# TODO: allow running the flow for multiple isaxes in parallel
mkdir -p $WORK/docker/hls/
sudo chmod 777 -R $WORK/docker/hls
mkdir -p $WORK/docker/hls/output
docker run -it --rm -v /work/git/tuda/isax-tools-integration/:/isax-tools -v $(pwd):$(pwd) isaac-quickstart-hls:latest "date && cd /isax-tools/nailgun && CONFIG_PATH=$WORK/docker/hls/.config OUTPUT_PATH=$WORK/docker/hls/output ISAXES=ISAAC SIM_EN=n CORE=$CORE_NAME SKIP_AWESOME_LLVM=y make gen_config ci"
python3 scripts/collect_hls_metrics.py $WORK/docker/hls/output --output $WORK/docker/hls/hls_metrics.csv --print
python3 scripts/locs_helper.py --seal5-diff-csv $WORK/docker/seal5_reports/diff.csv --etiss-patch-stat $WORK/docker/etiss_patch.stat --hls-metrics-csv $WORK/docker/hls/hls_metrics.csv --output $WORK/combined_locs.csv
sudo chmod 777 -R $WORK/docker/hls
