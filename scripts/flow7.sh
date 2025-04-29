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

SPLITTED=${SPLITTED:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FINAL=${FINAL:-0}


if [[ "$FINAL" == "1" ]]
then
    GEN_DIR=$WORK/gen_final/
    DEST_DIR=$DOCKER_DIR/etiss_final/
    INDEX_FILE=$WORK/final_index.yml
elif [[ "$PRELIM" == "1" ]]
then
    GEN_DIR=$WORK/gen_prelim/
    DEST_DIR=$DOCKER_DIR/etiss_prelim/
    INDEX_FILE=$WORK/prelim_index.yml
elif [[ "$FILTERED" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered/
    DEST_DIR=$DOCKER_DIR/etiss_filtered/
    INDEX_FILE=$WORK/filtered_index.yml
else
    GEN_DIR=$WORK/gen/
    DEST_DIR=$DOCKER_DIR/etiss/
    INDEX_FILE=$WORK/combined_index.yml
fi

CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}
ETISS_IMAGE=${ETISS_IMAGE:-isaac-quickstart-etiss:latest}


mkdir -p $DEST_DIR

docker run -it --rm -v $(pwd):$(pwd) $ETISS_IMAGE $DEST_DIR $GEN_DIR/$CORE_NAME.core_desc
# NEW:
# python3 -m isaac_toolkit.retargeting.iss.etiss --sess $SESS --workdir $WORK --core-name $CORE_NAME --docker

# mkdir -p $WORK/docker/etiss_source
# cd $WORK/docker/etiss_source
# unzip ../etiss_source.zip
# cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$(pwd)/install
# cmake --build build/ -j `nproc`
# cmake --install build
# cd -
python3 scripts/annotate_global_artifacts.py $INDEX_FILE --inplace --data ETISS_INSTALL_DIR=$DEST_DIR/etiss_install

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
