#!/bin/bash

set -e

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPTS_DIR)
echo "@=$@"

echo "A"
git config --global --add safe.directory $TOP_DIR/.git/modules/llvm-project

source $SCRIPTS_DIR/env.sh
echo "B"
if [[ -f "$CONFIG" ]]
then
    echo "C"
    source $CONFIG
fi
echo "D"

$SCRIPTS_DIR/full_flow.sh $@
echo "E"
