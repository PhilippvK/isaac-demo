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

echo "STEPS=$STEPS"

if [[ "$STEPS" != "all" ]]
then
    echo "STEPS!=all not implemented"
    exit 1
fi

set -e

measure_times() {
    LABEL=$1
    OUT_FILE=$2
    shift 2
    t0=$(printf "%f" $(($(date +%s%N)/1000000000)))
    "$@"
    t1=$(printf "%f" $(($(date +%s%N)/1000000000)))
    td=$(echo "$t1-$t0" | bc -l)
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

### echo "RUN: flow.sh"
### measure_times trace_0 $TIMES_FILE ./scripts/flow.sh $OUT_DIR
### # TODO split bench to different file
###
###
### echo "RUN: flow2.sh"
### measure_times isaac_0_load $TIMES_FILE ./scripts/flow2.sh $OUT_DIR
### # TODO split analyze to different file
###
### echo "RUN: flow3.sh"
### measure_times isaac_0_pick $TIMES_FILE ./scripts/flow3.sh $OUT_DIR
###
### echo "RUN: flow4.sh"
### measure_times isaac_0_query $TIMES_FILE ./scripts/flow4.sh $OUT_DIR
###
### echo "RUN: flow5.sh"
### measure_times isaac_0_etiss $TIMES_FILE ./scripts/flow5.sh $OUT_DIR
###
### echo "RUN: flow6.sh"
### measure_times seal5_0 $TIMES_FILE ./scripts/flow6.sh $OUT_DIR
###
### echo "RUN: flow7.sh"
### measure_times m2isar_0 $TIMES_FILE ./scripts/flow7.sh $OUT_DIR
###
### echo "RUN: flow8.sh"
measure_times hls_0 $TIMES_FILE ./scripts/flow8.sh $OUT_DIR
###
### echo "RUN: flow9.sh"
### # measure_times syn_0 $TIMES_FILE ./scripts/flow9.sh $OUT_DIR
###
### echo "RUN: flow10.sh"
### measure_times compare_0 $TIMES_FILE ./scripts/flow10.sh $OUT_DIR
###
### echo "RUN: flow11.sh"
### measure_times retrace_0 $TIMES_FILE ./scripts/flow11.sh $OUT_DIR
