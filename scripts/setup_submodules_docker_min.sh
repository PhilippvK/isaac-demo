#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
NPROC=$(nproc)
NUM_JOBS=${NUM_JOBS:-$NPROC}

SUBMODULES="isaac-toolkit memgraph_experiments M2-ISA-R etiss_arch_riscv etiss mlonmcu llvm-project"

# TODO: install isaac_toolkit via Python?
# TODO: move memgraph_experiments inside isaac_toolkit and install via pip
# TODO: install M2-ISA-R via Python?
# TODO: install mlonmcu via pip
# TODO: install seal5 via pip

echo git submodule update --init --recursive -j $NUM_JOBS -- $SUBMODULES
git submodule update --init --recursive -j $NUM_JOBS -- $SUBMODULES
