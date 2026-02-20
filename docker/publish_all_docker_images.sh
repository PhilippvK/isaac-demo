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
    echo "DOCKER_IMAGE=$DOCKER_IMAGE"
    if [[ "$TAG" != "" ]]
    then
        echo docker tag $DOCKER_IMAGE:latest $DOCKER_IMAGE:$TAG
        docker tag $DOCKER_IMAGE:latest $DOCKER_IMAGE:$TAG
    fi
    echo docker push $DOCKER_IMAGE:$TAG
    docker push $DOCKER_IMAGE:$TAG
done
