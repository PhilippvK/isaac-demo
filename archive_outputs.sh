#!/bin/bash

IN_DIR=$1
IN_DIR=$(realpath $IN_DIR)


EXT="tar.xz"
OUT_FILE=$IN_DIR.$EXT
echo "IN_DIR=$IN_DIR"
echo "OUT_FILE=$OUT_FILE"

# COMPRESS_LEVEL=9
COMPRESS_LEVEL=7
COMPRESS_THREADS=$(nproc)

if [[ -d "$IN_DIR" ]]
then
    echo cd $IN_DIR
    cd $IN_DIR
    echo "tar -cf - . | xz -$COMPRESS_LEVEL -T $COMPRESS_THREADS -c - > $OUT_FILE"
    sudo chmod 777 -R ..
    tar -cf - . | xz -$COMPRESS_LEVEL -T $COMPRESS_THREADS -c - > $OUT_FILE
    echo "Size before:"
    du -h -d0 $IN_DIR
    echo "Size after:"
    du -h $OUT_FILE
    rm -rf $IN_DIR
elif [[ -f "$IN_DIR" ]]
then
    IN_FILE=$IN_DIR
    FILENAME=$(basename $IN_FILE)
    IN_DIR=$(dirname $IN_FILE)
    echo cd $IN_DIR
    cd $IN_DIR
    echo "tar -cf - $FILENAME | xz -$COMPRESS_LEVEL -T $COMPRESS_THREADS -c - > $OUT_FILE"
    sudo chmod 777 -R ..
    tar -cf - $FILENAME | xz -$COMPRESS_LEVEL -T $COMPRESS_THREADS -c - > $OUT_FILE
    echo "Size before:"
    du -h -d0 $IN_DIR
    echo "Size after:"
    du -h $OUT_FILE
    rm -rf $IN_DIR
else
    echo "Not a directory or file!"
    exit 1
fi
