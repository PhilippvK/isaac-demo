#!/bin/bash

set -e

NOW=$(date +%Y%m%dT%H%M%S)

if [[ "$#" -lt 3 ]]
then
    echo "Illegal number of parameters"
    exit 1
fi

NAME=${1}
INPUTS=${2}
MODE=${3}  # multiple_sets, merged_set, optimized_set
BENCHMARKS=${4:-coremark,dhrystone}  # TODO: add more
DATE=${5:-now} # valid: now/latest/20241118101112
STEPS=${6:-all}

echo "NAME=$NAME"
echo "MODE=$MODE"
echo "INPUTS=$INPUTS"
echo "BENCHMARKS=$BENCHMARKS"
echo "DATE=$DATE"
echo "STEPS=$STEPS"

# OUT_DIR_BASE=$(pwd)/out
EVAL_DIR=out/eval_merge/$NAME/

NEW=0

if [[ "$DATE" == "now" ]]
then
    NEW=1
    DATE=$NOW
elif [[ "$DATE" == "latest" ]]
then
    if [[ ! -d "$EVAL_DIR" ]]
    then
        echo "Directory does not exists: $EVAL_DIR"
        exit 1
    fi
    LATEST=$(ls $EVAL_DIR | sort | tail -1)
    echo "LATEST=$LATEST"
    DATE=$LATEST
fi

echo "DATE=$DATE"
echo "NEW=$NEW"
DATE_DIR=$EVAL_DIR/$DATE
OUT_DIR=$DATE_DIR
echo "OUT_DIR=$OUT_DIR"
TIMES_FILE="$OUT_DIR/times.csv"
ENV_FILE="$OUT_DIR/vars.env"
INI_FILE="$OUT_DIR/experiment.ini"

if [[ $NEW -eq 1 ]]
then
    echo "Initialized directory: $OUT_DIR"
    mkdir -p $OUT_DIR
fi

if [[ ! -d "$OUT_DIR/" ]]
then
    echo "Directory does not exists: $OUT_DIR"
    exit 1
fi

LABEL=eval-merge-$NAME-$MODE-$BENCH-$DATE

if [[ $NEW -eq 1 ]]
then
    cat <<EOT > $ENV_FILE
ARCH=$ARCH
ABI=$ABI
GLOBAL_ISEL=$GLOBAL_ISEL
UNROLL=$UNROLL
OPTIMIZE=$OPTIMIZE
TARGET=$ETISS
CCACHE=$CCACHE
LLVM_BUILD_TYPE=$LLVM_BUILD_TYPE
LLVM_ENABLE_ASSERTIONS=$LLVM_ENABLE_ASSERTIONS
CDFG_STAGE=$CDFG_STAGE
FORCE_PURGE_DB=$FORCE_PURGE_DB
HLS_TOOL=$HLS_TOOL
HLS_LIBRARY=$HLS_LIBRARY
HLS_RESOURCE_MODEL=$HLS_RESOURCE_MODEL
HLS_CLOCK_NS=$HLS_CLOCK_NS
HLS_CORE_NAME=$HLS_CORE_NAME
SYN_TOOL=$SYN_TOOL
SYN_PDK=$SYN_PDK
SYN_CLOCK_NS=$SYN_CLOCK_NS
SYN_CORE_NAME=$SYN_CORE_NAME
EOT

    cat <<EOT > $INI_FILE
[$LABEL]
name=$NAME
mode=$MODE
benchmarks=$BENCHMARKS
datetime=$DATE
directory=$(readlink -f $OUT_DIR)
comment=""
EOT
fi


if [[ "$STEPS" == "all" ]]
then
    if [[ "$MODE" == "multiple_sets" ]]
    then
        STEPS="bench_multi_0;collect_sets;seal5_multi_0;etiss_multi_0;hls_multi_0;syn_multi_0;compare_multi_0;retrace_multi_0;reanalyze_multi_0"
    if [[ "$MODE" == "merged_set" ]]
    then
        STEPS="bench_multi_0;collect_sets;merge_sets_0;isaac_multi_0_etiss;seal5_multi_0;etiss_multi_0;hls_multi_0;syn_multi_0;compare_multi_0;retrace_multi_0;reanalyze_multi_0"
    if [[ "$MODE" == "optimized_set" ]]
    then
        STEPS="bench_multi_0;collect_sets;merge_sets_0;optimize_set_0;isaac_multi_0_etiss;seal5_multi_0;etiss_multi_0;hls_multi_0;syn_multi_0;compare_multi_0;retrace_multi_0;reanalyze_multi_0"
    else
        echo "Unhandled mode: $MODE"
    fi
