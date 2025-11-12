#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)

apt -y update
apt -y install graphviz libgraphviz-dev

$SCRIPT_DIR/setup_python.sh
# $SCRIPT_DIR/setup_python_docker.sh
. $SCRIPT_DIR/env.sh
$SCRIPT_DIR/setup_ccache.sh
# $SCRIPT_DIR/setup_mgclient.sh
# $SCRIPT_DIR/setup_llvm.sh
$SCRIPT_DIR/setup_etiss.sh
$SCRIPT_DIR/setup_mlonmcu.sh
