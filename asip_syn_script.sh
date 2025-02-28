#!/bin/bash

set -e

ROOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/

if [[ "$#" -lt 2 ]]
then
    echo "Illegal number of parameters"
    exit 1
fi

OUT_FILE=$1
RTL_DIR=$2
CORE=${3:-VEX_5S}
PDK=${4:-NangateOpenCellLibrary}
CLK_SPEED=${5:-20.0}

TOP=top
CONSTRAINTS_FILE_DEFAULT=$ROOT_DIR/constraints/$CORE/$TOP.sdc

if [[ ! -f $CONSTRAINTS_FILE_DEFAULT ]]
then
    echo "Constraints file not found: $CONSTRAINTS_FILE_DEFAULT"
    exit 2
fi

TEMP_DIR=$(mktemp -d)
echo TEMP_DIR=$TEMP_DIR

export TECHLIB=${PDK}
export TECHLIB_PATH=/work/git/syn/test_longnail_syn/syn/techlib
export LONGNAIL_RTL_DIR=${RTL_DIR}
export OUT_DIR=${TEMP_DIR}/out
export LOG_DIR=${TEMP_DIR}/log
export CLOCK_PERIOD=${CLK_SPEED}
export CONSTRAINTS_FILE=$TEMP_DIR/constraints.sdc
mkdir $OUT_DIR
mkdir $LOG_DIR

cp $CONSTRAINTS_FILE_DEFAULT $CONSTRAINTS_FILE

dc_shell -f syn_nangate.tcl | tee $LOG_DIR/syn_nangate.log

python3 parse_area_report.py $LOG_DIR/report_area_hier.log > $TEMP_DIR/area.csv
python3 parse_timing_report.py $LOG_DIR/report_timing.log > $TEMP_DIR/timing.csv
paste -d"," $TEMP_DIR/area.csv $TEMP_DIR/timing.csv > $OUT_FILE
