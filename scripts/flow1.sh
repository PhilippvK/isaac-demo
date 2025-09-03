#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

STAGE="default"
STAGE_DIR=$DIR/$STAGE
RUN=$STAGE_DIR/run
SESS=$STAGE_DIR/sess
WORK=$STAGE_DIR/work

TARGET=${TARGET:-etiss}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
GLOBAL_ISEL=${GLOBAL_ISEL:-0}

VERBOSE=${VERBOSE:-0}
VERBOSE_ARGS=""

if [[ "$VERBOSE" == "1" ]]
then
    VERBOSE_ARGS="-v"
fi

# python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm -f memgraph_llvm_cdfg -c memgraph_llvm_cdfg.session=$LABEL -c memgraph_llvm_cdfg.stage=$STAGE -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 -c mlif.num_threads=1 --label $LABEL-trace
test -d $RUN && rm -rf $RUN || :
# -f memgraph_llvm_cdfg -c memgraph_llvm_cdfg.session=$LABEL -c memgraph_llvm_cdfg.stage=$STAGE
python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 -c mlif.num_threads=$(nproc) -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --label $LABEL-trace --dest ${RUN}

# python3 -m mlonmcu.cli.main export --run -f -- $RUN
