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

# BENCHMARKS=(cmsis_nn/arm_nn_activation_s16_tanh cmsis_nn/arm_nn_activation_s16_sigmoid cmsis_dsp/arm_abs_q15 cmsis_dsp/arm_abs_q31 rnnoise_INT8 coremark dhrystone embench/crc32 embench/nettle-aes embench/nettle-sha256 taclebench/kernel/md5)
BENCHMARKS=(arm_nn_activation_s16_tanh arm_nn_activation_s16_sigmoid arm_abs_q15 arm_abs_q31 rnnoise_INT8 coremark dhrystone crc32 nettle-aes nettle-sha256 kernel/md5)
BENCHMARKS=("${BENCHMARKS[@]/$BENCH}")

python3 -m mlonmcu.cli.main flow run ${BENCHMARKS[@]} --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=XIsaacCore -c etiss.print_outputs=1 -c llvm.install_dir=$WORK/docker/llvm_install --config-gen etiss.arch=rv32imfd --config-gen etiss.arch=rv32imfd_xisaac --post config2cols -c config2cols.limit=etiss.arch --post rename_cols -c rename_cols.mapping="{'config_etiss.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions" --parallel 4
python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_others
python3 scripts/analyze_reuse.py ${RUN}_compare_others/report.csv --print-df --output ${RUN}_compare_others.csv

python3 -m mlonmcu.cli.main flow compile ${BENCHMARKS[@]} --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare-mem -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=XIsaacCore -c etiss.print_outputs=1 -c llvm.install_dir=$WORK/docker/llvm_install --config-gen etiss.arch=rv32imfd --config-gen etiss.arch=rv32imfd_xisaac --post config2cols -c config2cols.limit=etiss.arch --post rename_cols -c rename_cols.mapping="{'config_etiss.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1 --parallel 4
python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_others_mem
python3 scripts/analyze_reuse.py ${RUN}_compare_others_mem/report.csv --print-df --mem --output ${RUN}_compare_others_mem.csv
