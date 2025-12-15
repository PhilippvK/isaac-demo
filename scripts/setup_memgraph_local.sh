#!/bin/bash

set -e

OS=${MEMGRAPH_OS:-"ubuntu-22.04"}
VERSION=${MEMGRAPH_VERSION:-"3.1.1"}
TAG="v${VERSION}"
RELEASE=${MEMGRAPH_RELEASE:-1}
ARCHIVE=memgraph_${VERSION}-${RELEASE}_amd64.deb

cd /tmp

wget https://download.memgraph.com/memgraph/$TAG/$OS/$ARCHIVE

if [[ "$(whoami)" == "root" ]]
then
    dpkg -i $ARCHIVE
else
    sudo dpkg -i $ARCHIVE
fi

rm -f $ARCHIVE

if [[ "$(whoami)" == "root" ]]
then
    systemctl status memgraph
else
    sudo systemctl status memgraph
fi
