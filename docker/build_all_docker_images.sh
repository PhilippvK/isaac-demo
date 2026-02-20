#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
DOCKER_DIR=$TOP_DIR/docker

DOCKER_NAMESPACE=philippvk

DOCKER_IMAGE_PREFIX=isaac-quickstart-

DOCKER_IMAGE_NAMES=(base extra etiss etiss-perf seal5 mlonmcu mlonmcu-min min full demo)

TAG=${1:-"latest"}

for name in "${DOCKER_IMAGE_NAMES[@]}"; do
    DOCKER_IMAGE=$DOCKER_NAMESPACE/${DOCKER_IMAGE_PREFIX}${name}
    echo "DOCKER_IAMGE=$DOCKER_IMAGE"
    name2=${name/-/_}
    echo $DOCKER_DIR/build_docker_image_${name2}.sh
    $DOCKER_DIR/build_docker_image_${name}.sh
done
