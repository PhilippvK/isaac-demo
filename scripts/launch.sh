#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
VENV_DIR=${VENV_DIR:-$TOP_DIR/venv}

echo VENV=$VENV_DIR

source $VENV_DIR/bin/activate

python3 -m pip list

$@
