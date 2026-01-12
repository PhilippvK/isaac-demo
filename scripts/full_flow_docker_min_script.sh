#!/bin/bash

set -e

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPTS_DIR)

git config --global --add safe.directory $TOP_DIR/.git/modules/llvm-project
git config --global --add safe.directory "*"

source $SCRIPTS_DIR/env.sh
export MLONMCU_HOME=$TOP_DIR/install/mlonmcu
export MGCLIENT_INSTALL_DIR=/usr/local/
export HLS_DIR=/isax-tools/

if [[ -f "$CONFIG" ]]
then
    source $CONFIG
fi
# export GLOBAL_ISEL=1
rm -rf /root/.rustup/toolchains
conda clean -a

$SCRIPTS_DIR/full_flow.sh $@
