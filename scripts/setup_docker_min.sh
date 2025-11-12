#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)

DOCKER_IMAGE=${DOCKER_IMAGE:-philippvk/isaac-quickstart-full:latest}

echo docker run -i --rm -v $TOP_DIR:$TOP_DIR --workdir $(pwd) $DOCKER_IMAGE $SCRIPT_DIR/setup_docker_min_script.sh $@
docker run -i --rm -v $TOP_DIR:$TOP_DIR --workdir $(pwd) $DOCKER_IMAGE $SCRIPT_DIR/setup_docker_min_script.sh $@
