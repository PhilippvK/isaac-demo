#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

XLEN=${XLEN:-32}
BASE_EXTENSIONS=${ISAAC_BASE_EXTENSIONS:-"i,m,a,f,d,c,zicsr,zifencei"}
CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}
SET_NAME=${ISAAC_SET_NAME:-XIsaac}
TUM_DIR=${CDSL_TUM_DIR:-$(pwd)/etiss_arch_riscv}
BASE_DIR=${CDSL_BASE_DIR:-$(pwd)/etiss_arch_riscv/rv_base}
EXTRA_INCLUDES=${CDSL_EXTRA_INCLUDES:-""}
# TODO: ADD_MNEMONIC_PREFIX

if [[ "$EXTRA_INCLUDES" == "" ]]
then
    EXTRA_INCLUDES=$BASE_DIR
fi


FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}
PRELIM=${PRELIM:-0}
FINAL=${FINAL:-0}
MULTI=${MULTI:-0}

if [[ "$MULTI" == 1 ]]
then
    # TODO: !!!
    INDEX_FILE=""
    # TODO: get set_names and index from file?
    for set_name in ${SET_NAME//;/ }
    do
        SET_INDEX_FILE="$WORK/${set_name}_index.yml"
        if [[ ! -f "$SET_INDEX_FILE" ]]
        then
            echo "SET_INDEX_FILE not found: $SET_INDEX_FILE"
            exit 1
        fi
        INDEX_FILE="$INDEX_FILE $SET_INDEX_FILE"
    done
    GEN_DIR=$WORK/gen/multi/
else
    if [[ "$FINAL" == 1 ]]
    then
	STAGE="final"
    elif [[ "$PRELIM" == 1 ]]
    then
	STAGE="prelim"
    elif [[ "$FILTERED2" == 1 && "$SELECTED" == 1 ]]
    then
	STAGE="filtered2_selected"
    elif [[ "$FILTERED2" == 1 ]]
    then
	STAGE="filtered2"
    elif [[ "$FILTERED" == 1 && "$SELECTED" == 1 ]]
    then
	STAGE="filtered_selected"
    elif [[ "$FILTERED" == 1 ]]
    then
	STAGE="filtered"
    else
	STAGE="default"
    fi
fi
STAGE_DIR=$DIR/$STAGE

RUN=$STAGE_DIR/run
SESS=$STAGE_DIR/sess
WORK=$STAGE_DIR/work

INDEX_FILE=$WORK/index.yml
GEN_DIR=$WORK/gen

# SESS currently unused
python3 -m isaac_toolkit.generate.iss.generate_etiss_core --workdir $WORK --gen-dir $GEN_DIR --core-name $CORE_NAME --set-name $SET_NAME --xlen $XLEN --semihosting --base-extensions $BASE_EXTENSIONS --auto-encoding --split --base-dir $BASE_DIR --tum-dir $TUM_DIR  --extra-includes $EXTRA_INCLUDES --index $INDEX_FILE
