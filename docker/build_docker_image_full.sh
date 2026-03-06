#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=philippvk/isaac-quickstart-full
CONFIG=${CONFIG:-""}
if [[ "$CONFIG" != "" ]]
then
    DEFAULT_TAG=$CONFIG-latest
    MLONMCU_IMAGE=philippvk/isaac-quickstart-full:$CONFIG-latest
else
    DEFAULT_TAG=latest
    MLONMCU_IMAGE=philippvk/isaac-quickstart-full:latest
fi
TAG=${TAG:-$DEFAULT_TAG}

pwd

docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_full $TOP_DIR --build-arg MLONMCU_IMAGE=${MLONMCU_IMAGE}
