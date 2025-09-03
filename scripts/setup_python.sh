#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
VENV_DIR=$TOP_DIR/venv
# VENV_DIR=$TOP_DIR/venv_py38
# PYTHON_VER=python3.8
# PYTHON_EXE=/home/ga87puy/src/Python/cpython_v3.10/install/bin/python3.10
PYTHON_EXE=python3.8

echo "SCRIPT_DIR=${SCRIPT_DIR}"
echo "TOP_DIR=${TOP_DIR}"

# virtualenv -p $PYTHON_VER $VENV_DIR
${PYTHON_EXE} -m venv ${VENV_DIR}
source ${VENV_DIR}/bin/activate

pip install -r $TOP_DIR/requirements.txt
pip install -e $TOP_DIR/seal5
pip install -r $TOP_DIR/seal5/requirements.txt  # TODO

# TODO