fi
STEPS=($(echo $STEPS | tr ';' ' '|tr -s ' '))
echo "STEPS=${STEPS[@]}"

# set -e

measure_times() {
    LABEL=$1
    OUT_FILE=$2
    shift 2
    test -f $OUT_DIR/failing.txt && rm $OUT_DIR/failing.txt || :
    echo Executing: $@
    t0=$(printf "%f" $(echo "scale=3; $(date +%s%N)/1000000000" | bc))
    set +e
    "$@"
    EXIT_CODE=$?
    # echo "EXIT_CODE=$EXIT_CODE"
    set -e
    if [[ $EXIT_CODE -ne 0 ]]
    then
        echo "ERROR ($EXIT_CODE) while executing: $@"
        touch $OUT_DIR/failing.txt
        exit 1
    fi
    t1=$(printf "%f" $(echo "scale=2; $(date +%s%N)/1000000000" | bc))
    # td=$(echo "$t1-$t0" | bc -l)
    td=$(echo "scale=2; $t1-$t0" | bc)
    if [[ "$OUT_FILE" == "-" ]]
    then
        echo "label=$LABEL"
        echo "t0=$t0"
        echo "t1=$t1"
        echo "td=$td"
    else
        if [[ ! -f "$OUT_FILE" ]]
        then
            echo "label,t0,t1,td" > $OUT_FILE
        fi
        echo "$LABEL,$t0,$t1,$td" >> $OUT_FILE
    fi
}

lookup_script() {
    STEP=$1
    if [[ "$STEP" == "bench_0" ]]
    then
        echo -n "./scripts/flow0.sh"
    elif [[ "$STEP" == "trace_0" ]]
    then
        echo -n "./scripts/flow1.sh"
    elif [[ "$STEP" == "isaac_0_load" ]]
    then
        echo -n "./scripts/flow2.sh"
    elif [[ "$STEP" == "isaac_0_analyze" ]]
    then
        echo -n "./scripts/flow2_.sh"
    elif [[ "$STEP" == "isaac_0_visualize" ]]
    then
        echo -n "./scripts/flow2_viz.sh"
    elif [[ "$STEP" == "isaac_0_pick" ]]
    then
        echo -n "./scripts/flow3.sh"
    elif [[ "$STEP" == "isaac_0_cdfg" ]]
    then
        echo -n "./scripts/flow3_.sh"
    elif [[ "$STEP" == "isaac_0_query" ]]
    then
        echo -n "./scripts/flow4.sh"
    elif [[ "$STEP" == "isaac_0_etiss" ]]
    then
        echo -n "./scripts/flow5.sh"
    elif [[ "$STEP" == "seal5_0" ]]
    then
        echo -n "./scripts/flow6.sh"
    elif [[ "$STEP" == "etiss_0" ]]
    then
        echo -n "./scripts/flow7.sh"
    elif [[ "$STEP" == "hls_0" ]]
    then
        echo -n "./scripts/flow8.sh"
    elif [[ "$STEP" == "syn_0" ]]
    then
        echo -n "./scripts/flow9.sh"
    elif [[ "$STEP" == "compare_0" ]]
    then
        echo -n "./scripts/flow10.sh"
    elif [[ "$STEP" == "compare_others_0" ]]
    then
        echo -n "./scripts/flow10_.sh"
    elif [[ "$STEP" == "retrace_0" ]]
    then
        echo -n "./scripts/flow11.sh"
    elif [[ "$STEP" == "reanalyze_0" ]]
    then
        echo -n "./scripts/flow12.sh"
    elif [[ "$STEP" == "cleanup_0" ]]
    then
        echo -n "./scripts/flow13.sh"
    else
        echo "Lookup failed for step: $STEP" >&2
        exit 1
    fi

}

for step in "${STEPS[@]}"
do
   echo "Running step: $step"
   script=$(lookup_script $step)
   measure_times $step $TIMES_FILE $script $OUT_DIR
done
