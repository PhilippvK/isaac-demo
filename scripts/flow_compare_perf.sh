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

PERF_TARGET=${PERF_TARGET:-etiss_perf}
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

USE_ETISS_PERF_DOCKER=${USE_ETISS_PERF_DOCKER:-1}
if [[ "$USE_ETISS_PERF_DOCKER" == "1" ]]
then
  ETISS_PERF_MODE="docker"
else
  ETISS_PERF_MODE="local"
fi
ETISS_PERF_DEST_DIR=$WORK/$ETISS_PERF_MODE/

# DOCKER_DIR=$WORK/docker

if [[ "$FINAL" == "1" ]]
then
    ETISS_PERF_INSTALL_DIR=$ETISS_PERF_DEST_DIR/etiss_perf_final/etiss_perf_install
    UARCHS_FILE=$ETISS_PERF_DEST_DIR/etiss_perf_final//uarchs.csv
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_final/llvm_install
    SUFFIX="_final"
elif [[ "$PRELIM" == "1" ]]
then
    ETISS_PERF_INSTALL_DIR=$ETISS_PERF_DEST_DIR/etiss_perf_prelim/etiss_perf_install
    UARCHS_FILE=$ETISS_PERF_DEST_DIR/etiss_perf_prelim//uarchs.csv
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_prelim/llvm_install
    SUFFIX="_prelim"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == 1 ]]
then
    ETISS_PERF_INSTALL_DIR=$ETISS_PERF_DEST_DIR/etiss_perf_filtered2_selected/etiss_perf_install
    UARCHS_FILE=$ETISS_PERF_DEST_DIR/etiss_perf_filtered2_selected//uarchs.csv
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_filtered2_selected/llvm_install
    SUFFIX="_filtered2"
elif [[ "$FILTERED2" == "1" ]]
then
    ETISS_PERF_INSTALL_DIR=$ETISS_PERF_DEST_DIR/etiss_perf_filtered2/etiss_perf_install
    UARCHS_FILE=$ETISS_PERF_DEST_DIR/etiss_perf_filtered2//uarchs.csv
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_filtered2/llvm_install
    SUFFIX="_filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == 1 ]]
then
    if [[ "$BUILD_ARCH" == 1 ]]
    then
        LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5/llvm_install
        ETISS_PERF_INSTALL_DIR=$ETISS_PERF_DEST_DIR/etiss_perf_filtered_selected/etiss_perf_install
        UARCHS_FILE=$ETISS_PERF_DEST_DIR/etiss_perf_filtered_selected//uarchs.csv
    else
        LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_filtered_selected/llvm_install
        ETISS_PERF_INSTALL_DIR=$ETISS_PERF_DEST_DIR/etiss_perf_filtered_selected/etiss_perf_install
        UARCHS_FILE=$ETISS_PERF_DEST_DIR/etiss_perf_filtered_selected//uarchs.csv
    fi
    SUFFIX="_filtered_selected"
elif [[ "$FILTERED" == "1" ]]
then
    if [[ "$BUILD_ARCH" == 1 ]]
    then
        LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5/llvm_install
        ETISS_PERF_INSTALL_DIR=$ETISS_PERF_DEST_DIR/etiss_perf_filtered/etiss_perf_install
        UARCHS_FILE=$ETISS_PERF_DEST_DIR/etiss_perf_filtered//uarchs.csv
    else
        LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5_filtered/llvm_install
        ETISS_PERF_INSTALL_DIR=$ETISS_PERF_DEST_DIR/etiss_perf_filtered/etiss_perf_install
        UARCHS_FILE=$ETISS_PERF_DEST_DIR/etiss_perf_filtered//uarchs.csv
    fi
    SUFFIX="_filtered"
else
    ETISS_PERF_INSTALL_DIR=$ETISS_PERF_DEST_DIR/etiss_perf/etiss_perf_install
    UARCHS_FILE=$ETISS_PERF_DEST_DIR/etiss_perf//uarchs.csv
    LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/seal5/llvm_install
    SUFFIX=""
fi

RUN_COMPARE_PERF=${RUN}_compare_perf${SUFFIX}
RUN_COMPARE_PERF_MEM=${RUN}_compare_perf_mem${SUFFIX}

REPORT_COMPARE_PERF=$RUN_COMPARE_PERF/report.csv
REPORT_COMPARE_PERF_MEM=$RUN_COMPARE_PERF_MEM/report.csv


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

NUM_THREADS=${MLONMCU_NUM_THREADS:-4}

ETISS_PERF_SCRIPT=$ETISS_PERF_INSTALL_DIR/bin/run_helper.sh
ETISS_PERF_EXE=$ETISS_PERF_INSTALL_DIR/bin/bare_etiss_processor

PRINT_OUTPUTS=0

VERBOSE=${VERBOSE:-0}
VERBOSE_ARGS=""

if [[ "$VERBOSE" == "1" ]]
then
    VERBOSE_ARGS="-v"
