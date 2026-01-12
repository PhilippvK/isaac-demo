#!/bin/bash


date

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
CLEANUP=${CLEANUP:-0}
CCACHE=${CCACHE:-1}
VERBOSE=${VERBOSE:-0}

VERBOSE_ARGS=""
if [[ "$VERBOSE" == "1" ]]
then
    VERBOSE_ARGS="$VERBOSE_ARGS --verbose"
fi
BUILD_ARGS=""
if [[ "$CCACHE" == "1" ]]
then
    BUILD_ARGS="$BUILD_ARGS --ccache"
fi

source /work/venv/bin/activate

set -e

# WORKAROUND/FIX (TODO: remove)
# cp -r /work/git/isaac-demo/seal5/* /work/seal5/

seal5 $VERBOSE_ARGS load --files $GEN_CDSL_FILES
if [[ $GEN_CFG_FILES != "" ]]
then
    seal5 $VERBOSE_ARGS load --files $GEN_CFG_FILES
fi
seal5 $VERBOSE_ARGS transform
seal5 $VERBOSE_ARGS generate --skip pattern_gen
seal5 $VERBOSE_ARGS patch -s 1 2
seal5 $VERBOSE_ARGS build $BUILD_ARGS
seal5 $VERBOSE_ARGS build -t pattern-gen $BUILD_ARGS
seal5 $VERBOSE_ARGS build -t llc $BUILD_ARGS
seal5 $VERBOSE_ARGS generate --only pattern_gen
seal5 $VERBOSE_ARGS patch -s 3 4 5
seal5 $VERBOSE_ARGS build $BUILD_ARGS
seal5 $VERBOSE_ARGS test
mkdir -p $DEST
seal5 $VERBOSE_ARGS install --dest $DEST/llvm_install
seal5 $VERBOSE_ARGS deploy --dest $DEST/llvm_source.zip  # TODO: use git archive instead (include .git dir)?
seal5 $VERBOSE_ARGS export --dest $DEST/seal5.tar.gz  # TODO: zip
mkdir -p $DEST/seal5_reports
python3 -m seal5.backends.report.properties.writer $SEAL5_HOME/.seal5/models/*.seal5model --output $DEST/seal5_reports/properties.csv
python3 -m seal5.backends.report.status.writer $SEAL5_HOME/.seal5/models/*.seal5model --yaml $SEAL5_HOME/.seal5/settings.yml --output $DEST/seal5_reports/status.csv
python3 -m seal5.backends.report.status.writer $SEAL5_HOME/.seal5/models/*.seal5model --yaml $SEAL5_HOME/.seal5/settings.yml --compact --output $DEST/seal5_reports/status_compact.csv
python3 -m seal5.backends.report.test_results.writer $SEAL5_HOME/.seal5/models/*.seal5model --yaml $SEAL5_HOME/.seal5/settings.yml --output $DEST/seal5_reports/test_results.csv --coverage $DEST/seal5_reports/test_coverage.csv
python3 -m seal5.backends.report.test_results.writer $SEAL5_HOME/.seal5/models/*.seal5model --yaml $SEAL5_HOME/.seal5/settings.yml --compact --output $DEST/seal5_reports/test_results_compact.csv --coverage $DEST/seal5_reports/test_coverage_compact.csv
python3 -m seal5.backends.report.diff.writer --yaml $SEAL5_HOME/.seal5/settings.yml --output $DEST/seal5_reports/diff.csv
python3 -m seal5.backends.report.times.writer --yaml $SEAL5_HOME/.seal5/settings.yml --pass-times --output $DEST/seal5_reports/stage_times.csv --sum-level 2
chmod -R 777 $DEST

if [[ "$CLEANUP" == "1" ]]
then
    rm -rf $SEAL5_HOME
fi

# cmake --build /work/tvm/build -j$(nproc)
# cp -r /work/tvm/build $DEST/tvm_build
