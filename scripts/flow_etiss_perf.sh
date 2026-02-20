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

USE_ETISS_PERF_DOCKER=${USE_ETISS_PERF_DOCKER:-1}
if [[ "$USE_ETISS_PERF_DOCKER" == "1" ]]
then
  MODE="docker"
else
  MODE="local"
fi
DEST_DIR=$WORK/$MODE/

mkdir -p $DEST_DIR

SPLITTED=${SPLITTED:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FINAL=${FINAL:-0}

FORCE_ARGS=""

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

if [[ "$FINAL" == "1" ]]
then
    GEN_DIR=$WORK/gen_final/
    DEST_DIR=$DEST_DIR/etiss_perf_final/
    INDEX_FILE=$WORK/final_index.yml
    SUFFIX="final"
elif [[ "$PRELIM" == "1" ]]
then
    GEN_DIR=$WORK/gen_prelim/
    DEST_DIR=$DEST_DIR/etiss_perf_prelim/
    INDEX_FILE=$WORK/prelim_index.yml
    SUFFIX="prelim"
elif [[ "$FILTERED" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered/
    DEST_DIR=$DEST_DIR/etiss_perf_filtered/
    INDEX_FILE=$WORK/filtered_index.yml
    SUFFIX="filtered"
else
    GEN_DIR=$WORK/gen/
    DEST_DIR=$DEST_DIR/etiss_perf/
    INDEX_FILE=$WORK/combined_index.yml
    SUFFIX=""
fi

CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}
ETISS_PERF_IMAGE=${ETISS_PERF_IMAGE:-philippvk/isaac-quickstart-etiss-perf:latest}


mkdir -p $DEST_DIR

# OLD:
# docker run -i --rm -v $(pwd):$(pwd) $ETISS_PERF_IMAGE $DEST_DIR $GEN_DIR/$CORE_NAME.core_desc
# NEW:
# python3 -m isaac_toolkit.retargeting.iss.etiss --sess $SESS --workdir $WORK --core-name $CORE_NAME --docker
EXTRA_ARGS=""
if [[ "$SUFFIX" != "" ]]
then
    EXTRA_ARGS="--label $SUFFIX"
fi
python3 -m isaac_toolkit.flow.demo.stage.retargeting.iss_perf --sess $SESS --workdir $WORK $EXTRA_ARGS $FORCE_ARGS --$MODE

python3 -m isaac_tookit.utils.annotate_global_artifacts $INDEX_FILE --inplace --data ETISS_PERF_INSTALL_DIR=$DEST_DIR/etiss_perf_install
