#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

RUN_COMPARE=${RUN}_compare
RUN_COMPARE_MEM=${RUN}_compare_mem

REPORT_COMPARE=$RUN_COMPARE/report.csv
REPORT_COMPARE_MEM=$RUN_COMPARE_MEM/report.csv

TARGET=${TARGET:-etiss}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}

python3 -m mlonmcu.cli.main flow run $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=$CORE_NAME -c $TARGET.print_outputs=1 -c llvm.install_dir=$WORK/docker/llvm_install --config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=${ARCH}_xisaac --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions" -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE
python3 -m mlonmcu.cli.main export --session -f -- $RUN_COMPARE

python3 -m mlonmcu.cli.main flow compile $BENCH --target $TARGET -c run.export_optional=1 -c $TARGET.arch=$ARCH -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare-mem -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=XIsaacCore -c $TARGET.print_outputs=1 -c llvm.install_dir=$WORK/docker/llvm_install --config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=${ARCH}_xisaac --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1 -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE
python3 -m mlonmcu.cli.main export --session -f -- $RUN_COMPARE_MEM

python3 scripts/analyze_compare.py ${REPORT_COMPARE} --mem-report ${REPORT_COMPARE_MEM} --print-df --output ${DIR}/compare.csv
