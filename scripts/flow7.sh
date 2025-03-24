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
docker run -it --rm -v $(pwd):$(pwd) isaac-quickstart-etiss:latest $WORK/docker/ $WORK/XIsaacCore.core_desc
# NEW:
# python3 -m isaac_toolkit.retargeting.iss.etiss --sess $SESS --workdir $WORK --core-name XIsaacCore --docker

# mkdir -p $WORK/docker/etiss_source
# cd $WORK/docker/etiss_source
# unzip ../etiss_source.zip
# cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$(pwd)/install
# cmake --build build/ -j `nproc`
# cmake --install build
# cd -

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
