#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=philippvk/isaac-quickstart-seal5
TAG=latest

# Supply version metadata because the submodule's Git directory is not copied.
SEAL5_VERSION=${SEAL5_VERSION:-0+g$(git -C "$TOP_DIR/seal5" rev-parse --short=12 HEAD)}

pwd

$DOCKER_PREFIX docker build --build-arg "SEAL5_VERSION=$SEAL5_VERSION" -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_seal5 $TOP_DIR
