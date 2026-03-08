#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=philippvk/isaac-quickstart-full
VARIANT=${VARIANT:-""}
if [[ "$VARIANT" != "" ]]
then
    DEFAULT_TAG=$VARIANT-latest
    MLONMCU_IMAGE=philippvk/isaac-quickstart-mlonmcu:$VARIANT-latest
else
    DEFAULT_TAG=latest
    MLONMCU_IMAGE=philippvk/isaac-quickstart-mlonmcu:latest
fi
TAG=${TAG:-$DEFAULT_TAG}

pwd

echo $DOCKER_PREFIX docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_full $TOP_DIR --build-arg MLONMCU_IMAGE=${MLONMCU_IMAGE}
$DOCKER_PREFIX docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_full $TOP_DIR --build-arg MLONMCU_IMAGE=${MLONMCU_IMAGE}
