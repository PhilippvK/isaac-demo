#!/bin/bash

set -e

NOW=$(date +%Y%m%dT%H%M%S)

BENCH=${1:-help}
DATE=${2:-now} # valid: now/latest/20241118101112
STEPS=${3:-all}

if [[ "$BENCH" == "help" ]]
then
    echo "Usage: $0 BENCH_NAME [now|latest|20241118101112|...] [all|demo_iss|...]"
    exit 1
fi

echo "BENCH=$BENCH"
echo "DATE=$DATE"
echo "STEPS=$STEPS"

OUT_DIR_BASE=${OUT_DIR_BASE:-out}
BENCH_DIR=$OUT_DIR_BASE/$BENCH/

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
ENV_FILE="$OUT_DIR/vars.env"
INI_FILE="$OUT_DIR/experiment.ini"
LOGS_DIR=$OUT_DIR/logs

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

LABEL=isaac-demo-$BENCH-$DATE

if [[ $NEW -eq 1 || $REFRESH -eq 1 ]]
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
ISAAC_LIMIT_RESULTS=${ISAAC_LIMIT_RESULTS}
ISAAC_MIN_ISO_WEIGHT=${ISAAC_MIN_ISO_WEIGHT}
ISAAC_SCALE_ISO_WEIGHT=${ISAAC_SCALE_ISO_WEIGHT}
ISAAC_SORT_BY=${ISAAC_SORT_BY}
ISAAC_TOPK=${ISAAC_TOPK}
ISAAC_PARTITION_WITH_MAXMISO=${ISAAC_PARTITION_WITH_MAXMISO}
HLS_ENABLE=${HLS_ENABLE}
HLS_SKIP_BASELINE=${HLS_SKIP_BASELINE}
HLS_SKIP_DEFAULT=${HLS_SKIP_DEFAULT}
HLS_SKIP_SHARED=${HLS_SKIP_SHARED}
HLS_NAILGUN_LIBRARY=${HLS_NAILGUN_LIBRARY}
HLS_NAILGUN_RESOURCE_MODEL=${HLS_NAILGUN_RESOURCE_MODEL}
HLS_NAILGUN_CLOCK_NS=${HLS_NAILGUN_CLOCK_NS}
HLS_NAILGUN_SCHEDULE_TIMEOUT=${HLS_NAILGUN_SCHEDULE_TIMEOUT}
HLS_NAILGUN_REFINE_TIMEOUT=${HLS_NAILGUN_REFINE_TIMEOUT}
HLS_NAILGUN_CORE_NAME=${HLS_NAILGUN_CORE_NAME}
HLS_NAILGUN_ILP_SOLVER=${HLS_NAILGUN_ILP_SOLVER}
HLS_NAILGUN_SCHED_ALGO_MS=${HLS_NAILGUN_SCHED_ALGO_MS}
HLS_NAILGUN_SCHED_ALGO_PA=${HLS_NAILGUN_SCHED_ALGO_PA}
HLS_NAILGUN_SCHED_ALGO_RA=${HLS_NAILGUN_SCHED_ALGO_RA}
HLS_NAILGUN_SCHED_ALGO_MI=${HLS_NAILGUN_SCHED_ALGO_MI}
HLS_NAILGUN_OL2_ENABLE=${HLS_NAILGUN_OL2_ENABLE}
HLS_NAILGUN_OL2_CONFIG_TEMPLATE=${HLS_NAILGUN_OL2_CONFIG_TEMPLATE}
HLS_NAILGUN_OL2_UNTIL_STEP=${HLS_NAILGUN_OL2_UNTIL_STEP}
HLS_NAILGUN_OL2_TARGET_FREQ=${HLS_NAILGUN_OL2_TARGET_FREQ}
HLS_NAILGUN_OL2_TARGET_UTIL=${HLS_NAILGUN_OL2_TARGET_UTIL}
HLS_NAILGUN_SHARE_RESOURCES=${HLS_NAILGUN_SHARE_RESOURCES}
ASIP_SYN_ENABLE=${ASIP_SYN_ENABLE}
ASIP_SYN_SKIP_BASELINE=${ASIP_SYN_SKIP_BASELINE}
ASIP_SYN_SKIP_DEFAULT=${ASIP_SYN_SKIP_DEFAULT}
ASIP_SYN_SKIP_SHARED=${ASIP_SYN_SKIP_SHARED}
ASIP_SYN_TOOL=${ASIP_SYN_TOOL}
ASIP_SYN_SYNOPSYS_PDK=${ASIP_SYN_SYNOPSYS_PDK}
ASIP_SYN_SYNOPSYS_CLOCK_NS=${ASIP_SYN_SYNOPSYS_CLOCK_NS}
ASIP_SYN_SYNOPSYS_CORE_NAME=${ASIP_SYN_SYNOPSYS_CORE_NAME}
FPGA_SYN_ENABLE=${FPGA_SYN_ENABLE}
FPGA_SYN_SKIP_BASELINE=${FPGA_SYN_SKIP_BASELINE}
FPGA_SYN_SKIP_DEFAULT=${FPGA_SYN_SKIP_DEFAULT}
FPGA_SYN_SKIP_SHARED=${FPGA_SYN_SKIP_SHARED}
FPGA_SYN_TOOL=${FPGA_SYN_TOOL}
FPGA_SYN_VIVADO_PART=${FPGA_SYN_VIVADO_PART}
FPGA_SYN_VIVADO_CLOCK_NS=${FPGA_SYN_VIVADO_CLOCK_NS}
FPGA_SYN_VIVADO_CORE_NAME=${FPGA_SYN_VIVADO_CORE_NAME}
ISAAC_QUERY_CONFIG_YAML=${ISAAC_QUERY_CONFIG_YAML}
EOT

