#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
# SESS=$DIR/sess
WORK=$DIR/work

TARGET=${TARGET:-etiss}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}

GLOBAL_ISEL=${GLOBAL_ISEL:-0}

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
BUILD_ARCH=${BUILD_ARCH:-0}

DOCKER_DIR=$WORK/docker

if [[ "$FINAL" == "1" ]]
then
    ETISS_INSTALL_DIR=$DOCKER_DIR/etiss_final/etiss_install
    LLVM_INSTALL_DIR=$DOCKER_DIR/seal5_final/llvm_install
    SUFFIX="_final"
elif [[ "$PRELIM" == "1" ]]
then
    ETISS_INSTALL_DIR=$DOCKER_DIR/etiss_prelim/etiss_install
    LLVM_INSTALL_DIR=$DOCKER_DIR/seal5_prelim/llvm_install
    SUFFIX="_prelim"
elif [[ "$FILTERED" == "1" ]]
then
    if [[ "$BUILD_ARCH" == 1 ]]
    then
        ETISS_INSTALL_DIR=$DOCKER_DIR/etiss/etiss_install
        LLVM_INSTALL_DIR=$DOCKER_DIR/seal5/llvm_install
    else
        ETISS_INSTALL_DIR=$DOCKER_DIR/etiss_filtered/etiss_install
        LLVM_INSTALL_DIR=$DOCKER_DIR/seal5_filtered/llvm_install
    fi
    SUFFIX="_filtered"
else
    ETISS_INSTALL_DIR=$DOCKER_DIR/etiss/etiss_install
    LLVM_INSTALL_DIR=$DOCKER_DIR/seal5/llvm_install
    SUFFIX=""
fi

RUN_COMPARE=${RUN}_compare${SUFFIX}
RUN_COMPARE_MEM=${RUN}_compare_mem${SUFFIX}

REPORT_COMPARE=$RUN_COMPARE/report.csv
REPORT_COMPARE_MEM=$RUN_COMPARE_MEM/report.csv


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

NUM_THREADS=4

ETISS_SCRIPT=$ETISS_INSTALL_DIR/bin/run_helper.sh


python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$CORE_NAME -c $TARGET.print_outputs=1 -c llvm.install_dir=$LLVM_INSTALL_DIR --config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=$FULL_ARCH --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions" -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --parallel $NUM_THREADS
python3 -m mlonmcu.cli.main export --session -f -- $RUN_COMPARE

python3 -m mlonmcu.cli.main flow compile $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare-mem -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=XIsaacCore -c $TARGET.print_outputs=1 -c llvm.install_dir=$LLVM_INSTALL_DIR --config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=$FULL_ARCH --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1 -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --parallel $NUM_THREADS
python3 -m mlonmcu.cli.main export --session -f -- $RUN_COMPARE_MEM

python3 scripts/analyze_compare.py ${REPORT_COMPARE} --mem-report ${REPORT_COMPARE_MEM} --print-df --output ${DIR}/compare${SUFFIX}.csv
