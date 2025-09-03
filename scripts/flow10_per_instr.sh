#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

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
# SESS=$STAGE_DIR/sess
WORK=$STAGE_DIR/work

USE_SEAL5_DOCKER=${USE_SEAL5_DOCKER:-0}
if [[ "$USE_SEAL5_DOCKER" == "1" ]]
then
  SEAL5_BASE_DIR=$WORK/docker/seal5
else
  SEAL5_BASE_DIR=$WORK/local/seal5
fi

USE_ETISS_DOCKER=${USE_ETISS_DOCKER:-0}
if [[ "$USE_ETISS_DOCKER" == "1" ]]
then
  ETISS_BASE_DIR=$WORK/docker/etiss
else
  ETISS_BASE_DIR=$WORK/local/etiss
fi

ETISS_INSTALL_DIR=$ETISS_BASE_DIR/etiss_install
LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/llvm_install


RUN_COMPARE=$STAGE_DIR/${RUN}_compare_per_instr
RUN_COMPARE_MEM=$STAGE_DIR/${RUN}_compare_per_instr_mem

REPORT_COMPARE=$RUN_COMPARE/report.csv
REPORT_COMPARE_MEM=$RUN_COMPARE_MEM/report.csv


NAMES_FILE=$WORK/names.csv

if [[ ! -f $NAMES_FILE ]]
then
    echo "Missing: $NAMES_FILE"
    exit 1
fi

CONFIG_GEN_ARGS="--config-gen $TARGET.arch=$ARCH"

for name in $(cat $NAMES_FILE | tail -n "+2" | cut -d, -f2)
do
    CONFIG_GEN_ARGS="$CONFIG_GEN_ARGS --config-gen $TARGET.arch=${ARCH}_xisaac${name}single"
done

ETISS_SCRIPT=$ETISS_INSTALL_DIR/bin/run_helper.sh

NUM_THREADS=4

PRINT_OUTPUTS=0

VERBOSE=${VERBOSE:-0}
VERBOSE_ARGS=""

if [[ "$VERBOSE" == "1" ]]
then
    VERBOSE_ARGS="-v"
fi

python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$CORE_NAME -c $TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR $CONFIG_GEN_ARGS --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions" -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --parallel $NUM_THREADS --dest $RUN_COMPARE
# python3 -m mlonmcu.cli.main export --session -f -- $RUN_COMPARE

python3 -m mlonmcu.cli.main flow compile $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare-mem -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=XIsaacCore -c $TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR $CONFIG_GEN_ARGS --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1 -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --parallel $NUM_THREADS --dest $RUN_COMPARE_MEM
# python3 -m mlonmcu.cli.main export --session -f -- $RUN_COMPARE_MEM

python3 scripts/analyze_compare.py ${REPORT_COMPARE} --mem-report ${REPORT_COMPARE_MEM} --print-df --output $STAGE_DIR/compare_per_instr.csv
