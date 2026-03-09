#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=philippvk/isaac-quickstart-demo
VARIANT=${VARIANT:-""}
if [[ "$VARIANT" != "" ]]
then
    DEFAULT_TAG=$VARIANT-latest
else
    DEFAULT_TAG=latest
fi
TAG=${TAG:-$DEFAULT_TAG}

DEFAULT_CONFIG=cfg/flow/paper/vex_5s.env
if [[ "$VARIANT" == "" ]]
then
    CONFIG=$DEFAULT_CONFIG
else
    CONFIG=${CONFIG:-cfg/flow/paper/$VARIANT.env}
fi

$DOCKER_PREFIX docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_demo $TOP_DIR --build-arg CONFIG=$CONFIG --build-arg BASE_IMAGE=philippvk/isaac-quickstart-full:$TAG
