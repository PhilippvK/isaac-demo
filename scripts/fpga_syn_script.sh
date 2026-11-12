#!/bin/bash

set -e

export PATH=/nfs/tools/xilinx/Vivado/2024.1/bin:$PATH

ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )/

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

BOARD=${FPGA_SYN_BOARD:-generic}
TOP_NAME=top

if [[ "$CORE" == "CVA5" ]]
then
    TOP_NAME=cva5_top
fi

CONSTRAINTS_FILE_DEFAULT=$SCRIPTS_DIR/fpga_syn/constraints/$CORE/$TOP_NAME.xdc
if [[ "$BOARD" == "arty_a7_100" ]]; then
    case "$CORE" in
        CVA5) TOP_NAME=cva5_arty_top ;;
        VEX_5S) TOP_NAME=vex_arty_top ;;
        *) echo "Unsupported Arty core: $CORE"; exit 2 ;;
    esac
    CONSTRAINTS_FILE_DEFAULT=$SCRIPTS_DIR/fpga_syn/boards/arty_a7_100/board.xdc
elif [[ "$BOARD" != "generic" ]]; then
    echo "Unsupported FPGA_SYN_BOARD: $BOARD"; exit 2
fi
export FPGA_SYN_BOARD=$BOARD

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
export FPGA_SYN_CORE=$CORE

cd $OUT_DIR
"${FPGA_SYN_VIVADO:-vivado}" -mode batch -source $SCRIPTS_DIR/fpga_syn/my_vivado_script.tcl
cd -

# check if expected files have been generated
if [[ ! -f $REPORTS_DIR/utilization_hier_impl.rpt ]]
then
    echo "Could not find: $REPORTS_DIR/utilization_hier_impl.rpt"
    exit 3
fi

"${FPGA_SYN_PYTHON:-python3}" $SCRIPTS_DIR/parse_vivado_util_hier_report.py $REPORTS_DIR/utilization_hier_impl.rpt $REPORTS_DIR/utilization_hier_impl.csv
"${FPGA_SYN_PYTHON:-python3}" $SCRIPTS_DIR/filter_vivado_util_hier_report.py $REPORTS_DIR/utilization_hier_impl.csv $REPORTS_DIR/utilization_hier_impl_filtered.csv
"${FPGA_SYN_PYTHON:-python3}" $SCRIPTS_DIR/analyze_vivado_util_hier_report.py $REPORTS_DIR/utilization_hier_impl_filtered.csv $REPORTS_DIR/utilization_hier_impl_summary.csv
