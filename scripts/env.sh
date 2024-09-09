if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# TOP_DIR=$(dirname $SCRIPT_DIR)
TOP_DIR=$SCRIPT_DIR
export VENV_DIR=$TOP_DIR/venv
export INSTALL_DIR=$TOP_DIR/install
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
export MLONMCU_HOME=$INSTALL_DIR/mlonmcu

export MGCLIENT_LIB_DIR=$INSTALL_DIR/mgclient/lib
export LD_LIBRARY_PATH=${MGCLIENT_LIB_DIR}:$LD_LIBRARY_PATH
export PATH=$GNU_DIR/bin:$LLVM_INSTALL_DIR/bin:$ETISS_INSTALL_DIR/bin:$PATH
