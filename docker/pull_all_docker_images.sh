#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
DOCKER_DIR=$TOP_DIR/docker

TAG=${1:-"latest"}

# DOCKER_IMAGE_NAMES=(base extra etiss etiss_perf seal5 mlonmcu mlonmcu_min min full demo)
DOCKER_IMAGE_NAMES=(etiss etiss_perf seal5 mlonmcu mlonmcu_min min full demo)

for name in "${DOCKER_IMAGE_NAMES[@]}"; do
    DOCKER_IMAGE=$DOCKER_NAMESPACE/${DOCKER_IMAGE_PREFIX}${name}
    echo "DOCKER_IMAGE=$DOCKER_IMAGE"
    echo docker pull $DOCKER_IMAGE:$TAG
done
