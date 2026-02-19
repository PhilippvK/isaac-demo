#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
SCRIPTS_DIR=$TOP_DIR/scripts
VENV_DIR=${VENV_DIR:-$TOP_DIR/venv}

CONFIG=${CONFIG:-""}

# source $VENV_DIR/bin/activate
source $SCRIPTS_DIR/env.sh

if [[ -f "$CONFIG" ]]
then
    source $CONFIG
fi

$SCRIPTS_DIR/full_flow.sh "$@"
