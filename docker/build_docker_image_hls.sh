#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
IMAGE=philippvk/isaac-quickstart-hls
TAG=latest

HLS_DIR=${HLS_DIR:-/path/to/isax-tools-integration}

pwd

docker build -t $IMAGE:$TAG -f $TOP_DIR/docker/Dockerfile_hls $HLS_DIR
