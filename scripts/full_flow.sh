#!/bin/bash


set -e

NOW=$(date +%Y%m%dT%H%M%S)

BENCH=${1:-coremark}
DATE=${2:-now} # valid: now/latest/20241118101112
STEPS=${3:-all}

echo "BENCH=$BENCH"
echo "DATE=$DATE"
echo "STEPS=$STEPS"

OUT_DIR_BASE=$(pwd)/out
BENCH_DIR=out/$BENCH/

NEW=0

if [[ "$DATE" == "now" ]]
then
    NEW=1
    DATE=$NOW
elif [[ "$DATE" == "latest" ]]
then
    if [[ ! -d "$BENCH_DIR" ]]
    then
        echo "Directory does not exists: $BENCH_DIR"
        exit 1
    fi
    LATEST=$(ls $BENCH_DIR | sort | tail -1)
    echo "LATEST=$LATEST"
    DATE=$LATEST
fi

echo "DATE=$DATE"
echo "NEW=$NEW"
DATE_DIR=$BENCH_DIR/$DATE
OUT_DIR=$DATE_DIR
echo "OUT_DIR=$OUT_DIR"
TIMES_FILE="$OUT_DIR/times.csv"

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


if [[ "$STEPS" == "all" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_etiss;seal5_0;etiss_0;hls_0;syn_0;compare_0;compare_others_0;retrace_0;reanalyze_0"
elif [[ "$STEPS" == "until_isaac" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_etiss"
elif [[ "$STEPS" == "all_skip_hls" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_etiss;seal5_0;etiss_0;compare_0;compare_others_0;retrace_0;reanalyze_0"
elif [[ "$STEPS" == "all_skip_syn" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_etiss;seal5_0;etiss_0;hls_0;compare_0;compare_others_0;retrace_0;reanalyze_0"
fi
STEPS=($(echo $STEPS | tr ';' ' '|tr -s ' '))
echo "STEPS=${STEPS[@]}"

set -e

measure_times() {
    LABEL=$1
    OUT_FILE=$2
    shift 2
    echo Executing: $@
    t0=$(printf "%f" $(echo "scale=3; $(date +%s%N)/1000000000" | bc))
    "$@"
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
