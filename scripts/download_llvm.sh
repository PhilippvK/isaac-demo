#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
INSTALL_DIR=$TOP_DIR/install
LLVM_INSTALL_DIR=$INSTALL_DIR/llvm

if [[ -d "$LLVM_INSTALL_DIR" ]]
then
    echo "LLVM_INSTALL_DIR ($LLVM_INSTALL_DIR) already exists!"
    exit 1
fi

$SCRIPT_DIR/download_helper.sh $LLVM_INSTALL_DIR llvm_isaac_llvm_20251111 19.1.0
