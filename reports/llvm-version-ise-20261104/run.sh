#!/bin/bash
set -eo pipefail
source scripts/env.sh
root=$PWD/reports/llvm-version-ise-20261104
old=$PWD/reports/bb-utilization-20261103
export MLONMCU_HOME=$root/environment MPLCONFIGDIR=$root/matplotlib
mkdir -p "$MLONMCU_HOME"
cp -n "$root/environment.yml" "$MLONMCU_HOME/environment.yml" || true
bench=$1
major=$2
arm=$3
resources=$old
if [[ $bench != crc32 ]]; then resources=$old/$bench; fi
export ISAAC_UTIL_RESOURCE_DIR=$resources
compiler=$resources/llvm/llvm_install
if [[ $major == 22 ]]; then
 compiler=$PWD/llvm-project-22/build
 if [[ $bench == crc32 ]]; then compiler=$root/crc32-llvm22; fi
 if [[ $bench == nettle-sha256 && -d $root/sha256-llvm22/compiler ]]; then compiler=$root/sha256-llvm22/compiler; fi
fi
arch=rv32imfd
if [[ $arm == ise ]]; then arch=${arch}_xisaac; fi
python -m mlonmcu.cli.main flow run "$bench" --backend none --target etiss \
 -c run.export_optional=1 -c mlif.toolchain=llvm -c llvm.install_dir="$compiler" \
 -c etiss.script="$root/docker_etiss.py" \
 -c etiss.exe="$resources/etiss/etiss_install/bin/bare_etiss_processor" \
 -c etiss.cpu_arch=XIsaacCore -c etiss.arch="$arch" -c etiss.abi=ilp32d \
 -c mlif.debug_symbols=1 -c mlif.unroll_loops=0 -c mlif.optimize=3 -c mlif.global_isel=0 \
 -c cmake.exe="$root/cmake.sh" -c mlif.num_threads=4 -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 \
 --label "llvm-version-$bench-$major-$arm"
python -m mlonmcu.cli.main export --run -f -- "$root/runs/$bench/$major/$arm"
python - "$root" "$bench" "$major" "$arm" <<'PY'
from pathlib import Path
import gzip,shutil,sys
root=Path(sys.argv[1]); run=root/'runs'/sys.argv[2]/sys.argv[3]/sys.argv[4]
p=run/'etiss_instrs.log'
with p.open('rb') as src,gzip.open(str(p)+'.gz','wb',compresslevel=1) as dst:shutil.copyfileobj(src,dst)
p.unlink()
for p in (root/'environment/results').glob('**/etiss_instrs.log'):p.unlink()
PY
