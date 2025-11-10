#!/bin/bash


date

export SEAL5_HOME=${SEAL5_HOME:-/tmp/seal5_local}  # TODO: tempdir?

# TODO: check vars!

echo "@=$@"
echo "SEAL5_HOME=$SEAL5_HOME"

DEST=$1
echo "DEST=$DEST"
shift
FILES=($@)
echo "FILES=$FILES"

# GEN_CDSL_FILES=$(echo ${FILES[0]})
GEN_CDSL_FILES=($(printf "%s\n" "${FILES[@]}" | grep '\.core_desc$' | xargs))
echo "GEN_CDSL_FILES=$GEN_CDSL_FILES"
GEN_CFG_FILES=$(echo ${FILES[@]//*.core_desc})
echo "GEN_CFG_FILES=$GEN_CFG_FILES"

# source /work/venv/bin/activate
export PYTHONPATH=${SEAL5_DIR}
# TODO: if seal5_dir unset, clone or pip install
# alias seal5="python3 -m seal5.cli.main"

set -e

# WORKAROUND/FIX (TODO: remove)
# cp -r /work/git/isaac-demo/seal5/* /work/seal5/
# LLVM_REPO="https://github.com/PhilippvK/llvm-project.git"
LLVM_REPO=${LLVM_REPO:-"/home/philipp/src/isaac-demo/llvm-project"}
LLVM_REF=${LLVM_REF:-"isaacnew-base-3"}
CLONE_DEPTH=${CLONE_DEPTH:-2}
SEAL5_CFG_DIR=${SEAL5_CFG_DIR:-/path/to/cfg/seal5}
CCACHE=${CCACHE:-0}
CLEANUP=${CLEANUP:-0}
export CCACHE_DIR=${CCACHE_DIR:-0}
MGCLIENT_ROOT=${MGCLIENT_ROOT:-""}
ENABLE_CDFG_PASS=${ENABLE_CDFG_PASS:-1}
RESET=${RESET:-1}

BUILD_ARGS=""
if [[ "$CCACHE" == "1" ]]
then
    BUILD_ARGS="$BUILD_ARGS --ccache"
fi

CMAKE_EXTRA_ARGS=""

if [[ "$MGCLIENT_ROOT" != "" ]]
then
    CMAKE_EXTRA_ARGS="$CMAKE_EXTRA_ARGS,-DMGCLIENT_ROOT=${MGCLIENT_ROOT}"
fi

if [[ "$ENABLE_CDFG_PASS" == "1" ]]
then
    CMAKE_EXTRA_ARGS="$CMAKE_EXTRA_ARGS,-DENABLE_CDFG_PASS=ON"
else
    CMAKE_EXTRA_ARGS="$CMAKE_EXTRA_ARGS,-DENABLE_CDFG_PASS=OFF"
fi

if [[ "$CMAKE_EXTRA_ARGS" != "" ]]
then
    BUILD_ARGS="$BUILD_ARGS --cmake-extra-args=$CMAKE_EXTRA_ARGS"
fi

if [[ "$RESET" == "1" ]]
then
  seal5 --verbose --dir ${SEAL5_HOME} reset  --settings
  seal5 --verbose --dir ${SEAL5_HOME} clean --temp --patches --models --inputs
fi
seal5 --verbose --dir ${SEAL5_HOME} init --non-interactive --clone --clone-url ${LLVM_REPO} --clone-ref ${LLVM_REF} --clone-depth ${CLONE_DEPTH} --force
seal5 --verbose load --overwrite --files $SEAL5_CFG_DIR/*.yml
seal5 --verbose setup
seal5 --verbose patch -s 0
seal5 --verbose build $BUILD_ARGS

seal5 --verbose load --files $GEN_CDSL_FILES
if [[ $GEN_CFG_FILES != "" ]]
then
    seal5 --verbose load --files $GEN_CFG_FILES
fi
seal5 --verbose transform
seal5 --verbose generate --skip pattern_gen
seal5 --verbose patch -s 1 2
seal5 --verbose build $BUILD_ARGS
seal5 --verbose build -t pattern-gen $BUILD_ARGS
seal5 --verbose build -t llc $BUILD_ARGS
seal5 --verbose generate --only pattern_gen
seal5 --verbose patch -s 3 4 5
seal5 --verbose build $BUILD_ARGS
seal5 --verbose test
mkdir -p $DEST
seal5 --verbose install --dest $DEST/llvm_install
seal5 --verbose deploy --dest $DEST/llvm_source.zip  # TODO: use git archive instead (include .git dir)?
seal5 --verbose export --dest $DEST/seal5.tar.gz  # TODO: zip
mkdir -p $DEST/seal5_reports
python3 -m seal5.backends.report.properties.writer $SEAL5_HOME/.seal5/models/*.seal5model --output $DEST/seal5_reports/properties.csv
python3 -m seal5.backends.report.status.writer $SEAL5_HOME/.seal5/models/*.seal5model --yaml $SEAL5_HOME/.seal5/settings.yml --output $DEST/seal5_reports/status.csv
python3 -m seal5.backends.report.status.writer $SEAL5_HOME/.seal5/models/*.seal5model --yaml $SEAL5_HOME/.seal5/settings.yml --compact --output $DEST/seal5_reports/status_compact.csv
python3 -m seal5.backends.report.test_results.writer $SEAL5_HOME/.seal5/models/*.seal5model --yaml $SEAL5_HOME/.seal5/settings.yml --output $DEST/seal5_reports/test_results.csv --coverage $DEST/seal5_reports/test_coverage.csv
python3 -m seal5.backends.report.test_results.writer $SEAL5_HOME/.seal5/models/*.seal5model --yaml $SEAL5_HOME/.seal5/settings.yml --compact --output $DEST/seal5_reports/test_results_compact.csv --coverage $DEST/seal5_reports/test_coverage_compact.csv
python3 -m seal5.backends.report.diff.writer --yaml $SEAL5_HOME/.seal5/settings.yml --output $DEST/seal5_reports/diff.csv
python3 -m seal5.backends.report.times.writer --yaml $SEAL5_HOME/.seal5/settings.yml --pass-times --output $DEST/seal5_reports/stage_times.csv --sum-level 2

if [[ "$CLEANUP" == "1" ]]
then
    rm -rf $SEAL5_HOME
fi

# cmake --build /work/tvm/build -j$(nproc)
# cp -r /work/tvm/build $DEST/tvm_build
