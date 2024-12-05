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

# mkdir -p $WORK/docker/etiss_source
# cd $WORK/docker/etiss_source
# unzip ../etiss_source.zip
# cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$(pwd)/install
# cmake --build build/ -j `nproc`
# cmake --install build
# cd -
