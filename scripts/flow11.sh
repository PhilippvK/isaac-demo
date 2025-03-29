#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
WORK=$DIR/work

# echo "$WORK/docker/llvm_install"
# sleep 10

RUN2=${RUN}_new

TARGET=${TARGET:-etiss}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}

echo "!=$RUN2/generic_mlonmcu"


python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 --label $LABEL-trace2 -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=$CORE_NAME -c llvm.install_dir=$WORK/docker/llvm_install -c $TARGET.arch=${ARCH}_xisaac

python3 -m mlonmcu.cli.main export --run -f -- $RUN2
