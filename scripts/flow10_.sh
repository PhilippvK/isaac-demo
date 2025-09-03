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

COMPARE_OTHERS_ENABLE=${COMPARE_OTHERS_ENABLE:-1}

if [[ "$COMPARE_OTHERS_ENABLE" == "0" ]]
then
    echo "Skipping Compare Others!"
    exit 0
fi

# BENCHMARKS=(cmsis_nn/arm_nn_activation_s16_tanh cmsis_nn/arm_nn_activation_s16_sigmoid cmsis_dsp/arm_abs_q15 cmsis_dsp/arm_abs_q31 rnnoise_INT8 coremark dhrystone embench/crc32 embench/nettle-aes embench/nettle-sha256 taclebench/kernel/md5)
BENCHMARKS=(arm_nn_activation_s16_tanh arm_nn_activation_s16_sigmoid arm_abs_q15 arm_abs_q31 rnnoise_INT8 coremark dhrystone crc32 nettle-aes nettle-sha256 kernel/md5)
# BENCHMARKS=("${BENCHMARKS[@]/$BENCH}")
BENCHMARK_ARGS=""

for bench in ${BENCHMARKS[*]}
do
    if [[ "$bench" != "$BENCH" ]]
    then
        BENCHMARK_ARGS="$BENCHMARK_ARGS $bench"
    fi
done

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}
BUILD_ARCH=${BUILD_ARCH:-0}

if [[ "$FINAL" == "1" ]]
then
    STAGE="final"
elif [[ "$PRELIM" == "1" ]]
then
    ETISS_INSTALL_DIR=$ETISS_BASE_DIR/prelim/etiss_install
    LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/prelim/llvm_install
    STAGE="prelim"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    ETISS_INSTALL_DIR=$ETISS_BASE_DIR/filtered2_selected/etiss_install
    LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/filtered2_selected/llvm_install
    STAGE="filtered2_selected"
elif [[ "$FILTERED2" == "1" ]]
then
    ETISS_INSTALL_DIR=$ETISS_BASE_DIR/filtered2/etiss_install
    LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/filtered2/llvm_install
    STAGE="filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == "1" ]]
then
    if [[ "$BUILD_ARCH" == 1 ]]
    then
    	STAGE_ALT="default"
        ETISS_INSTALL_DIR=$ETISS_BASE_DIR/default/etiss_install
        LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/default/llvm_install
    else
    	STAGE_ALT="filtered_selected"
        ETISS_INSTALL_DIR=$ETISS_BASE_DIR/filtered_selected/etiss_install
        LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/filtered_selected/llvm_install
    fi
    STAGE="_filtered_selected"
elif [[ "$FILTERED" == "1" ]]
then
    if [[ "$BUILD_ARCH" == 1 ]]
    then
        ETISS_INSTALL_DIR=$ETISS_BASE_DIR/default/etiss_install
        LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/default/llvm_install
    	STAGE_ALT="default"
    else
        ETISS_INSTALL_DIR=$ETISS_BASE_DIR/filtered/etiss_install
        LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/filtered/llvm_install
    	STAGE_ALT="filtered"
    fi
    STAGE="filtered"
else
    ETISS_INSTALL_DIR=$ETISS_BASE_DIR/default/etiss_install
    LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/default/llvm_install
    STAGE="default"
    STAGE_ALT="default"
fi
STAGE_DIR=$DIR/$STAGE
STAGE_ALT_DIR=$DIR/$STAGE_ALT

RUN=$STAGE_DIR/run
# SESS=$STAGE_DIR/sess
WORK=$STAGE_DIR/work
WORK_ALT=$STAGE_ALT_DIR/work

USE_SEAL5_DOCKER=${USE_SEAL5_DOCKER:-0}
if [[ "$USE_SEAL5_DOCKER" == "1" ]]
then
  SEAL5_BASE_DIR=$WORK_ALT/docker/seal5
else
  SEAL5_BASE_DIR=$WORK_ALT/local/seal5
fi

USE_ETISS_DOCKER=${USE_ETISS_DOCKER:-0}
if [[ "$USE_ETISS_DOCKER" == "1" ]]
then
  ETISS_BASE_DIR=$WORK_ALT/docker/etiss
else
  ETISS_BASE_DIR=$WORK_ALT/local/etiss
fi

ETISS_INSTALL_DIR=$ETISS_BASE_DIR/final/etiss_install
LLVM_INSTALL_DIR=$SEAL5_BASE_DIR/final/llvm_install

if [[ "$BUILD_ARCH" == "1" ]]
then

    NAMES_FILE=$WORK_ALT/names.csv

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

PRINT_OUTPUTS=0

VERBOSE=${VERBOSE:-0}
VERBOSE_ARGS=""

if [[ "$VERBOSE" == "1" ]]
then
    VERBOSE_ARGS="-v"
fi

python3 -m mlonmcu.cli.main flow run $BENCHMARK_ARGS --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$CORE_NAME -c $TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=$FULL_ARCH --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions" --parallel $NUM_THREADS -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --dest ${RUN}_compare_others
# python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_others
python3 scripts/analyze_reuse.py $STAGE_DIR/${RUN}_compare_others/report.csv --print-df --output $STAGE_DIR/${RUN}_compare_others.csv

python3 -m mlonmcu.cli.main flow compile $BENCHMARK_ARGS --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare-mem -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$CORE_NAME -c $TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --config-gen etiss.arch=$ARCH --config-gen etiss.arch=$FULL_ARCH --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1 --parallel $NUM_THREADS -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --dest ${RUN}_compare_others_mem
# python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_others_mem
python3 scripts/analyze_reuse.py $STAGE_DIR/${RUN}_compare_others_mem/report.csv --print-df --mem --output $STAGE_DIR/${RUN}_compare_others_mem.csv
