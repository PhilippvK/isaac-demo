#!/bin/bash

date

echo "@=$@"
echo "SEAL5_HOME=$SEAL5_HOME"

DEST=$1
echo "DEST=$DEST"
shift

set -e

echo "HELLO WORLD"
cd /isax-tools/
cd nailgun
make
make build
ls -l
echo "BYE WORLD"
