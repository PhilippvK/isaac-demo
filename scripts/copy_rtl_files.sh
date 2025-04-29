#!/bin/bash

set -e

if [[ "$#" -ne 2 ]]
then
    echo "Illegal number of parameters"
    exit 1
fi

FILES_TXT=$1
DEST=$2


if [[ ! -f $FILES_TXT ]]
then
    echo "Missing file: $FILES_TXT"
    exit 1
fi

mkdir -p $DEST


BASE_DIR=$(dirname $FILES_TXT)

for filename in $(cat $FILES_TXT)
do
    parent=$(dirname $filename)
    mkdir -p $DEST/$parent
    cp $BASE_DIR/$filename $DEST/$filename
done

cp $FILES_TXT $DEST/
