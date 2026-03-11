#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)

VOLUME_NAME=${DOCKER_CCACHE_VOLUME:-"isaac-ccache"}

if ! $DOCKER_PREFIX docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
    echo "Creating docker volume: $VOLUME_NAME"
    $DOCKER_PREFIX docker volume create "$VOLUME_NAME"
else
    echo "Docker volume already exists: $VOLUME_NAME"
fi