fi
EXTRA_ARGS=""
if [[ "$BACKEND" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --backend $BACKEND"
fi

# TODO: PERF SIM
# PERF_UARCH="cv32e40pxisaac"  # TODO: do not hardcode, use INI
PERF_UARCH=$(cat $UARCHS_FILE | tail -n "+2" | cut -d, -f2 | head -1)
CONFIG_GEN_ARGS="--config-gen $PERF_TARGET.arch=$ARCH perf_sim.core=$PERF_UARCH"

if [[ ! -f $UARCHS_FILE ]]
then
    echo "Missing: $UARCHS_FILE"
    exit 1
fi

for uarch in $(cat $UARCHS_FILE | tail -n "+2" | cut -d, -f2)
do
    CONFIG_GEN_ARGS="$CONFIG_GEN_ARGS --config-gen $PERF_TARGET.arch=$FULL_ARCH perf_sim.core=$uarch"
done

echo python3 -m mlonmcu.cli.main flow run $BENCH --target $PERF_TARGET -c run.export_optional=1 -c $PERF_TARGET.arch=$ARCH -c $PERF_TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare-perf -c etissvp.script=$ETISS_PERF_SCRIPT -c etiss_perf.script=$ETISS_PERF_SCRIPT -c etiss_perf.cpu_arch=$CORE_NAME -c $PERF_TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --post config2cols -c config2cols.limit=$PERF_TARGET.arch,perf_sim.core --post rename_cols -c rename_cols.mapping="{'config_$PERF_TARGET.arch': 'Arch', 'config_perf_sim.core': 'uArch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions,Run Cycles" -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --parallel $NUM_THREADS $EXTRA_ARGS -f perf_sim -c etiss_perf.src_dir=$ETISS_DIR -c etiss_perf.exe=$ETISS_PERF_EXE -c etiss_perf.install_dir=$ETISS_PERF_INSTALL_DIR $CONFIG_GEN_ARGS
python3 -m mlonmcu.cli.main flow run $BENCH --target $PERF_TARGET -c run.export_optional=1 -c $PERF_TARGET.arch=$ARCH -c $PERF_TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare-perf -c etissvp.script=$ETISS_PERF_SCRIPT -c etiss_perf.script=$ETISS_PERF_SCRIPT -c etiss_perf.cpu_arch=$CORE_NAME -c $PERF_TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --post config2cols -c config2cols.limit=$PERF_TARGET.arch,perf_sim.core --post rename_cols -c rename_cols.mapping="{'config_$PERF_TARGET.arch': 'Arch', 'config_perf_sim.core': 'uArch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions,Run Cycles" -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --parallel $NUM_THREADS $EXTRA_ARGS -f perf_sim -c etiss_perf.src_dir=$ETISS_DIR -c etiss_perf.exe=$ETISS_PERF_EXE -c etiss_perf.install_dir=$ETISS_PERF_INSTALL_DIR $CONFIG_GEN_ARGS
python3 -m mlonmcu.cli.main export --session -f -- $RUN_COMPARE_PERF
# export ETISS_PERF_INSTALL_DIR
# export LLVM_INSTALL_DIR
# LABEL=$LABEL scripts/mlonmcu_wrapper.sh $RUN_COMPARE_PERF $BENCH

python3 -m mlonmcu.cli.main flow compile $BENCH --target $PERF_TARGET -c run.export_optional=1 -c $PERF_TARGET.arch=$ARCH -c $PERF_TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare-perf-mem -c etissvp.script=$ETISS_PERF_SCRIPT -c etiss_perf.script=$ETISS_PERF_SCRIPT -c etiss_perf.cpu_arch=$CORE_NAME -c $PERF_TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --post config2cols -c config2cols.limit=$PERF_TARGET.arch,perf_sim.core --post rename_cols -c rename_cols.mapping="{'config_$PERF_TARGET.arch': 'Arch', 'config_perf_sim.core': 'uArch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1 -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --parallel $NUM_THREADS $EXTRA_ARGS -f perf_sim -c etiss_perf.src_dir=$ETISS_DIR -c etiss_perf.exe=$ETISS_PERF_EXE -c etiss_perf.install_dir=$ETISS_PERF_INSTALL_DIR $CONFIG_GEN_ARGS
python3 -m mlonmcu.cli.main export --session -f -- $RUN_COMPARE_PERF_MEM
# export ETISS_PERF_INSTALL_DIR
# export LLVM_INSTALL_DIR
# LABEL=$LABEL-mem MEM_ONLY=1 scripts/mlonmcu_wrapper.sh $RUN_COMPARE_PERF_MEM $BENCH

echo python3 -m isaac_toolkit.utils.analyze_compare_perf ${REPORT_COMPARE_PERF} --mem-report ${REPORT_COMPARE_PERF_MEM} --print-df --output ${DIR}/compare_perf${SUFFIX}.csv
python3 -m isaac_toolkit.utils.analyze_compare_perf ${REPORT_COMPARE_PERF} --mem-report ${REPORT_COMPARE_PERF_MEM} --print-df --output ${DIR}/compare_perf${SUFFIX}.csv
python3 -m isaac_toolkit.utils.rank_uarchs ${DIR}/compare_perf${SUFFIX}.csv --uarchs-csv $UARCHS_FILE --print-df --output ${DIR}/uarch_ranking${SUFFIX}.csv
