#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE
STAGE=32  # 32 -> post finalizeisel/expandpseudos

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=XIsaacCore -c etiss.print_outputs=1 -c llvm.install_dir=$WORK/docker/llvm_install --config-gen etiss.arch=rv32imfd --config-gen etiss.arch=rv32imfd_xisaac --post config2cols -c config2cols.limit=etiss.arch --post rename_cols -c rename_cols.mapping="{'config_etiss.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions"
python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare

python3 -m mlonmcu.cli.main flow compile $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare-mem -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=XIsaacCore -c etiss.print_outputs=1 -c llvm.install_dir=$WORK/docker/llvm_install --config-gen etiss.arch=rv32imfd --config-gen etiss.arch=rv32imfd_xisaac --post config2cols -c config2cols.limit=etiss.arch --post rename_cols -c rename_cols.mapping="{'config_etiss.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1
python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_mem
