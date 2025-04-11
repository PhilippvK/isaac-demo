#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

XLEN=${XLEN:-32}
BASE_EXTENSIONS=${ISAAC_BASE_EXTENSIONS:-"i,m,a,f,d,c,zicsr,zifencei"}
CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}
SET_NAME=${ISAAC_SET_NAME:-XIsaac}

FILTERED=${FILTERED:-0}
PRELIM=${PRELIM:-0}
FINAL=${FINAL:-0}

if [[ "$FINAL" == 1 ]]
then
    INDEX_FILE=$WORK/final_index.yml
    GEN_DIR=$WORK/gen_final/
elif [[ "$PRELIM" == 1 ]]
then
    INDEX_FILE=$WORK/prelim_index.yml
    GEN_DIR=$WORK/gen_prelim/
elif [[ "$FILTERED" == 1 ]]
then
    INDEX_FILE=$WORK/filtered_index.yml
    GEN_DIR=$WORK/gen_filtered/
else
    INDEX_FILE=$WORK/combined_index.yml
    GEN_DIR=$WORK/gen/
fi

# SESS currently unused
python3 -m isaac_toolkit.generate.iss.generate_etiss_core --workdir $WORK --gen-dir $GEN_DIR --core-name $CORE_NAME --set-name $SET_NAME --xlen $XLEN --semihosting --base-extensions $BASE_EXTENSIONS --auto-encoding --split --base-dir $(pwd)/etiss_arch_riscv/rv_base/ --tum-dir $(pwd)/etiss_arch_riscv --index $INDEX_FILE
