#!/bin/bash

if [ "$#" -lt 4 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

OUTPUT_DIR=$1
GEN_DIR=$2
echo "OUTPUT_DIR=$OUTPUT_DIR"
echo "GEN_DIR=$GEN_DIR"
shift 2

HLS_DIR=${HLS_DIR:-/isax-tools}
GUROBI_LIC=${GUROBI_LIC:-""}

echo "HLS_DIR=$HLS_DIR"
echo "GUROBI_LIC=$GUROBI_LIC"

if [[ "$GUROBI_LIC" != "" ]]
then
  export GRB_LICENSE_FILE=$GUROBI_LIC
fi

set -e

cd $HLS_DIR/nailgun

umask 022

BUILD_DIR=$OUTPUT_DIR/build_config
mkdir -p $OUTPUT_DIR

chmod 777 -R $OUTPUT_DIR

echo make BUILD_DIR=$BUILD_DIR ISAXES_DIR=$GEN_DIR CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR gen_config ci $@
make BUILD_DIR=$BUILD_DIR ISAXES_DIR=$GEN_DIR CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR gen_config ci $@

chmod 777 -R $OUTPUT_DIR
