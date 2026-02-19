#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
WORK=$DIR/work

# echo "$WORK/docker/llvm_install"
# sleep 10

TARGET=${TARGET:-etiss}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}
GLOBAL_ISEL=${GLOBAL_ISEL:-0}
BACKEND=${BACKEND:-"none"}

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}
BUILD_ARCH=${BUILD_ARCH:-0}

USE_SEAL5_DOCKER=${USE_SEAL5_DOCKER:-1}
if [[ "$USE_SEAL5_DOCKER" == "1" ]]
then
  SEAL5_MODE="docker"
else
  SEAL5_MODE="local"
fi
SEAL5_DEST_DIR=$WORK/$SEAL5_MODE/

USE_ETISS_DOCKER=${USE_ETISS_DOCKER:-1}
if [[ "$USE_ETISS_DOCKER" == "1" ]]
then
  ETISS_MODE="docker"
else
  ETISS_MODE="local"
fi
ETISS_DEST_DIR=$WORK/$ETISS_MODE/

if [[ "$FINAL" == "1" ]]
then
    ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss_final/etiss_install
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_final/llvm_install
    SUFFIX="_final"
elif [[ "$PRELIM" == "1" ]]
then
    ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss_prelim/etiss_install
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_prelim/llvm_install
    SUFFIX="_prelim"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss_filtered2_selected/etiss_install
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_filtered2_selected/llvm_install
    SUFFIX="_filtered2_selected"
elif [[ "$FILTERED2" == "1" ]]
then
    ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss_filtered2/etiss_install
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_filtered2/llvm_install
    SUFFIX="_filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    if [[ "$BUILD_ARCH" == 1 ]]
    then
        ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss/etiss_install
        LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5/llvm_install
    else
        ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss_filtered_selected/etiss_install
        LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_filtered_selected/llvm_install
    fi
    SUFFIX="_filtered_selected"
elif [[ "$FILTERED" == "1" ]]
then
    if [[ "$BUILD_ARCH" == 1 ]]
    then
        ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss/etiss_install
        LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5/llvm_install
    else
        ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss_filtered/etiss_install
        LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_filtered/llvm_install
    fi
    SUFFIX="_filtered"
else
    ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss/etiss_install
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5/llvm_install
    SUFFIX=""
fi

RUN2=${RUN}_new${SUFFIX}

if [[ "$BUILD_ARCH" == "1" ]]
then

    NAMES_FILE=$WORK/names${SUFFIX}.csv

    if [[ ! -f $NAMES_FILE ]]
    then
        echo "Missing: $NAMES_FILE"
        exit 1
    fi

    FULL_ARCH="$ARCH"

    for name in $(cat $NAMES_FILE | tail -n "+2" | cut -d, -f2)
    do
        FULL_ARCH="${FULL_ARCH}_xisaac${name}single"
    done
else
    FULL_ARCH=${ARCH}_xisaac
fi

ETISS_SCRIPT=$ETISS_INSTALL_DIR/bin/run_helper.sh

VERBOSE=${VERBOSE:-0}
VERBOSE_ARGS=""

if [[ "$VERBOSE" == "1" ]]
then
    VERBOSE_ARGS="-v"
fi

EXTRA_ARGS=()
if [[ "$BACKEND" != "" ]]
then
    EXTRA_ARGS+=("--backend=$BACKEND")
fi

python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 --label $LABEL-trace2${SUFFIX} -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$CORE_NAME -c llvm.install_dir=$LLVM_INSTALL_DIR -c $TARGET.arch=$FULL_ARCH -c mlif.global_isel=$GLOBAL_ISEL "${EXTRA_ARGS[@]}"

python3 -m mlonmcu.cli.main export --run -f -- $RUN2
