#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=philippvk/isaac-quickstart-base
TAG=latest

USERNAME=isaac-dev
USER_UID=$(id -u)
USER_GID=$(id -g)


pwd

docker build --build-arg USERNAME=$USERNAME --build-arg USER_UID=$USER_UID --build-arg USER_GID=$USER_GID -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_base $TOP_DIR
