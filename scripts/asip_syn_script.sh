#!/bin/bash

set -e

ROOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/

if [[ "$#" -lt 2 ]]
then
    echo "Illegal number of parameters"
    exit 1
fi

OUT_DIR=$1
RTL_DIR=$2
CORE=${3:-VEX_5S}
PDK=${4:-NangateOpenCellLibrary}
CLK_SPEED=${5:-20.0}
CONSTRAINTS_FILE=${6}

echo CORE=$CORE

# TEMP_DIR=$(mktemp -d)
# echo TEMP_DIR=$TEMP_DIR

TOP_NAME=top

if [[ "$CORE" == "CVA5" ]]
then
    TOP_NAME=cva5_top
fi
CONSTRAINTS_FILE_DEFAULT=$ROOT_DIR/constraints/$CORE/$TOP_NAME.sdc

if [[ -z $CONSTRAINTS_FILE ]]
then
    CONSTRAINTS_FILE=$CONSTRAINTS_FILE_DEFAULT
fi

if [[ ! -f $CONSTRAINTS_FILE ]]
then
    echo "Constraints file not found: $CONSTRAINTS_FILE"
    exit 2
fi

if [[ ! -f $RTL_DIR/files.txt ]]
then
    echo "Missing: $RTL_DIR/files.txt"
    exit 2
fi



mkdir -p $OUT_DIR


export ROOT_PATH=$ROOT_DIR
export TECHLIB=${PDK}
export TECHLIB_PATH=/work/git/syn/test_longnail_syn/syn/techlib
# export LONGNAIL_RTL_DIR=$(readlink -f $RTL_DIR)
export FILES_TXT=$(readlink -f $RTL_DIR/files.txt)
export GATE_DIR=${OUT_DIR}/out
export LOG_DIR=${OUT_DIR}/log
export CLOCK_PERIOD=${CLK_SPEED}
# export CONSTRAINTS_FILE=$OUT_DIR/constraints.sdc
export CONSTRAINTS_FILE=$(readlink -f $CONSTRAINTS_FILE)
export TOPLEVEL=$TOP_NAME
mkdir -p $GATE_DIR
mkdir -p $LOG_DIR

# cp $CONSTRAINTS_FILE_DEFAULT $CONSTRAINTS_FILE

cd $OUT_DIR
dc_shell -f $ROOT_DIR/syn_nangate.tcl | tee $LOG_DIR/syn_nangate.log
cd -

if [[ ! -f $LOG_DIR/report_area_hier.log ]]
then
    echo "Could not find: $LOG_DIR/report_area_hier.log"
    exit 3
elif [[ ! -f $LOG_DIR/report_timing.log ]]
then
    echo "Could not find: $LOG_DIR/report_timing.log"
    exit 4
fi

python3 $SCRIPTS_DIR/parse_area_report.py $LOG_DIR/report_area_hier.log > $OUT_DIR/area.csv
python3 $SCRIPTS_DIR/parse_timing_report.py $LOG_DIR/report_timing.log > $OUT_DIR/timing.csv
paste -d"," $OUT_DIR/area.csv $OUT_DIR/timing.csv > $OUT_DIR/metrics.csv
