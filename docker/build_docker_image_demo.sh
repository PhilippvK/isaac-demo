#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=philippvk/isaac-quickstart-demo
CONFIG=${CONFIG:-""}
if [[ "$CONFIG" != "" ]]
then
    DEFAULT_TAG=$CONFIG-latest
else
    DEFAULT_TAG=latest
fi
TAG=${TAG:-$DEFAULT_TAG}

pwd

$DOCKER_PREFIX docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_demo $TOP_DIR --build-arg CONFIG=$CONFIG --build-arg BASE_IMAGE=philippvk/isaac-quickstart-full:$TAG
