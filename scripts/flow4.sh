#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE
STAGE=${CDFG_STAGE:-32}

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

SESS=$DIR/sess
WORK=$DIR/work

FORCE_ARGS=""

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

# FINAL=${FINAL:-0}
# PRELIM=${PRELIM:-0}
# FILTERED=${FILTERED:-0}
#
# if [[ "$FINAL" == "1" ]]
# then
#     GEN_DIR=$WORK/gen_final/
#     INDEX_FILE=$WORK/final_index.yml
# elif [[ "$PRELIM" == "1" ]]
# then
#     GEN_DIR=$WORK/gen_prelim/
#     INDEX_FILE=$WORK/prelim_index.yml
# elif [[ "$FILTERED" == "1" ]]
# then
#     GEN_DIR=$WORK/gen_filtered/
#     INDEX_FILE=$WORK/filtered_index.yml
# else
#     GEN_DIR=$WORK/gen/
#     INDEX_FILE=$WORK/combined_index.yml
# fi

ISAAC_QUERY_CONFIG_YAML=${ISAAC_QUERY_CONFIG_YAML:-cfg/isaac/query/default.yml}
ISAAC_LIMIT_RESULTS=${ISAAC_LIMIT_RESULTS:-""}
# ISAAC_MIN_INPUTS=1
# ISAAC_MAX_INPUTS=4
# ISAAC_MIN_OUTPUTS=1
# ISAAC_MAX_OUTPUTS=2
# ISAAC_MAX_NODES=1000
# ISAAC_MAX_ENC_FOOTPRINT=1.0
# ISAAC_MAX_ENC_WEIGHT=1.0
# ISAAC_MIN_ENC_BITS_LEFT=5
# ISAAC_MIN_NODES=""
# ISAAC_MIN_PATH_LENGTH=1
# ISAAC_MAX_PATH_LENGTH=9
# ISAAC_MAX_PATH_WIDTH=2
# ISAAC_INSTR_PREDICATES=511
# ISAAC_IGNORE_NAMES=""
# ISAAC_IGNORE_OP_TYPES=""
# ISAAC_ALLOWED_ENC_SIZES=32
ISAAC_MIN_ISO_WEIGHT=0.05
ISAAC_SCALE_ISO_WEIGHT=${ISAAC_SCALE_ISO_WEIGHT:-"auto"}
# ISAAC_MAX_LOADS=1,
# ISAAC_MAX_STORES=1,
# ISAAC_MAX_MEMS=0
# ISAAC_MAX_BRANCHES=1
XLEN=${XLEN:-32}
# ISAAC_HALT_ON_ERROR=1
ISAAC_SORT_BY="IsoWeight"
ISAAC_TOPK=""  # TODO: expose
# ISAAC_TOPK="200"  # TODO: expose
ISAAC_TOPK="170"  # TODO: expose
ISAAC_PARTITION_WITH_MAXMISO=auto

EXTRA_ARGS=""

if [[ "$ISAAC_QUERY_CONFIG_YAML" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --query-config-yaml $ISAAC_QUERY_CONFIG_YAML"
fi
if [[ "$ISAAC_LIMIT_RESULTS" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --limit-results $ISAAC_LIMIT_RESULTS"
fi
if [[ "$XLEN" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --xlen $XLEN"
fi
if [[ "$ISAAC_MIN_ISO_WEIGHT" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --min-iso-weight $ISAAC_MIN_ISO_WEIGHT"
fi
if [[ "$ISAAC_SCALE_ISO_WEIGHT" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --scale-iso-weight $ISAAC_SCALE_ISO_WEIGHT"
fi
if [[ "$ISAAC_SORT_BY" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --sort-by $ISAAC_SORT_BY"
fi
if [[ "$ISAAC_TOPK" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --topk $ISAAC_TOPK"
fi
if [[ "$ISAAC_PARTITION_WITH_MAXMISO" != "" ]]
then
    EXTRA_ARGS="$EXTRA_ARGS --partition-with-maxmiso $ISAAC_PARTITION_WITH_MAXMISO"
fi

python3 -m isaac_toolkit.generate.ise.query_candidates_from_db --sess $SESS --workdir $WORK --label $LABEL --stage $STAGE $EXTRA_ARGS $FORCE_ARGS --progress

# python3 scripts/names_helper.py $WORK/combined_index.yml --output $WORK/names.csv

if [[ ! -f "$WORK/names.csv" ]]
then
    echo "Missing: $WORK/names.csv"
    exit 1
fi

NUM_INSTRS=$(tail -n +2 $WORK/names.csv | wc -l)

if [[ $NUM_INSTRS -eq 0 ]]
then
    touch $DIR/empty.txt
    exit 1
fi

python3 scripts/combine_pdfs.py $WORK/combined_index.yml -o $WORK/all_io_subs.pdf
