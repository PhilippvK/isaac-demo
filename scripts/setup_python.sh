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
# VENV_DIR=$TOP_DIR/venv_py38
# PYTHON_VER=python3.8
# PYTHON_EXE=/home/ga87puy/src/Python/cpython_v3.10/install/bin/python3.10
PYTHON_EXE=${PYTHON_EXE:-python}

echo "SCRIPT_DIR=${SCRIPT_DIR}"
echo "TOP_DIR=${TOP_DIR}"

# virtualenv -p $PYTHON_VER $VENV_DIR
${PYTHON_EXE} -m venv ${VENV_DIR}
source ${VENV_DIR}/bin/activate

pip install -r $TOP_DIR/requirements.txt
if [[ -e "$TOP_DIR/seal5/.git" ]]
then
    pip install -e $TOP_DIR/seal5
    pip install -r $TOP_DIR/seal5/requirements.txt  # TODO
fi
if [[ -e "$TOP_DIR/isaac-toolkit/.git" ]]
then
    pip install -e $TOP_DIR/isaac-toolkit
fi
if [[ -e "$TOP_DIR/mlonmcu/.git" ]]
then
    pip install -e $TOP_DIR/mlonmcu
fi
if [[ -e "$TOP_DIR/memgraph_experiments/.git" ]]
then
    pip install -r $TOP_DIR/memgraph_experiments/requirements.txt
fi

# TODO
