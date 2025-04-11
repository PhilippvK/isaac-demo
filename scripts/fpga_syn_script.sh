#!/bin/bash

set -e

export PATH=/nfs/tools/xilinx/Vivado/2024.1/bin:$PATH

ROOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/

if [[ "$#" -lt 2 ]]
then
    echo "Illegal number of parameters"
    exit 1
fi
# SCRIPTS_DIR=$ROOT_DIR/scripts
SCRIPTS_DIR=$ROOT_DIR

OUT_DIR=$1
RTL_DIR=$2
CORE=${3:-CVA5}
PART=${4:-xc7a200tffv1156-1}
CLK_SPEED=${5:-10.0}

if [[ ! -f $RTL_DIR/files.txt ]]
then
    echo "Missing: $RTL_DIR/files.txt"
    exit 2
fi

# TEMP_DIR=$(mktemp -d)
# echo TEMP_DIR=$TEMP_DIR

TOP_NAME=top

if [[ "$CORE" == "CVA5" ]]
then
    TOP_NAME=cva5_top
fi

CONSTRAINTS_FILE_DEFAULT=$SCRIPTS_DIR/fpga_syn/constraints/$CORE/$TOP_NAME.xdc

if [[ -z $CONSTRAINTS_FILE ]]
then
    CONSTRAINTS_FILE=$CONSTRAINTS_FILE_DEFAULT
fi

if [[ ! -f $CONSTRAINTS_FILE ]]
then
    echo "Constraints file not found: $CONSTRAINTS_FILE"
    exit 2
fi


REPORTS_DIR=$OUT_DIR/reports

mkdir -p $OUT_DIR
mkdir -p $REPORTS_DIR


export ROOT_PATH=$ROOT_DIR
export FILES_TXT=$(readlink -f $RTL_DIR/files.txt)
export CLOCK_PERIOD=${CLK_SPEED}
export CONSTRAINTS_FILE=$(readlink -f $CONSTRAINTS_FILE)
export TOPLEVEL=$TOP_NAME
export PART

cd $OUT_DIR
vivado -mode batch -source $SCRIPTS_DIR/fpga_syn/my_vivado_script.tcl
cd -

# check if expected files have been generated
if [[ ! -f $REPORTS_DIR/utilization_hier_impl.rpt ]]
then
    echo "Could not find: $REPORTS_DIR/utilization_hier_impl.rpt"
    exit 3
fi

python3 scripts/parse_vivado_util_hier_report.py $REPORTS_DIR/utilization_hier_impl.rpt $REPORTS_DIR/utilization_hier_impl.csv
python3 scripts/filter_vivado_util_hier_report.py $REPORTS_DIR/utilization_hier_impl.csv $REPORTS_DIR/utilization_hier_impl_filtered.csv
python3 scripts/analyze_vivado_util_hier_report.py $REPORTS_DIR/utilization_hier_impl_filtered.csv $REPORTS_DIR/utilization_hier_impl_summary.csv
