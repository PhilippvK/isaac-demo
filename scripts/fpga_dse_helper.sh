#!/bin/bash

EXP_DIR=$1
MODE=${2:-default}
# echo "EXP_DIR=$EXP_DIR"
ENV_FILE=$EXP_DIR/vars.env
# echo "ENV_FILE=$ENV_FILE"
source $ENV_FILE
CORE=$FPGA_SYN_VIVADO_CORE_NAME
# echo "CORE=$CORE"

# OUT_FILE=$EXP_DIR/work/docker/fpga_syn/baseline/dse.csv
# time MODE=baseline CORE=$CORE TCLK=10.0 python3 $SCRIPTS_DIR/fpga_dse_script.py $EXP_DIR --csv $OUT_FILE

FPGA_SYN_DIR=$EXP_DIR/work/docker/fpga_syn
OUT_FILE=$FPGA_SYN_DIR/${MODE}_dse.csv
LOG_FILE=$FPGA_SYN_DIR/${MODE}_dse.log
WORKDIR=${FPGA_SYN_DIR}/${MODE}_dse/

echo "WORKDIR=$WORKDIR"
echo "LOG_FILE=$LOG_FILE"
echo "OUT_FILE=$OUT_FILE"

# MODE=default CORE=$CORE TCLK=10.0 python3 $SCRIPTS_DIR/fpga_dse_script.py $EXP_DIR --csv $OUT_FILE > $LOG_FILE 2>&1
MODE=$MODE CORE=$CORE TCLK=10.0 python3 $SCRIPTS_DIR/fpga_dse_script.py $EXP_DIR --csv $OUT_FILE --workdir $WORKDIR --cleanup > $LOG_FILE 2>&1
# MODE=default CORE=$CORE TCLK=11.5 python3 $SCRIPTS_DIR/fpga_dse_script.py $EXP_DIR --csv $OUT_FILE > $LOG_FILE 2>&1
