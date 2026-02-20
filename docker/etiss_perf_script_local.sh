#!/bin/bash

git config --global url."https://github.com/".insteadOf git@github.com:


date

conda deactivate  # TODO: only on demand?
deactivate
pip list | grep -i m2
which python
unset PYTHONPATH
unset VIRTUAL_ENV
echo PYTHONPATH=$PYTHONPATH
export PATH=/nfs/TUEIEDAscratch/ga87puy/work/cpython_v3.10_nodbgopt/install/bin/:$PATH
env
# TODO: python3.10!!

# read -n 1
export ETISS_PERF_HOME=${ETISS_PERF_HOME:-/tmp/etiss_perf_local}  # TODO: tempdir?

if [[ "$#" -lt 3 ]]
then
    echo "Illegal number of parameters"
    exit 1
fi

DEST=$1
echo "DEST=$DEST"
shift
INDEX_FILE=$1
echo "INDEX_FILE=$INDEX_FILE"
shift
HLS_DIR=$1
echo "HLS_DIR=$HLS_DIR"
shift
# ETISS_SRC=$1
# echo "ETISS_SRC=$ETISS_SRC"
# shift
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
# TODO: expose etiss url and ref
# TODO: add ccache also in docker?
CCACHE=${CCACHE:-0}
CLEANUP=${CLEANUP:-0}
# export CCACHE_DIR=${CCACHE_DIR:-0}

# source /work/venv/bin/activate
set -e

# WORKAROUND/FIX (TODO: remove)
# apt-get update && apt-get install -y --no-install-recommends zip unzip
# cp -r /work/git/isaac-demo/M2-ISA-R/* /work/M2-ISA-R/
# git clone https://github.com/PhilippvK/etiss.git --branch print_instr_to_file $ETISS_HOME

ETISS_REF=xisaac_gen
ETISS_PERF_WS_REF=xisaac_gen
ETISS_PERF_REF=xisaac_gen
git clone https://github.com/tum-ei-eda/PerformanceSimulation_workspace.git --branch $ETISS_PERF_WS_REF --recursive $ETISS_PERF_HOME
cd $ETISS_PERF_HOME
git -C etiss-perf-sim checkout $ETISS_PERF_REF
git -C etiss-perf-sim/etiss checkout $ETISS_REF
git submodule update --init --recursive

./scripts/setup_workspace.sh


source .env
export PSW_DEFAULT_CORE_DSL=$TOP_CDSL_FILE
$PSW_SCRIPTS_SUPPORT/m2isar_run_wrapper.sh pip list
$PSW_SCRIPTS_SUPPORT/m2isar_run_wrapper.sh python3 -m m2isar.frontends.coredsl2.parser $TOP_CDSL_FILE
$PSW_SCRIPTS_SUPPORT/m2isar_run_wrapper.sh python3 -m m2isar.backends.etiss.writer $TOP_DIR/gen_model/$TOP_NAME.m2isarmodel --separate --static-scalars

# TODO: needs xlen?
cd $ETISS_PERF_HOME/etiss-perf-sim/etiss
git status
cp -r $TOP_DIR/gen_output/$TOP_NAME/$CORE_NAME ArchImpl
cp ArchImpl/RV32IMACFD/RV32IMACFDArchSpecificImp.cpp ArchImpl/$CORE_NAME/${CORE_NAME}ArchSpecificImp.cpp
sed -i "s/RV32IMACFD/${CORE_NAME}/g" ArchImpl/${CORE_NAME}/${CORE_NAME}ArchSpecificImp.cpp
cp ArchImpl/RV32IMACFD/RV32IMACFDArchSpecificImp.h ArchImpl/$CORE_NAME/${CORE_NAME}ArchSpecificImp.h
sed -i "s/RV32IMACFD/${CORE_NAME}/g" ArchImpl/${CORE_NAME}/${CORE_NAME}ArchSpecificImp.h
git status
CCACHE_ARGS=""
if [[ "$CCACHE" == "1" ]]
then
    CCACHE_ARGS="$CCACHE_ARGS -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache"
fi
cmake -B build_dir -S . -DCMAKE_INSTALL_PREFIX=$ETISS_PERF_HOME/etiss-perf-sim/etiss/build_dir/installed -DCMAKE_BUILD_TYPE=Release $CCACHE_ARGS
cmake --build build_dir -j$(nproc)
cmake --install build_dir
cd -

cd code_gen/descriptions/core_perf_dsl
# TODO: get core, template,... from yaml?
$PSW_SCRIPTS_SUPPORT/m2isar_run_wrapper.sh pip install -r requirements.txt
mkdir ini_out
$PSW_SCRIPTS_SUPPORT/m2isar_run_wrapper.sh python3 gen_xisaac_core_perf_dsl.py -t CV32E40PXISAAC.corePerfDsl.mako -c cv32e40p -o CV32E40PXISAAC.corePerfDsl --temp-dir temp_out/ --index $INDEX_FILE --selected all --hls-dir $HLS_DIR/output --ini-dest ini_out/ --monitor-template InstructionTrace_XISAAC.json.mako --monitor-dest InstructionTrace_XISAAC.json
mkdir -p $DEST/ini/
cp -r ini_out/* $DEST/ini/
cp InstructionTrace_XISAAC.json $DEST/InstructionTrace_XISAAC.json
cp CV32E40PXISAAC.corePerfDsl $DEST/CV32E40PXISAAC.corePerfDsl
cd -

${PSW_SCRIPTS_SUPPORT}/code_gen_helper.py ./code_gen/descriptions/core_perf_dsl/CV32E40PXISAAC.corePerfDsl -i
${PSW_SCRIPTS_SUPPORT}/code_gen_helper.py ./code_gen/descriptions/core_perf_dsl/InstructionTrace_XISAAC.json

cd $ETISS_PERF_HOME/etiss-perf-sim/etiss
git status
cmake --build build_dir -j$(nproc)
cmake --install build_dir

tar --dereference --exclude=.git --exclude=.gitmodules --exclude build_dir -czf $DEST/etiss_perf_source.tar.gz .  # TODO: .zip?

# git archive -o $DEST/etiss_perf_source.zip HEAD
# git add -N ArchImpl/${CORE_NAME}/${CORE_NAME}_${SET_NAME}*Instr.cpp
# git status
# TODO: replace submodules with src?
# git diff > $DEST/etiss_perf_patch.diff
# git diff --shortstat > $DEST/etiss_perf_patch.stat
# git add -N ArchImpl/
# git status
# git diff > $DEST/etiss_perf_patch_full.diff
# git diff --shortstat > $DEST/etiss_perf_patch_full.stat



cd -

mkdir -p $DEST/etiss_perf_install
cp -r $ETISS_PERF_HOME/etiss-perf-sim/etiss/build_dir/installed/* $DEST/etiss_perf_install/

if [[ "$CLEANUP" == "1" ]]
then
    rm -rf $ETISS_PERF_HOME
    rm -rf $TOP_DIR/gen_model
    rm -rf $TOP_DIR/gen_output
fi
# TODO prebuild etiss in docker
# TODO build etiss
