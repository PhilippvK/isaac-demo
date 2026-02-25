#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
DOCKER_DIR=$TOP_DIR/docker

TAG=${1:-"latest"}

DOCKER_NAMESPACE=philippvk

DOCKER_IMAGE_PREFIX=isaac-quickstart-

# DOCKER_IMAGE_NAMES=(base extra etiss etiss-perf seal5 mlonmcu mlonmcu-min min full demo)
DOCKER_IMAGE_NAMES=(etiss etiss-perf seal5 mlonmcu mlonmcu-min min full demo)

for name in "${DOCKER_IMAGE_NAMES[@]}"; do
    DOCKER_IMAGE=$DOCKER_NAMESPACE/${DOCKER_IMAGE_PREFIX}${name}
    echo "DOCKER_IMAGE=$DOCKER_IMAGE"
    $DOCKER_PREFIX docker pull $DOCKER_IMAGE:$TAG
done
