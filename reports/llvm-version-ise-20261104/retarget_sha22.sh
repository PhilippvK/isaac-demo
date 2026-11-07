#!/bin/bash
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$ROOT"
export PATH="$ROOT/venv/bin:$PATH"
export PYTHONPATH="$ROOT/seal5:$ROOT/M2-ISA-R:$ROOT/isaac-toolkit"
export LD_LIBRARY_PATH="$ROOT/install/mgclient/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export SEAL5_HOME="$ROOT/llvm-project-22" SEAL5_M2ISAR_DIR="$ROOT/M2-ISA-R"
export LLVM_MAJOR=22 RESET=0 CCACHE=0 CLEANUP=0 VERBOSE=0 INSTALL=0 DEPLOY=0 EXPORT=1 TEST=1
export SEAL5_START_AT=${SEAL5_START_AT:-models}
export SEAL5_BUILD_THREADS=10 SEAL5_NUM_THREADS=1 MGCLIENT_ROOT="$ROOT/install/mgclient"
export CMAKE_EXTRA_ARGS="-DLLVM_OPTIMIZED_TABLEGEN=OFF,-DLLVM_TARGETS_TO_BUILD=RISCV,-DLLVM_ENABLE_ASSERTIONS=ON,-DLLVM_USE_RELATIVE_PATHS_IN_DEBUG_INFO=OFF,-DLLVM_INCLUDE_TESTS=ON,-DCLANG_INCLUDE_TESTS=OFF,-DLLD_INCLUDE_TESTS=OFF"
bash docker/seal5_script_local.sh "$ROOT/reports/llvm-version-ise-20261104/sha256-llvm22" "$ROOT/reports/bb-quality-20261102/runs/nettle-sha256/20261102T170300/work-new/gen/XIsaac.seal5.core_desc"
