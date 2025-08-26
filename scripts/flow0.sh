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

VERBOSE=${VERBOSE:-0}
VERBOSE_ARGS=""

if [[ "$VERBOSE" == "1" ]]
then
    VERBOSE_ARGS="-v"
fi

python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-baseline -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL
