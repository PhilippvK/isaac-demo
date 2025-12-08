#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
INSTALL_DIR=${INSTALL_DIR:-$TOP_DIR/install}
MGCLIENT_DIR=${MGCLIENT_DIR:-$TOP_DIR/mgclient}
MGCLIENT_BUILD_DIR=${MGCLIENT_BUILD_DIR:-$MGCLIENT_DIR/build}
MGCLIENT_INSTALL_DIR=${MGCLIENT_INSTALL_DIR:-$INSTALL_DIR/mgclient}
CMAKE_BUILD_TYPE=${MGCLIENT_BUILD_TYPE:-Release}
CMAKE_EXTRA_ARGS=("-DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE")
CCACHE=${CCACHE:-1}
if [[ "$CCACHE" -eq 1 ]]
then
    CMAKE_EXTRA_ARGS+=("-DCMAKE_C_COMPILER_LAUNCHER=ccache")
    CMAKE_EXTRA_ARGS+=("-DCMAKE_CXX_COMPILER_LAUNCHER=ccache")
fi

mkdir -p $MGCLIENT_BUILD_DIR

cmake -B $MGCLIENT_BUILD_DIR -S $MGCLIENT_DIR -DCMAKE_INSTALL_PREFIX:PATH=$MGCLIENT_INSTALL_DIR "${CMAKE_EXTRA_ARGS[@]}"

cmake --build $MGCLIENT_BUILD_DIR -j$(nproc)
cmake --install $MGCLIENT_BUILD_DIR

test -f /usr/local/lib/libmgclient.so || sudo ln -s $MGCLIENT_INSTALL_DIR/lib/libmgclient.so /usr/local/lib/libmgclient.so
