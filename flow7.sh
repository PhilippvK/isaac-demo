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
docker run -it --rm -v $(pwd):$(pwd) --entrypoint /work/etiss_script.sh seal5-quickstart:minimal2 $WORK/docker/ $WORK/XIsaacCore.core_desc
