#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

OUT_DIR_BASE=$(pwd)/out
OUT_DIR=out/$BENCH/$DATE
mkdir -p $OUT_DIR

RUN=$OUT_DIR/run
SESS=$OUT_DIR/sess
WORK=$OUT_DIR/work

TARGET=${TARGET:-etiss}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
GLOBAL_ISEL=${GLOBAL_ISEL:-0}

BACKEND=${BACKEND:-"none"}
LAYOUT=${LAYOUT:-default}
ENABLE_VEXT=${ENABLE_VEXT:-0}
VLEN=${VLEN:-1024}
ELEN=${ELEN:-32}
EMBEDDED_VEXT=${EMBEDDED_VEXT:-0}
FPU=${FPU:-default}
AUTO_VECTORIZE=${AUTO_VECTORIZE:-0}

EXTRA_ARGS=""

if [[ "$BACKEND" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --backend $BACKEND"
    if [[ "$LAYOUT" != "default" ]]
    then
        EXTRA_ARGS="$EXTRA_ARGS -c $BACKEND.desired_layout=$LAYOUT"
    fi
fi
if [[ "$FPU" != "default" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS -c $TARGET.fpu=$FPU"
fi
if [[ "$ENABLE_VEXT" == "1" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS -f vext -c vext.vlen=$VLEN -c vext.elen=$ELEN -c vext.embedded=$EMBEDDED_VEXT"
    if [[ "$AUTO_VECTORIZE" == "1" ]]
    then
        EXTRA_ARGS="$EXTRA_ARGS -f auto_vectorize"
    fi
fi

VERBOSE=${VERBOSE:-0}
VERBOSE_ARGS=""

if [[ "$VERBOSE" == "1" ]]
then
    VERBOSE_ARGS="-v"
fi

# python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-baseline -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL $EXTRA_ARGS
USE_MLONMCU_DOCKER=${USE_MLONMCU_DOCKER:-0}
USE_MLONMCU_MIN_DOCKER=${USE_MLONMCU_MIN_DOCKER:-0}
MLONMCU_ARGS="flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-baseline -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL $EXTRA_ARGS"
if [[ "$USE_MLONMCU_DOCKER" == "1" && "$USE_MLONMCU_MIN_DOCKER" == "1" ]]
then
    echo "USE_MLONMCU_DOCKER and USE_MLONMCU_MIN_DOCKER can not be enabled at the same time!"
    exit 1
elif [[ "$USE_MLONMCU_MIN_DOCKER" == "1" ]]
then
    MLONMCU_MIN_IMAGE=${MLONMCU_IMAGE:-philippvk/isaac-quickstart-mlonmcu-min:latest}
    docker run -i --rm -e MLONMCU_HOME=$MLONMCU_HOME -v $MLONMCU_HOME:$MLONMCU_HOME -v $(pwd):$(pwd) --workdir $(pwd) $MLONMCU_MIN_IMAGE $MLONMCU_ARGS
elif [[ "$USE_MLONMCU_DOCKER" == "1" ]]
then
    MLONMCU_IMAGE=${MLONMCU_IMAGE:-philippvk/isaac-quickstart-mlonmcu:latest}
    docker run -i --rm -v $(pwd):$(pwd) --workdir $(pwd) $MLONMCU_IMAGE $MLONMCU_ARGS
else
    python3 -m mlonmcu.cli.main $MLONMCU_ARGS
    # flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-baseline -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL $EXTRA_ARGS
fi
