#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)

# source $SCRIPT_DIR/env.sh

DOCKER_IMAGE=${DOCKER_IMAGE:-philippvk/isaac-quickstart-min:latest}
CONFIG=${CONFIG:-""}

docker run -i --rm --net=host -v $TOP_DIR/install/mlonmcu_temp:/environment/temp -v $TOP_DIR:$TOP_DIR -e CONFIG=$CONFIG --workdir $(pwd) $DOCKER_IMAGE $SCRIPT_DIR/full_flow_docker_min_script.sh $@
