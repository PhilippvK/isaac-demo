#!/bin/bash
# Prepare the local LLVM22 CDFG source without changing the LLVM19 checkout.
set -euo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TOP_DIR=$(dirname "$SCRIPT_DIR")
LLVM22_DIR=${LLVM22_DIR:-$TOP_DIR/llvm-project-22}
LLVM22_REPO=${LLVM22_REPO:-https://github.com/llvm/llvm-project.git}
LLVM22_REF=llvmorg-22.1.8
EXPECTED_COMMIT=ca7933e47d3a3451d81e72ac174dcb5aa28b59d1
PATCH=$TOP_DIR/cfg/seal5/llvm22-isaac.patch
if [[ ! -e "$LLVM22_DIR/.git" ]]; then
    git clone --filter=blob:none --depth=1 --sparse --single-branch --branch "$LLVM22_REF" "$LLVM22_REPO" "$LLVM22_DIR"
fi
if [[ "$(git -C "$LLVM22_DIR" rev-parse HEAD)" != "$EXPECTED_COMMIT" ]]; then
    echo "Expected pristine LLVM22.1.8 ancestry at HEAD. Choose a fresh LLVM22_DIR for preparation; existing source was preserved." >&2
    exit 1
fi
# Complete an interrupted sparse checkout, and pick up new source dependencies.
if [[ "$(git -C "$LLVM22_DIR" config --bool core.sparseCheckout || true)" == true || ! -f "$LLVM22_DIR/llvm/CMakeLists.txt" ]]; then
    git -C "$LLVM22_DIR" sparse-checkout set --no-cone --stdin < "$TOP_DIR/cfg/llvm22/sparse-patterns.txt"
    git -C "$LLVM22_DIR" read-tree -mu HEAD
fi
if git -C "$LLVM22_DIR" apply --reverse --check "$PATCH" 2>/dev/null; then
    echo "LLVM22 ISAAC source patch is already applied: $LLVM22_DIR"
else
    git -C "$LLVM22_DIR" apply --check "$PATCH"
    git -C "$LLVM22_DIR" apply "$PATCH"
    echo "Applied LLVM22 ISAAC source patch: $LLVM22_DIR"
fi
