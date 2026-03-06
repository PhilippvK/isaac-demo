#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
DOCKER_DIR=$TOP_DIR/docker

TAG=${1:-"latest"}
CONFIG=${CONFIG:-""}
if [[ "$CONFIG" != "" ]]
then
    TAG2=$CONFIG-$TAG
else
    TAG2=$TAG
fi

# DOCKER_IMAGE_NAMES=(base extra etiss etiss_perf seal5 mlonmcu mlonmcu_min min full demo)
DOCKER_IMAGE_NAMES=(etiss etiss_perf seal5 mlonmcu min)
DOCKER_IMAGE_NAMES2=(mlonmcu full demo)  # CONFIG specific

for name in "${DOCKER_IMAGE_NAMES[@]}"; do
    DOCKER_IMAGE=$DOCKER_NAMESPACE/${DOCKER_IMAGE_PREFIX}${name}
    echo "DOCKER_IMAGE=$DOCKER_IMAGE"
    echo docker pull $DOCKER_IMAGE:$TAG
    docker pull $DOCKER_IMAGE:$TAG
done

for name in "${DOCKER_IMAGE_NAMES2[@]}"; do
    DOCKER_IMAGE=$DOCKER_NAMESPACE/${DOCKER_IMAGE_PREFIX}${name}
    echo "DOCKER_IMAGE=$DOCKER_IMAGE"
    echo docker pull $DOCKER_IMAGE:$TAG2
    docker pull $DOCKER_IMAGE:$TAG2
done
