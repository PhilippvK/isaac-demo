#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)

# source $SCRIPT_DIR/env.sh

DOCKER_IMAGE=${DOCKER_IMAGE:-philippvk/isaac-quickstart-demo:latest}
CONFIG=${CONFIG:-""}
DOCKER_PREFIX=${DOCKER_PREFIX:-""}
OUT_DIR_BASE=$(realpath ${OUT_DIR_BASE:-$TOP_DIR/out})

# Make sure docker volume exists
$SCRIPT_DIR/setup_ccache_docker.sh

VOLUME_NAME=${DOCKER_CCACHE_VOLUME:-"isaac-ccache"}

$DOCKER_PREFIX docker run -i --rm --net=host -v $TOP_DIR/install/mlonmcu_temp:/environment/temp -v $TOP_DIR:$TOP_DIR -v $VOLUME_NAME:/root/.ccache -e CONFIG=$CONFIG -e OUT_DIR_BASE=$OUT_DIR_BASE --workdir /demo $DOCKER_IMAGE $@