# TODO:
# CHOOSE_BB_MIN_SUPPORTED_WEIGHT=...

    cat <<EOT > $INI_FILE
[$LABEL]
benchmark=$BENCH
datetime=$DATE
directory=$(readlink -f $OUT_DIR)
comment=""
EOT
fi


if [[ "$STEPS" == "all" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate;isaac_0_etiss;seal5_0;etiss_0;hls_0;syn_0;compare_0;compare_others_0;retrace_0;reanalyze_0"
elif [[ "$STEPS" == "all_new" ]]
then
    # STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate;assign_0_enc;isaac_0_etiss;seal5_0_splitted;assign_0_seal5;etiss_0;compare_0;compare_others_0;compare_0_per_instr;assign_0_compare_per_instr;filter_0;compare_0_filtered;assign_0_compare_filtered;compare_others_0_filtered;assign_0_compare_others_filtered;retrace_0_filtered;reanalyze_0_filtered;assign_0_util_filtered;filter_0_filtered;score_0_filtered2;sort_0_filtered2;select_0_filtered2;isaac_0_generate_prelim;isaac_0_etiss_prelim;hls_0_prelim;assign_0_hls_prelim;syn_0_prelim;assign_0_syn_prelim;filter_0_prelim;score_0_prelim;sort_0_prelim;select_0_prelim;isaac_0_generate_final;isaac_0_etiss_final;seal5_0_final;etiss_0_final;compare_0_final;compare_others_0_final;retrace_0_final;reanalyze_0_final"
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate;assign_0_enc;isaac_0_etiss;seal5_0_splitted;assign_0_seal5;etiss_0;compare_0;compare_others_0;compare_0_per_instr;assign_0_compare_per_instr;filter_0;spec_0_filtered;isaac_0_generate_filtered;isaac_0_etiss_filtered;hls_0_filtered;assign_0_hls_filtered;select_0_filtered;compare_0_filtered_selected;assign_0_compare_filtered_selected;compare_others_0_filtered_selected;assign_0_compare_others_filtered_selected;retrace_0_filtered_selected;reanalyze_0_filtered_selected;assign_0_util_filtered_selected;filter_0_filtered_selected;score_0_filtered2;sort_0_filtered2;select_0_filtered2;isaac_0_generate_filtered2_selected;isaac_0_etiss_filtered2_selected;hls_0_filtered2_selected;assign_0_hls_filtered2_selected;syn_0_filtered2_selected;assign_0_syn_filtered2_selected;filter_0_filtered2_selected;score_0_filtered2_selected;sort_0_filtered2_selected;select_0_filtered2_selected;isaac_0_generate_final;isaac_0_etiss_final;seal5_0_final;etiss_0_final;compare_0_final;compare_others_0_final;retrace_0_final;reanalyze_0_final"
    # STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;assign_0_enc;isaac_0_etiss;seal5_0_splitted;assign_0_seal5;etiss_0;compare_0_per_instr;assign_0_compare_per_instr;filter_0;compare_0;assign_0_compare;compare_others_0;assign_0_compare_others;retrace_0;reanalyze_0;assign_0_util;filter_0_prelim;score_0_prelim;sort_0_prelim;select_0_prelim;isaac_0_etiss_filtered;hls_0;assign_0_hls;syn_0;assign_0_syn"
elif [[ "$STEPS" == "until_isaac" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate;isaac_0_etiss"
elif [[ "$STEPS" == "until_isaac_new" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate"
    # ";assign_0_enc;isaac_0_etiss;seal5_0_splitted;assign_0_seal5;etiss_0;compare_0;compare_others_0;compare_0_per_instr;assign_0_compare_per_instr;filter_0;spec_0_filtered;select_0_filtered;compare_0_filtered_selected;assign_0_compare_filtered_selected;compare_others_0_filtered_selected;assign_0_compare_others_filtered_selected;retrace_0_filtered_selected;reanalyze_0_filtered_selected;assign_0_util_filtered_selected;filter_0_filtered_selected;score_0_filtered2;sort_0_filtered2;select_0_filtered2;isaac_0_generate_filtered2_selected;isaac_0_etiss_filtered2_selected;hls_0_filtered2_selected;assign_0_hls_filtered2_selected;syn_0_filtered2_selected;assign_0_syn_filtered2_selected;filter_0_filtered2_selected;score_0_filtered2_selected;sort_0_filtered2_selected;select_0_filtered2_selected;isaac_0_generate_final;isaac_0_etiss_final;seal5_0_final;etiss_0_final;compare_0_final;compare_others_0_final;retrace_0_final;reanalyze_0_final"
elif [[ "$STEPS" == "demo_iss" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate;assign_0_enc;isaac_0_etiss;seal5_0_splitted;assign_0_seal5;etiss_0;compare_0;compare_0_per_instr;assign_0_compare_per_instr;filter_0;isaac_0_generate_filtered;isaac_0_etiss_filtered"
elif [[ "$STEPS" == "demo_perf" ]]
then
    STEPS="bench_perf_0;trace_perf_0;isaac_0_load_perf;isaac_0_analyze_perf;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate;assign_0_enc;isaac_0_etiss;seal5_0_splitted;assign_0_seal5;etiss_perf_0;compare_perf_0;compare_0_per_instr;assign_0_compare_per_instr;filter_0;spec_0_filtered;select_0_filtered;compare_0_filtered_selected;fake_hls_0;etiss_perf_0;compare_perf_0_filtered_selected;assign_0_compare_filtered_selected;assign_0_compare_perf_filtered_selected;retrace_0_filtered_selected;reanalyze_0_filtered_selected;assign_0_util_filtered_selected"
elif [[ "$STEPS" == "demo_perf_alt" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate;assign_0_enc;isaac_0_etiss;seal5_0_splitted;assign_0_seal5;etiss_0;compare_0;compare_0_per_instr;assign_0_compare_per_instr;filter_0;isaac_0_generate_filtered;isaac_0_etiss_filtered;fake_hls_0_filtered;assign_0_fake_hls_filtered;select_0_filtered;compare_0_filtered_selected;assign_0_compare_filtered_selected;retrace_0_filtered_selected;reanalyze_0_filtered_selected;assign_0_util_filtered_selected"
elif [[ "$STEPS" == "all_skip_hls" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate;isaac_0_etiss;seal5_0;etiss_0;compare_0;compare_others_0;retrace_0;reanalyze_0"
elif [[ "$STEPS" == "all_skip_syn" ]]
then
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;isaac_0_generate;isaac_0_etiss;seal5_0;etiss_0;hls_0;compare_0;compare_others_0;retrace_0;reanalyze_0"
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
    # echo "$@"
    eval $@
    EXIT_CODE=$?
    # echo "EXIT_CODE=$EXIT_CODE"
    set -e
    if [[ $EXIT_CODE -ne 0 ]]
    then
        echo "ERROR ($EXIT_CODE) while executing: $@"
        echo $LABEL > $OUT_DIR/failing.txt
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
        # echo -n "./scripts/flow0.sh"
        echo -n "./scripts/flow_bench.sh"
    elif [[ "$STEP" == "trace_0" ]]
    then
        # echo -n "./scripts/flow1.sh"
        echo -n "./scripts/flow_trace.sh"
    elif [[ "$STEP" == "isaac_0_load" ]]
    then
        # echo -n "./scripts/flow2.sh"
        echo -n "./scripts/flow_isaac_load.sh"
    elif [[ "$STEP" == "isaac_0_analyze" ]]
    then
        # echo -n "./scripts/flow2_.sh"
        echo -n "./scripts/flow_isaac_analyze.sh"
    elif [[ "$STEP" == "isaac_0_visualize" ]]
    then
        # echo -n "./scripts/flow2_viz.sh"
        echo -n "./scripts/flow_isaac_visualize.sh"
    elif [[ "$STEP" == "isaac_0_pick" ]]
    then
        # echo -n "./scripts/flow3.sh"
        echo -n "./scripts/flow_isaac_pick.sh"
    elif [[ "$STEP" == "isaac_0_cdfg" ]]
    then
        # echo -n "./scripts/flow3_.sh"
        echo -n "./scripts/flow_isaac_cdfg.sh"
    elif [[ "$STEP" == "isaac_0_query" ]]
    then
        # echo -n "./scripts/flow4.sh"
        echo -n "./scripts/flow_isaac_query.sh"
    elif [[ "$STEP" == "isaac_0_generate" ]]
    then
        # echo -n "./scripts/flow4.sh"
        echo -n "./scripts/flow_isaac_generate.sh"
    elif [[ "$STEP" == "isaac_0_generate_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_isaac_generate.sh"
    elif [[ "$STEP" == "isaac_0_generate_prelim" ]]
    then
        # echo -n "./scripts/flow4.sh"
        echo -n "PRELIM=1 ./scripts/flow_isaac_generate.sh"
    elif [[ "$STEP" == "isaac_0_generate_filtered2_selected" ]]
    then
        # echo -n "./scripts/flow4.sh"
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_isaac_generate.sh"
    elif [[ "$STEP" == "isaac_0_generate_final" ]]
    then
        # echo -n "./scripts/flow4.sh"
        echo -n "FINAL=1 ./scripts/flow_isaac_generate.sh"
    elif [[ "$STEP" == "isaac_0_etiss" ]]
    then
        # echo -n "./scripts/flow5.sh"
        echo -n "./scripts/flow_isaac_etiss.sh"
    elif [[ "$STEP" == "isaac_0_etiss_filtered" ]]
    then
        # echo -n "FILTERED=1 ./scripts/flow5.sh"
        echo -n "FILTERED=1 ./scripts/flow_isaac_etiss.sh"
    elif [[ "$STEP" == "isaac_0_etiss_prelim" ]]
    then
        echo -n "PRELIM=1 ./scripts/flow_isaac_etiss.sh"
    elif [[ "$STEP" == "isaac_0_etiss_filtered2_selected" ]]
    then
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_isaac_etiss.sh"
    elif [[ "$STEP" == "isaac_0_etiss_final" ]]
    then
        echo -n "FINAL=1 ./scripts/flow_isaac_etiss.sh"
    elif [[ "$STEP" == "seal5_0" ]]
    then
        # echo -n "SPLITTED=0 ./scripts/flow6.sh"
        echo -n "SPLITTED=0 ./scripts/flow_seal5.sh"
    elif [[ "$STEP" == "seal5_0_splitted" ]]
    then
        # echo -n "SPLITTED=1 ./scripts/flow6.sh"
        echo -n "SPLITTED=1 ./scripts/flow_seal5.sh"
    elif [[ "$STEP" == "seal5_0_final" ]]
    then
        echo -n "FINAL=1 SPLITTED=0 ./scripts/flow_seal5.sh"
    elif [[ "$STEP" == "etiss_0" ]]
    then
        # echo -n "./scripts/flow7.sh"
        echo -n "./scripts/flow_etiss.sh"
    elif [[ "$STEP" == "etiss_0_final" ]]
    then
        echo -n "FINAL=1 ./scripts/flow_etiss.sh"
    elif [[ "$STEP" == "hls_0" ]]
    then
        # echo -n "./scripts/flow8.sh"
        echo -n "./scripts/flow_hls.sh"
    elif [[ "$STEP" == "hls_0_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_hls.sh"
    elif [[ "$STEP" == "hls_0_prelim" ]]
    then
        # echo -n "./scripts/flow8.sh"
        echo -n "PRELIM=1 ./scripts/flow_hls.sh"
    elif [[ "$STEP" == "hls_0_filtered2_selected" ]]
    then
        # echo -n "./scripts/flow8.sh"
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_hls.sh"
    elif [[ "$STEP" == "fake_hls_0" ]]
    then
        # echo -n "./scripts/flow8.sh"
        echo -n "./scripts/flow_fake_hls.sh"
    elif [[ "$STEP" == "fake_hls_0_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_fake_hls.sh"
    elif [[ "$STEP" == "fake_hls_0_prelim" ]]
    then
        # echo -n "./scripts/flow8.sh"
        echo -n "PRELIM=1 ./scripts/flow_fake_hls.sh"
    elif [[ "$STEP" == "fake_hls_0_filtered2_selected" ]]
    then
        # echo -n "./scripts/flow8.sh"
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_fake_hls.sh"
    elif [[ "$STEP" == "syn_0" ]]
    then
        # echo -n "./scripts/flow9.sh"
        echo -n "./scripts/flow_syn.sh"
    elif [[ "$STEP" == "syn_0_prelim" ]]
    then
        # echo -n "./scripts/flow9.sh"
        echo -n "PRELIM=1 ./scripts/flow_syn.sh"
    elif [[ "$STEP" == "syn_0_filtered2_selected" ]]
    then
        # echo -n "./scripts/flow9.sh"
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_syn.sh"
    elif [[ "$STEP" == "compare_0" ]]
    then
        # echo -n "./scripts/flow10.sh"
        echo -n "./scripts/flow_compare.sh"
    elif [[ "$STEP" == "compare_0_filtered" ]]
    then
        # echo -n "./scripts/flow10.sh"
        echo -n "FILTERED=1 BUILD_ARCH=1 ./scripts/flow_compare.sh"
    elif [[ "$STEP" == "compare_0_filtered_selected" ]]
    then
        # echo -n "./scripts/flow10.sh"
        echo -n "FILTERED=1 SELECTED=1 BUILD_ARCH=1 ./scripts/flow_compare.sh"
    elif [[ "$STEP" == "compare_0_per_instr" ]]
    then
        # echo -n "./scripts/flow10_per_instr.sh"
        echo -n "./scripts/flow_compare_per_instr.sh"
    elif [[ "$STEP" == "filter_0" ]]
    then
        # echo -n "./scripts/flow10_filter.sh"
        echo -n "./scripts/flow_filter.sh"
    elif [[ "$STEP" == "filter_0_filtered" ]]
    then
        # echo -n "./scripts/flow10_filter.sh"
        echo -n "FILTERED=1 ./scripts/flow_filter.sh"
    elif [[ "$STEP" == "filter_0_filtered_selected" ]]
    then
        # echo -n "./scripts/flow10_filter.sh"
        echo -n "FILTERED=1 SELECTED=1 ./scripts/flow_filter.sh"
    elif [[ "$STEP" == "filter_0_prelim" ]]
    then
        echo -n "PRELIM=1 ./scripts/flow_filter.sh"
    elif [[ "$STEP" == "filter_0_filtered2_selected" ]]
    then
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_filter.sh"
    elif [[ "$STEP" == "compare_others_0" ]]
    then
        # echo -n "./scripts/flow10_.sh"
        echo -n "./scripts/flow_compare_others.sh"
    elif [[ "$STEP" == "compare_others_0_filtered" ]]
    then
        # echo -n "./scripts/flow10_.sh"
        echo -n "FILTERED=1 BUILD_ARCH=1 ./scripts/flow_compare_others.sh"
    elif [[ "$STEP" == "compare_others_0_filtered_selected" ]]
    then
        # echo -n "./scripts/flow10_.sh"
        echo -n "FILTERED=1 SELECTED=1 BUILD_ARCH=1 ./scripts/flow_compare_others.sh"
    elif [[ "$STEP" == "retrace_0" ]]
    then
        # echo -n "./scripts/flow11.sh"
        echo -n "./scripts/flow_retrace.sh"
    elif [[ "$STEP" == "retrace_0_filtered" ]]
    then
        # echo -n "./scripts/flow11.sh"
        echo -n "FILTERED=1 BUILD_ARCH=1 ./scripts/flow_retrace.sh"
    elif [[ "$STEP" == "retrace_0_filtered_selected" ]]
    then
        # echo -n "./scripts/flow11.sh"
        echo -n "FILTERED=1 SELECTED=1 BUILD_ARCH=1 ./scripts/flow_retrace.sh"
    elif [[ "$STEP" == "retrace_0_prelim" ]]
    then
        # echo -n "./scripts/flow11.sh"
        echo -n "PRELIM=1 ./scripts/flow_retrace.sh"
    elif [[ "$STEP" == "retrace_0_filtered2_selected" ]]
    then
        # echo -n "./scripts/flow11.sh"
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_retrace.sh"
    elif [[ "$STEP" == "retrace_0_final" ]]
    then
        # echo -n "./scripts/flow11.sh"
        echo -n "FINAL=1 ./scripts/flow_retrace.sh"
    elif [[ "$STEP" == "reanalyze_0" ]]
    then
        # echo -n "./scripts/flow12.sh"
        echo -n "./scripts/flow_reanalyze.sh"
    elif [[ "$STEP" == "reanalyze_0_filtered" ]]
    then
        # echo -n "./scripts/flow12.sh"
        echo -n "FILTERED=1 ./scripts/flow_reanalyze.sh"
    elif [[ "$STEP" == "reanalyze_0_filtered_selected" ]]
    then
        # echo -n "./scripts/flow12.sh"
        echo -n "FILTERED=1 SELECTED=1 ./scripts/flow_reanalyze.sh"
    elif [[ "$STEP" == "reanalyze_0_prelim" ]]
    then
        # echo -n "./scripts/flow12.sh"
        echo -n "PRELIM=1 ./scripts/flow_reanalyze.sh"
    elif [[ "$STEP" == "reanalyze_0_filtered2_selected" ]]
    then
        # echo -n "./scripts/flow12.sh"
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_reanalyze.sh"
    elif [[ "$STEP" == "reanalyze_0_final" ]]
    then
        # echo -n "./scripts/flow12.sh"
        echo -n "FINAL=1 ./scripts/flow_reanalyze.sh"
    elif [[ "$STEP" == "cleanup_0" ]]
    then
        # echo -n "./scripts/flow13.sh"
        echo -n "./scripts/flow_cleanup.sh"
    elif [[ "$STEP" == "assign_0_enc" ]]
    then
        echo -n "FILTERED=0 ./scripts/flow_assign_enc.sh"
    elif [[ "$STEP" == "assign_0_enc_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_assign_enc.sh"
    elif [[ "$STEP" == "assign_0_seal5" ]]
    then
        echo -n "FILTERED=0 ./scripts/flow_assign_seal5.sh"
    elif [[ "$STEP" == "assign_0_compare_per_instr" ]]
    then
        echo -n "FILTERED=0 ./scripts/flow_assign_compare_per_instr.sh"
    elif [[ "$STEP" == "assign_0_compare" ]]
    then
        echo -n "./scripts/flow_assign_compare.sh"
    elif [[ "$STEP" == "assign_0_compare_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_assign_compare.sh"
    elif [[ "$STEP" == "assign_0_compare_filtered_selected" ]]
    then
        echo -n "FILTERED=1 SELECTED=1 ./scripts/flow_assign_compare.sh"
    elif [[ "$STEP" == "assign_0_compare_others" ]]
    then
        echo -n "./scripts/flow_assign_compare_others.sh"
    elif [[ "$STEP" == "assign_0_compare_others_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_assign_compare_others.sh"
    elif [[ "$STEP" == "assign_0_compare_others_filtered_selected" ]]
    then
        echo -n "FILTERED=1 SELECTED=1 ./scripts/flow_assign_compare_others.sh"
    elif [[ "$STEP" == "assign_0_util" ]]
    then
        echo -n "./scripts/flow_assign_util.sh"
    elif [[ "$STEP" == "assign_0_util_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_assign_util.sh"
    elif [[ "$STEP" == "assign_0_util_filtered_selected" ]]
    then
        echo -n "FILTERED=1 SELECTED=1 ./scripts/flow_assign_util.sh"
    elif [[ "$STEP" == "assign_0_hls" ]]
    then
        echo -n "./scripts/flow_assign_hls.sh"
    elif [[ "$STEP" == "assign_0_hls_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_assign_hls.sh"
    elif [[ "$STEP" == "assign_0_hls_prelim" ]]
    then
        echo -n "PRELIM=1 ./scripts/flow_assign_hls.sh"
    elif [[ "$STEP" == "assign_0_hls_filtered2_selected" ]]
    then
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_assign_hls.sh"
    elif [[ "$STEP" == "assign_0_fake_hls" ]]
    then
        echo -n "./scripts/flow_assign_fake_hls.sh"
    elif [[ "$STEP" == "assign_0_fake_hls_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_assign_fake_hls.sh"
    elif [[ "$STEP" == "assign_0_fake_hls_prelim" ]]
    then
        echo -n "PRELIM=1 ./scripts/flow_assign_fake_hls.sh"
    elif [[ "$STEP" == "assign_0_fake_hls_filtered2_selected" ]]
    then
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_assign_fake_hls.sh"
    elif [[ "$STEP" == "assign_0_syn" ]]
    then
        echo -n "./scripts/flow_assign_syn.sh"
    elif [[ "$STEP" == "assign_0_syn_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_assign_syn.sh"
    elif [[ "$STEP" == "assign_0_syn_prelim" ]]
    then
        echo -n "PRELIM=1 ./scripts/flow_assign_syn.sh"
    elif [[ "$STEP" == "assign_0_syn_filtered2_selected" ]]
    then
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_assign_syn.sh"
    elif [[ "$STEP" == "score_0" ]]
    then
        echo -n "./scripts/flow_score.sh"
    elif [[ "$STEP" == "score_0_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_score.sh"
    elif [[ "$STEP" == "score_0_filtered_selected" ]]
    then
        echo -n "FILTERED=1 SELECTED=1 ./scripts/flow_score.sh"
    elif [[ "$STEP" == "score_0_filtered2" ]]
    then
        echo -n "FILTERED2=1 ./scripts/flow_score.sh"
    elif [[ "$STEP" == "score_0_prelim" ]]
    then
        echo -n "PRELIM=1 ./scripts/flow_score.sh"
    elif [[ "$STEP" == "score_0_filtered2_selected" ]]
    then
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_score.sh"
    elif [[ "$STEP" == "sort_0_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_sort.sh"
    elif [[ "$STEP" == "sort_0_filtered_selected" ]]
    then
        echo -n "FILTERED=1 SELECTED=1 ./scripts/flow_sort.sh"
    elif [[ "$STEP" == "sort_0_filtered2" ]]
    then
        echo -n "FILTERED2=1 ./scripts/flow_sort.sh"
    elif [[ "$STEP" == "sort_0_prelim" ]]
    then
        echo -n "PRELIM=1 ./scripts/flow_sort.sh"
    elif [[ "$STEP" == "sort_0_filtered2_selected" ]]
    then
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_sort.sh"
    elif [[ "$STEP" == "sort_0_final" ]]
    then
        echo -n "FINAL=1 ./scripts/flow_sort.sh"
    elif [[ "$STEP" == "spec_0_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_spec.sh"
    elif [[ "$STEP" == "select_0_filtered" ]]
    then
        echo -n "FILTERED=1 ./scripts/flow_select.sh"
    elif [[ "$STEP" == "select_0_filtered2" ]]
    then
        echo -n "FILTERED2=1 ./scripts/flow_select.sh"
    elif [[ "$STEP" == "select_0_prelim" ]]
    then
        echo -n "PRELIM=1 ./scripts/flow_select.sh"
    elif [[ "$STEP" == "select_0_filtered2_selected" ]]
    then
        echo -n "FILTERED2=1 SELECTED=1 ./scripts/flow_select.sh"
    elif [[ "$STEP" == "select_0_final" ]]
    then
        echo -n "FINAL=1 ./scripts/flow_select.sh"
    elif [[ "$STEP" == "compare_0_final" ]]
    then
        echo -n "FINAL=1 ./scripts/flow_compare.sh"
    elif [[ "$STEP" == "compare_others_0_final" ]]
    then
        echo -n "FINAL=1 ./scripts/flow_compare_others.sh"
    elif [[ "$STEP" == "retrace_0_final" ]]
    then
        echo -n "FINAL=1 ./scripts/flow_retrace.sh"
    elif [[ "$STEP" == "reanalyze_0_final" ]]
    then
        echo -n "FINAL=1 ./scripts/flow_reanalyze.sh"
    else
        echo "Lookup failed for step: $STEP" >&2
        exit 1
    fi
    STEPS="bench_0;trace_0;isaac_0_load;isaac_0_analyze;isaac_0_visualize;isaac_0_pick;isaac_0_cdfg;isaac_0_query;assign_0_enc;isaac_0_etiss;seal5_0_splitted;assign_0_seal5;etiss_0;compare_0_per_instr;assign_0_compare_per_instr;filter_0;compare_0;assign_0_compare;compare_others_0;assign_0_compare_others;retrace_0;reanalyze_0;assign_0_util;filter_0_prelim;score_0_prelim;sort_0_prelim;select_0_prelim;isaac_0_etiss_filtered;hls_0;assign_0_hls;syn_0;assign_0_syn;score_0_final;sort_0_final;select_0_final;compare_0_final;compare_others_0_final;retrace_0_final;reanalyze_0_final"  # TODO: replace

}

mkdir -p $LOGS_DIR

LOG_FILE=$LOGS_DIR/$NOW.log

for step in "${STEPS[@]}"
do
   echo "Running step: $step"
   script=$(lookup_script $step)
   set -o pipefail
   if [[ "$QUIET" == "1" ]]
   then
      measure_times $step $TIMES_FILE $script $OUT_DIR 2>&1 > $LOG_FILE
   else
      measure_times $step $TIMES_FILE $script $OUT_DIR 2>&1 | tee -a $LOG_FILE
   fi
   set +o pipefail
done
