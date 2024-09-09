#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
INSTALL_DIR=$TOP_DIR/install
LLVM_DIR=$TOP_DIR/llvm-project
LLVM_BUILD_DIR=$LLVM_DIR/build
LLVM_INSTALL_DIR=$INSTALL_DIR/etiss
CMAKE_BUILD_TYPE=Release

LLVM_INSTALL_DIR=$INSTALL_DIR/llvm
# CMAKE_EXTRA_ARGS=("-DLLVM_BUILD_TOOLS=OFF")
CMAKE_EXTRA_ARGS=("-DLLVM_BUILD_TOOLS=ON")
CMAKE_BUILD_TYPE=Release
# CMAKE_BUILD_TYPE=Debug
# LLVM_ENABLE_ASSERTIONS=OFF
LLVM_ENABLE_ASSERTIONS=ON
LLVM_ENABLE_PROJECTS="clang;lld"
LLVM_TARGETS_TO_BUILD="X86;RISCV"
LLVM_OPTIMIZED_TABLEGEN=True

NPROC=$(nproc)
MAX_LINK_JOBS=$(free --giga | grep Mem | awk '{print int($2 / 16)}')

mkdir -p $LLVM_BUILD_DIR

echo cmake -B "$LLVM_BUILD_DIR" "$LLVM_DIR/llvm/" -G Ninja -DLLVM_ENABLE_PROJECTS=$LLVM_ENABLE_PROJECTS \
      "-DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE" "-DCMAKE_INSTALL_PREFIX=$LLVM_INSTALL_DIR" \
      -DLLVM_TARGETS_TO_BUILD=$LLVM_TARGETS_TO_BUILD -DLLVM_OPTIMIZED_TABLEGEN=$LLVM_OPTIMIZED_TABLEGEN \
      "-DLLVM_ENABLE_ASSERTIONS=$LLVM_ENABLE_ASSERTIONS" -DLLVM_CCACHE_BUILD=False \
      "-DLLVM_PARALLEL_LINK_JOBS=$MAX_LINK_JOBS" "${CMAKE_EXTRA_ARGS[@]}"

echo cmake --build "$LLVM_BUILD_DIR" "-j$NPROC"

# cmake --build $LLVM_BUILD_DIR -j$NPROC -t llvm-config
# cmake --build $LLVM_BUILD_DIR -j$NPROC -t llvm-objdump
# cmake --build $LLVM_BUILD_DIR -j$NPROC -t llc
# cmake --build $LLVM_BUILD_DIR -j$NPROC -t opt

echo cmake --install "$LLVM_BUILD_DIR"

#     cp $LLVM_BUILD_DIR/bin/llvm-config $LLVM_INSTALL_DIR/bin/
#     cp $LLVM_BUILD_DIR/bin/llvm-objdump $LLVM_INSTALL_DIR/bin
#     cp $LLVM_BUILD_DIR/bin/llc $LLVM_INSTALL_DIR/bin
#     cp $LLVM_BUILD_DIR/bin/opt $LLVM_INSTALL_DIR/bin
#     rm -f $LLVM_INSTALL_DIR/bin/clang-repl
#     rm -f $LLVM_INSTALL_DIR/bin/clang-scan-deps
#     rm -f $LLVM_INSTALL_DIR/bin/clang-check
#     rm -f $LLVM_INSTALL_DIR/bin/clang-refactor
#     rm -f $LLVM_INSTALL_DIR/bin/clang-rename
#     rm -f $LLVM_INSTALL_DIR/bin/clang-extdef-mapping
