#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH


SET_NAME=${ISAAC_SET_NAME:-XIsaac}
SEAL5_IMAGE=${SEAL5_IMAGE:-isaac-quickstart-seal5:latest}
ENABLE_CDFG_PASS=${ENABLE_CDFG_PASS:-1}


SPLITTED=${SPLITTED:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FINAL=${FINAL:-0}

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

INDEX_FILE=$WORK/index.yml
GEN_DIR=$WORK/gen/

USE_SEAL5_DOCKER=${USE_SEAL5_DOCKER:-0}
if [[ "$USE_SEAL5_DOCKER" == "1" ]]
then
  DEST_DIR=$WORK/docker/seal5/
else
  DEST_DIR=$WORK/local/seal5/
  TEMP_DIR=$WORK/local/temp
fi

mkdir -p $DEST_DIR

CDSL_FILES=""
CFG_FILES="$(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml $(pwd)/cfg/seal5/riscv.yml"

for set_name in ${SET_NAME//;/ }
do
    if [[ "$SPLITTED" == "1" ]]
    then
        CDSL_FILE=$GEN_DIR/$set_name.splitted.core_desc
    else
        CDSL_FILE=$GEN_DIR/$set_name.core_desc
    fi
    CDSL_FILES="$CDSL_FILES $CDSL_FILE"
done


# docker run -it --rm -v $(pwd):$(pwd) isaac-quickstart-seal5:latest $DEST_DIR $CDSL_FILE $(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml $(pwd)/cfg/seal5/riscv.yml
# OLD:
if [[ "$USE_SEAL5_DOCKER" == "1" ]]
then
  docker run -it --rm -v $(pwd):$(pwd) $SEAL5_IMAGE $DEST_DIR $CDSL_FILES $CFG_FILES
else
  TEMP_SEAL5_HOME=$TEMP_DIR/seal5_llvm
  CLEANUP_SEAL5_HOME=1  # get rid of seal5_home after successfull build
  MGCLIENT_ROOT=$MGCLIENT_INSTALL_DIR ENABLE_CDFG_PASS=$ENABLE_CDFG_PASS SEAL5_HOME=$TEMP_SEAL5_HOME CCACHE=$CCACHE CCACHE_DIR=$CCACHE_DIR SEAL5_CFG_DIR=$CONFIG_DIR/seal5 SEAL5_DIR=$SEAL5_DIR LLVM_REPO=$LLVM_DIR LLVM_REF=isaacnew-base-3 CLONE_DEPTH=2 $DOCKER_DIR/seal5_script_local.sh $DEST_DIR $CDSL_FILES $CFG_FILES
  if [[ "$CLEANUP_SEAL5_HOME" == "1" ]]  
  then
    rm -rf $TEMP_SEAL5_HOME
  fi 

  # TODO: cleanup?
fi
# NEW: TODO + --cleanup
# EXTRA_ARGS=""
# if [[ "$SUFFIX" != "" ]]
# then
#     EXTRA_ARGS="$EXTRA_ARGS --label $SUFFIX"
# fi
# if [[ "$SPLITTED" == "1" ]]
# then
#     EXTRA_ARGS="$EXTRA_ARGS --splitted"
# fi
# python3 -m isaac_toolkit.flow.demo.stage.retargeting.llvm --sess $SESS --workdir $WORK $EXTRA_ARGS $FORCE_ARGS $CFG_FILES

python3 scripts/seal5_score.py --output $DEST_DIR/seal5_score.csv --seal5-status-csv $DEST_DIR/seal5_reports/status.csv --seal5-status-compact-csv $DEST_DIR/seal5_reports/status_compact.csv
python3 scripts/annotate_global_artifacts.py $INDEX_FILE --inplace --data LLVM_INSTALL_DIR=$DEST_DIR/llvm_install

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
