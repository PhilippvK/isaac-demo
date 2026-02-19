#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
if [[ ! -z "$IN_DEMO_DOCKER" ]]
then
    VENV_DIR=${VENV_DIR:-/venv}
else
    VENV_DIR=${VENV_DIR:-$TOP_DIR/venv}
fi

source $VENV_DIR/bin/activate

"$@"
