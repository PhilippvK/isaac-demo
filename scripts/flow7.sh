#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

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
    STAGE="final"
elif [[ "$PRELIM" == "1" ]]
then
    STAGE="prelim"
elif [[ "$FILTERED" == "1" ]]
then
    STAGE="filtered"
else
    STAGE="default"
fi
STAGE_DIR=$DIR/$STAGE

RUN=$STAGE_DIR/run
SESS=$STAGE_DIR/sess
WORK=$STAGE_DIR/work

GEN_DIR=$WORK/gen
INDEX_FILE=$WORK/index.yml

USE_ETISS_DOCKER=${USE_ETISS_DOCKER:-0}
if [[ "$USE_ETISS_DOCKER" == "1" ]]
then
  DEST_DIR=$WORK/docker/etiss
else
  DEST_DIR=$WORK/local/etiss
  TEMP_DIR=$WORK/local/temp
fi


mkdir -p $DEST_DIR

CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}
ETISS_IMAGE=${ETISS_IMAGE:-philippvk/isaac-quickstart-etiss:latest}


mkdir -p $DEST_DIR

# OLD:
# docker run -i --rm -v $(pwd):$(pwd) $ETISS_IMAGE $DEST_DIR $GEN_DIR/$CORE_NAME.core_desc
# NEW:
# python3 -m isaac_toolkit.retargeting.iss.etiss --sess $SESS --workdir $WORK --core-name $CORE_NAME --docker
EXTRA_ARGS=""
# if [[ "$STAGE" != "" ]]
# then
#     EXTRA_ARGS="$EXTRA_ARGS --label $STAGE"
# fi
if [[ "$USE_ETISS_DOCKER" == "1" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --docker"
elif [[ "$USE_ETISS_DOCKER" == "0" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --local"
fi

if [[ "$VERBOSE" == "1" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --verbose"
fi
# python3 -m isaac_toolkit.flow.demo.stage.retargeting.iss --sess $SESS --workdir $WORK $EXTRA_ARGS $FORCE_ARGS --$MODE
python3 -m isaac_toolkit.flow.demo.stage.retargeting.iss --sess $SESS --workdir $WORK $EXTRA_ARGS $FORCE_ARGS --cleanup

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
