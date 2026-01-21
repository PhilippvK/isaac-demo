#!/bin/bash


date

echo "@=$@"
echo "SEAL5_HOME=$SEAL5_HOME"

DEST=$1
echo "DEST=$DEST"
shift
FILES=($@)
echo "FILES=$FILES"

GEN_CDSL_FILES=$(echo $FILES | grep ".core_desc")
echo "GEN_CDSL_FILES=$GEN_CDSL_FILES"

# TODO: assert single file

TOP_CDSL_FILE=$GEN_CDSL_FILES
echo "TOP_CDSL_FILE=$TOP_CDSL_FILE"
TOP_DIR=$(dirname $TOP_CDSL_FILE)
echo "TOP_DIR=$TOP_DIR"
TOP_NAME=$(basename $TOP_CDSL_FILE)
TOP_NAME=${TOP_NAME%.*}
echo "TOP_NAME=$TOP_NAME"
CORE_NAME=$TOP_NAME  # TODO: pass via arg?
echo "CORE_NAME=$CORE_NAME"
SET_NAME=XIsaac  # TODO: muktiple sets?
CLEANUP=${CLEANUP:-0}

source /work/venv/bin/activate

# WORKAROUND/FIX (TODO: remove)
# apt-get update && apt-get install -y --no-install-recommends zip unzip
# cp -r /work/git/isaac-demo/M2-ISA-R/* /work/M2-ISA-R/
# git clone https://github.com/PhilippvK/etiss.git --branch print_instr_to_file /work/etiss

set -e

# TODO: use custom (temp) location for metamodel to not conflict with parallel runs

# echo "HELLO WORLD"
python3 -m m2isar.frontends.coredsl2.parser $TOP_CDSL_FILE
python -m m2isar.backends.etiss.writer $TOP_DIR/gen_model/$TOP_NAME.m2isarmodel --separate --static-scalars
chmod -R 777 $TOP_DIR/gen_model
chmod -R 777 $TOP_DIR/gen_output

cd /work/etiss
git status
cp -r $TOP_DIR/gen_output/$TOP_NAME/$CORE_NAME ArchImpl
cp ArchImpl/RV32IMACFD/RV32IMACFDArchSpecificImp.cpp ArchImpl/$CORE_NAME/${CORE_NAME}ArchSpecificImp.cpp
sed -i "s/RV32IMACFD/${CORE_NAME}/g" ArchImpl/${CORE_NAME}/${CORE_NAME}ArchSpecificImp.cpp
git status
# tar cfJ $DEST/etiss_src.tar.xz *
# tar cf $DEST/etiss_src.tar.gz *
# zip -r $DEST/etiss_source.zip *
git archive -o $DEST/etiss_source.zip HEAD
git add -N ArchImpl/${CORE_NAME}/${CORE_NAME}_${SET_NAME}*Instr.cpp
git status
git diff > $DEST/etiss_patch.diff
git diff --shortstat > $DEST/etiss_patch.stat
git add -N ArchImpl/
git status
git diff > $DEST/etiss_patch_full.diff
git diff --shortstat > $DEST/etiss_patch_full.stat
cmake -B build -S . -DCMAKE_INSTALL_PREFIX=$DEST/etiss_install -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
cmake --install build
# TODO prebuild etiss in docker
# TODO build etiss
if [[ "$CLEANUP" == "1" ]]
then
    rm -rf $ETISS_HOME
    rm -rf $TOP_DIR/gen_model
    rm -rf $TOP_DIR/gen_output
fi

chmod -R 777 $DEST
