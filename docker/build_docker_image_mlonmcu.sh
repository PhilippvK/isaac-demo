#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=philippvk/isaac-quickstart-mlonmcu
CONFIG=${CONFIG:-""}
if [[ "$CONFIG" != "" ]]
then
    DEFAULT_TAG=$CONFIG-latest
    DEFAULT_MLONMCU_TEMPLATE=environment_docker_${CONFIG}.yml.j2
else
    DEFAULT_TAG=latest
    DEFAULT_MLONMCU_TEMPLATE=environment_docker.yml.j2
fi
TAG=${TAG:-$DEFAULT_TAG}
MLONMCU_TEMPLATE=${MLONMCU_TEMPLATE:-environment_docker.yml.j2}

pwd

# docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_mlonmcu $TOP_DIR
docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_mlonmcu $TOP_DIR --progress=plain --build-arg MLONMCU_TEMPLATE=${MLONMCU_TEMPLATE}
