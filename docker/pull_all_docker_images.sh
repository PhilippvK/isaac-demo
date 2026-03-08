#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
DOCKER_DIR=$TOP_DIR/docker

TAG=${1:-"latest"}
VARIANT=${VARIANT:-""}
if [[ "$VARIANT" != "" ]]
then
    TAG2=$VARIANT-$TAG
else
    TAG2=$TAG
fi

DOCKER_NAMESPACE=philippvk
DOCKER_IMAGE_PREFIX=isaac-quickstart-

# DOCKER_IMAGE_NAMES=(base extra etiss etiss_perf seal5 mlonmcu mlonmcu_min min full demo)
DOCKER_IMAGE_NAMES=(etiss etiss-perf seal5 mlonmcu-min min)
DOCKER_IMAGE_NAMES2=(mlonmcu full demo)  # VARIANT specific

for name in "${DOCKER_IMAGE_NAMES[@]}"; do
    DOCKER_IMAGE=$DOCKER_NAMESPACE/${DOCKER_IMAGE_PREFIX}${name}
    echo "DOCKER_IMAGE=$DOCKER_IMAGE"
    echo $DOCKER_PREFIX docker pull $DOCKER_IMAGE:$TAG
    $DOCKER_PREFIX docker pull $DOCKER_IMAGE:$TAG
done

for name in "${DOCKER_IMAGE_NAMES2[@]}"; do
    DOCKER_IMAGE=$DOCKER_NAMESPACE/${DOCKER_IMAGE_PREFIX}${name}
    echo "DOCKER_IMAGE=$DOCKER_IMAGE"
    echo $DOCKER_PREFIX docker pull $DOCKER_IMAGE:$TAG2
    $DOCKER_REFIX docker pull $DOCKER_IMAGE:$TAG2
done
