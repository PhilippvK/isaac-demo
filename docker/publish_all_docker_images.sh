#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
DOCKER_DIR=$TOP_DIR/docker

DOCKER_NAMESPACE=philippvk

DOCKER_IMAGE_PREFIX=isaac-quickstart-

DOCKER_IMAGE_NAMES=(base extra etiss etiss-perf seal5 mlonmcu-min min)
DOCKER_IMAGE_NAMES2=(mlonmcu full demo)  # VARIANT SPECIFIC

TAG=${1:-"latest"}
VARIANT=${VARIANT:-""}
if [[ "$VARIANT" != "" ]]
then
    TAG2=$VARIANT-$TAG
else
    TAG2=$TAG
fi

for name in "${DOCKER_IMAGE_NAMES[@]}"; do
    DOCKER_IMAGE=$DOCKER_NAMESPACE/${DOCKER_IMAGE_PREFIX}${name}
    echo "DOCKER_IMAGE=$DOCKER_IMAGE"
    if [[ "$TAG" != "" ]]
    then
        echo $DOCKER_PREFIX docker tag $DOCKER_IMAGE:latest $DOCKER_IMAGE:$TAG
        $DOCKER_PREFIX docker tag $DOCKER_IMAGE:latest $DOCKER_IMAGE:$TAG
    fi
    echo $DOCKER_PREFIX docker push $DOCKER_IMAGE:$TAG
    $DOCKER_PREFIX docker push $DOCKER_IMAGE:$TAG
done
for name in "${DOCKER_IMAGE_NAMES2[@]}"; do
    DOCKER_IMAGE=$DOCKER_NAMESPACE/${DOCKER_IMAGE_PREFIX}${name}
    echo "DOCKER_IMAGE=$DOCKER_IMAGE"
    if [[ "$TAG2" != "" ]]
    then
        echo docker tag $DOCKER_IMAGE:latest $DOCKER_IMAGE:$TAG2
        docker tag $DOCKER_IMAGE:latest $DOCKER_IMAGE:$TAG2
    fi
    echo $DOCKER_PREFIX docker push $DOCKER_IMAGE:$TAG2
    $DOCKER_REFIX docker push $DOCKER_IMAGE:$TAG2
done
