#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
# SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%x}}")" >/dev/null 2>&1 && pwd)"
TOP_DIR=$(dirname $SCRIPT_DIR)
INSTALL_DIR=$TOP_DIR/install
MLONMCU_TEMPLATE=$TOP_DIR/environment.yml.j2
MLONMCU_HOME=$INSTALL_DIR/mlonmcu
ETISS_DIR=$TOP_DIR/etiss
ETISS_INSTALL_DIR=$INSTALL_DIR/etiss
LLVM_INSTALL_DIR=$INSTALL_DIR/llvm

TEMPLATE_LLVM_ARGS="-c llvm_install_dir=$LLVM_INSTALL_DIR"
TEMPLATE_ETISS_ARGS="-c etiss_dir=$ETISS_DIR etiss_install_dir=$ETISS_INSTALL_DIR"

python -m mlonmcu.cli.main init -t "$MLONMCU_TEMPLATE" "$MLONMCU_HOME" --non-interactive --allow-exists --clone-models $TEMPLATE_LLVM_ARGS $TEMPLATE_ETISS_ARGS

python -m mlonmcu.cli.main setup -g

python -m pip install -r "$MLONMCU_HOME/requirements_addition.txt"

python -m mlonmcu.cli.main setup -v --rebuild
