#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
BASE_IMAGE=philippvk/isaac-quickstart-demo
IMAGE=philippvk/isaac-quickstart-demo
TAG=latest

$DOCKER_PREFIX docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_demo_refresh --build-arg BASE_IMAGE=$BASE_IMAGE $TOP_DIR
