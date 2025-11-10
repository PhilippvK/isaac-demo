#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)

INSTALL_DIR=$TOP_DIR/install
CCACHE_DIR=$INSTALL_DIR/ccache

# TODO: check that defined

# export CCACHE_DIR

mkdir -p $CCACHE_DIR

echo "Initializing ccache directory: $CCACHE_DIR"

echo "max_size = 5.0G\n" > $CCACHE_DIR/ccache.conf
echo "base_dir = $TOP_DIR" >> $CCACHE_DIR/ccache.conf
echo "absolute_paths_in_stderr = true" >> $CCACHE_DIR/ccache.conf

# print stats

ccache -s
