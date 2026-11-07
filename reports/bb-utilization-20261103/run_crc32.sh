#!/bin/bash
set -eo pipefail
source scripts/env.sh
root=$PWD/reports/bb-utilization-20261103
export MLONMCU_HOME=$root/environment
export MPLCONFIGDIR=$root/matplotlib
arm=$1
bench=${2:-crc32}
resources=$root
if [[ $bench != crc32 ]]; then resources=$root/$bench; fi
export ISAAC_UTIL_RESOURCE_DIR=$resources
arch=rv32imfd
if [[ $arm != baseline ]]; then arch=${arch}_xisaac; fi
python -m mlonmcu.cli.main flow run "$bench" --backend none --target etiss \
 -c run.export_optional=1 -c mlif.toolchain=llvm -c llvm.install_dir="$resources/llvm/llvm_install" \
 -c etiss.script="$root/docker_etiss.py" \
 -c etiss.exe="$resources/etiss/etiss_install/bin/bare_etiss_processor" \
 -c etiss.cpu_arch=XIsaacCore -c etiss.arch="$arch" -c etiss.abi=ilp32d \
 -c mlif.debug_symbols=1 -c mlif.unroll_loops=0 -c mlif.optimize=3 -c mlif.global_isel=0 \
 -c mlif.num_threads=4 -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 \
 --label "bb-utilization-$bench-$arm"
python -m mlonmcu.cli.main export --run -f -- "$root/runs/$bench/$arm"
