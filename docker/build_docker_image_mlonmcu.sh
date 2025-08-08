#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=isaac-quickstart-mlonmcu
TAG=latest

pwd

docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_mlonmcu $TOP_DIR
