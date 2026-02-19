#!/bin/bash

set -e

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPTS_DIR)
echo "@=$@"

git config --global --add safe.directory $TOP_DIR/.git/modules/llvm-project
git config --global --add safe.directory "*"

source $SCRIPTS_DIR/env.sh
if [[ -f "$CONFIG" ]]
then
    source $CONFIG
fi
# export PYTHON_EXE=${PYTHON_EXE:-python3.10}
# $SCRIPTS_DIR/setup_python_docker.sh

$SCRIPTS_DIR/full_flow.sh $@
