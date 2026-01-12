#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

TARGET=${TARGET:-etiss}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
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

# python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm -f memgraph_llvm_cdfg -c memgraph_llvm_cdfg.session=$LABEL -c memgraph_llvm_cdfg.stage=$STAGE -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 -c mlif.num_threads=1 --label $LABEL-trace
# -f memgraph_llvm_cdfg -c memgraph_llvm_cdfg.session=$LABEL -c memgraph_llvm_cdfg.stage=$STAGE
echo python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 -c mlif.num_threads=$(nproc) -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --label $LABEL-trace $EXTRA_ARGS
python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 -c mlif.num_threads=$(nproc) -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL --label $LABEL-trace $EXTRA_ARGS -c cmake.exe=/opt/cmake/bin/cmake

python3 -m mlonmcu.cli.main export --run -f -- $RUN
