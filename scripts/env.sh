#!/bin/bash
if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
# echo "SCRIPT_DIR=$SCRIPT_DIR"
TOP_DIR=$(dirname $SCRIPT_DIR)
# echo "TOP_DIR=$TOP_DIR"
# TOP_DIR=$SCRIPT_DIR
export VENV_DIR=$TOP_DIR/venv
export INSTALL_DIR=$TOP_DIR/install
export DOCKER_DIR=$TOP_DIR/docker
export CONFIG_DIR=$TOP_DIR/cfg
export LLVM_DIR=$TOP_DIR/llvm-project
export CCACHE_DIR=$TOP_DIR/install/ccache
export GNU_DIR=$INSTALL_DIR/gnu
export LLVM_INSTALL_DIR=$INSTALL_DIR/llvm
export ETISS_INSTALL_DIR=$INSTALL_DIR/etiss

source $VENV_DIR/bin/activate

# export ISAAC_DIR=/work/git/isaac-toolkit
export ETISS_ARCH_DIR=${TOP_DIR}/etiss_arch_riscv
export ISAAC_DIR=${TOP_DIR}/isaac-toolkit
export SEAL5_DIR=${TOP_DIR}/seal5
export MLONMCU_DIR=${TOP_DIR}/mlonmcu
export MEMGRAPH_PY_DIR=${TOP_DIR}/memgraph_experiments
export M2ISAR_DIR=${TOP_DIR}/M2-ISA-R
export PYTHONPATH=${ISAAC_DIR}:${MEMGRAPH_PY_DIR}:${M2ISAR_DIR}:${SEAL5_DIR}:${MLONMCU_DIR}:$PYTHONPATH
export MLONMCU_HOME=${MLONMCU_HOME:-$INSTALL_DIR/mlonmcu}

export MGCLIENT_INSTALL_DIR=$INSTALL_DIR/mgclient
export MGCLIENT_LIB_DIR=$MGCLIENT_INSTALL_DIR/lib
export LD_LIBRARY_PATH=${MGCLIENT_LIB_DIR}:$LD_LIBRARY_PATH
export PATH=$GNU_DIR/bin:$LLVM_INSTALL_DIR/bin:$ETISS_INSTALL_DIR/bin:$PATH

DEFAULTS_FILE=$SCRIPT_DIR/defaults.env
source $DEFAULTS_FILE

# TODO: move elsewhere
export PATH=/nfs/tools/synopsys/syn/T-2022.03-SP5/linux64/syn/bin/:$PATH
export PATH=/nfs/tools/xilinx/Vivado/2024.1/bin:$PATH
