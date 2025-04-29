#!/bin/bash

set -e

if [[ "$#" -lt 2 ]]
then
    echo "Illegal number of parameters"
    exit 1
fi

OUT_BASE=$1
shift 1
BENCHMARKS="$@"


LABEL=${LABEL:-unknown}
TARGET=${TARGET:-etiss}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}
GLOBAL_ISEL=${GLOBAL_ISEL:-0}

ETISS_INSTALL_DIR=${ETISS_INSTALL_DIR:-""}
LLVM_INSTALL_DIR=${LLVM_INSTALL_DIR:-""}


CONFIG_GEN_ARGS=""
if [[ -f "$ARCHS_FILE" ]]
then
    for extra_arch in $(cat $ARCHS_FILE)
    do
        if [[ "$extra_arch" == "_" ]]
        then
            extra_arch=""
        fi
        CONFIG_GEN_ARGS="$CONFIG_GEN_ARGS --config-gen ${TARGET}.arch=${ARCH}${extra_arch}"
    done
elif [[ "$BUILD_ARCH" == "1" ]]
then

    NAMES_FILE=${NAMES_FILE:-""}

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
    CONFIG_GEN_ARGS="--config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=$FULL_ARCH"
else
    FULL_ARCH=${ARCH}_xisaac
    CONFIG_GEN_ARGS="--config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=$FULL_ARCH"
fi

NUM_THREADS=16  # TODO: do not hardcode


MEM_ONLY=${MEM_ONLY:-0}

EXTRA_ARGS=()

STAGE=run
if [[ "$MEM_ONLY" == "1" ]]
then
    EXTRA_ARGS+=("-c" "compare_rows.to_compare='ROM code'" "-c" "mlif.strip_strings=1")
else
    EXTRA_ARGS+=("-c" "compare_rows.to_compare=Run Instructions")
fi

echo ETISS_INSTALL_DIR=$ETISS_INSTALL_DIR
if [[ "$ETISS_INSTALL_DIR" != "" ]]
then
    ETISS_SCRIPT=$ETISS_INSTALL_DIR/bin/run_helper.sh
    echo ETISS_SCRIPT=$ETISS_SCRIPT
    EXTRA_ARGS+=("-c" "etissvp.script=$ETISS_SCRIPT")
fi

if [[ "$LLVM_INSTALL_DIR" != "" ]]
then
    EXTRA_ARGS+=("-c" "llvm.install_dir=$LLVM_INSTALL_DIR")
fi

PRINT_OUTPUTS=0
python3 -m mlonmcu.cli.main flow $STAGE $BENCHMARKS --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL -c etiss.cpu_arch=$CORE_NAME -c $TARGET.print_outputs=$PRINT_OUTPUTS $CONFIG_GEN_ARGS --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --parallel $NUM_THREADS "${EXTRA_ARGS[@]}"
python3 -m mlonmcu.cli.main export --session -f -- $OUT_BASE

# python3 -m mlonmcu.cli.main flow compile $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$CORE_NAME -c $TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=$FULL_ARCH --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --parallel $NUM_THREADS
# python3 -m mlonmcu.cli.main export --session -f -- $RUN_COMPARE_MEM

# python3 scripts/analyze_compare.py ${REPORT_COMPARE} --mem-report ${REPORT_COMPARE_MEM} --print-df --output ${DIR}/compare${SUFFIX}.csv
