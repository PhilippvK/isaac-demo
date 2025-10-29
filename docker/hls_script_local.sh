#!/bin/bash

# TODO: check min arg num

OUTPUT_DIR=$1
GEN_DIR=$2
echo "OUTPUT_DIR=$OUTPUT_DIR"
echo "GEN_DIR=$GEN_DIR"
shift 2

HLS_DIR=${HLS_DIR:-/path/to/isax-tools-integration}
GUROBI_LIC=${GUROBI_LIC:-""}

echo "HLS_DIR=$HLS_DIR"
echo "GUROBI_LIC=$GUROBI_LIC"

if [[ "$GUROBI_LIC" != "" ]]
then
  export GRB_LICENSE_FILE=$GUROBI_LIC
fi

set -e

cd $HLS_DIR/nailgun

BUILD_DIR=$OUTPUT_DIR/build_config
mkdir -p $OUTPUT_DIR

echo make BUILD_DIR=$BUILD_DIR ISAXES_DIR=$GEN_DIR CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR CORE=$CORE gen_config ci $@
# read -n 1
make BUILD_DIR=$BUILD_DIR ISAXES_DIR=$GEN_DIR CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR CORE=$CORE gen_config ci $@

# TODO: rm git dir in core files?
