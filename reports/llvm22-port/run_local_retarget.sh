#!/bin/bash
# Run after the baseline LLVM22 build and checks. Reuse its object files.
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$ROOT"
export PATH="$ROOT/venv/bin:$PATH"
export PYTHONPATH="$ROOT/seal5:$ROOT/M2-ISA-R-new:$ROOT/isaac-toolkit"
export LD_LIBRARY_PATH="$ROOT/install/mgclient/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export SEAL5_HOME="$ROOT/llvm-project-22"
export SEAL5_M2ISAR_DIR=${SEAL5_M2ISAR_DIR:-$ROOT/M2-ISA-R-new}
export LLVM_MAJOR=22
export LLVM_REPO=https://github.com/llvm/llvm-project.git
export LLVM_REF=llvmorg-22.1.8
export RESET=0 CCACHE=0 CLEANUP=0 VERBOSE=0 INSTALL=0 DEPLOY=0 EXPORT=1 TEST=1
export SEAL5_BUILD_THREADS=10 SEAL5_NUM_THREADS=1
export MGCLIENT_ROOT="$ROOT/install/mgclient"
# Keep the host build options identical to the completed baseline build.
export CMAKE_EXTRA_ARGS="-DLLVM_OPTIMIZED_TABLEGEN=OFF,-DLLVM_TARGETS_TO_BUILD=RISCV,-DLLVM_ENABLE_ASSERTIONS=ON,-DLLVM_USE_RELATIVE_PATHS_IN_DEBUG_INFO=OFF,-DLLVM_INCLUDE_TESTS=ON,-DCLANG_INCLUDE_TESTS=OFF,-DLLD_INCLUDE_TESTS=OFF"
INPUT="$ROOT/reports/bb-quality-20261102/runs/crc32/20261102T160334/work-new/gen/XIsaac.seal5.core_desc"
bash docker/seal5_script_local.sh "$ROOT/reports/llvm22-port/local-retarget" "$INPUT"
