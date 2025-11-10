#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=philippvk/isaac-quickstart-seal5
TAG=latest

pwd

docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_seal5 $TOP_DIR
