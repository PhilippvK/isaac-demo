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

# TODO
BACKEND=${BACKEND:-""}
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


python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-baseline -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL $EXTRA_ARGS
