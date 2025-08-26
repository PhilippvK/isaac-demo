#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

# TODO: expose
# START_CLK_NS=40
# START_CLK_NS=25
# START_UTIL=40
# CORE_NAME=VexRiscv_4s
# CORE_NAME=${SYN_CORE_NAME:-VexRiscv_5s}
# TODO: clock? -> do not hardcode in constraint file!

# TODO: measure how long it takes

# TODO: parse FILTERD2,...

WORK=$DIR/work

# cp $WORK/docker/hls/output/ISAX_XIsaac.sv $WORK/docker/hls/output/$CORE_NAME
# docker run -it --rm -v /work/git/tuda/isax-tools-integration/:/isax-tools -v $(pwd):$(pwd) isaac-quickstart-hls:latest "date && cd /isax-tools && volare enable --pdk sky130 0fe599b2afb6708d281543108caf8310912f54af && python3 dse.py $WORK/docker/hls/output/$CORE_NAME/ $WORK/docker/hls/syn_dir prj LEGACY $START_CLK_NS $START_UTIL top clk"
# PERIOD_NS=$(cat $WORK/docker/hls/syn_dir/best.csv | tail -1 | cut -d, -f2)
# FP_UTIL=$(cat $WORK/docker/hls/syn_dir/best.csv | tail -1 | cut -d, -f3)
# echo "PERIOD_NS=${PERIOD_NS}ns FP_UTIL=${FP_UTIL}%"
# PRJ="prj_LEGACY_${PERIOD_NS}ns_${FP_UTIL}%"
# python3 scripts/collect_syn_metrics.py $WORK/docker/hls/syn_dir/$PRJ --output $WORK/docker/hls/syn_metrics.csv --print --min --rename
# # NEW:
# # python3 -m isaac_toolkit.eval.ise.asip_syn.ol2 --sess $SESS --workdir $WORK --set-name XIsaac --docker --core $CORE_NAME --pdk sky130
# # python3 -m isaac_toolkit.eval.ise.asip_syn.synopsys --sess $SESS --workdir $WORK --set-name XIsaac --docker --core $CORE_NAME --pdk nangate45

ASIP_SYN_SKIP_BASELINE=${ASIP_SYN_SKIP_BASELINE:-0}
ASIP_SYN_BASELINE_USE=${ASIP_SYN_BASELINE_USE:-""}
ASIP_SYN_SKIP_DEFAULT=${ASIP_SYN_SKIP_DEFAULT:-0}
ASIP_SYN_SKIP_SHARED=${ASIP_SYN_SKIP_SHARED:-0}

FPGA_SYN_SKIP_BASELINE=${FPGA_SYN_SKIP_BASELINE:-0}
FPGA_SYN_BASELINE_USE=${FPGA_SYN_BASELINE_USE:-""}
FPGA_SYN_SKIP_DEFAULT=${FPGA_SYN_SKIP_DEFAULT:-0}
FPGA_SYN_SKIP_SHARED=${FPGA_SYN_SKIP_SHARED:-0}

ASIP_SYN_ENABLE=${ASIP_SYN_ENABLE:-1}
ASIP_SYN_TOOL=${ASIP_SYN_TOOL:-synopsys}
ASIP_SYN_SEARCH_FMAX=${ASIP_SYN_SEARCH_FMAX:-0}

FPGA_SYN_ENABLE=${FPGA_SYN_ENABLE:-1}
FPGA_SYN_TOOL=${FPGA_SYN_TOOL:-vivado}

ASIP_SYN_SYNOPSYS_CORE_NAME=${ASIP_SYN_SYNOPSYS_CORE_NAME:-CVA5}
ASIP_SYN_SYNOPSYS_CLK_PERIOD=${ASIP_SYN_SYNOPSYS_CLK_PERIOD:-50.0}
ASIP_SYN_SYNOPSYS_PDK=${ASIP_SYN_SYNOPSYS_PDK:-nangate45}

FPGA_SYN_VIVADO_CORE_NAME=${FPGA_SYN_VIVADO_CORE_NAME:-CVA5}
FPGA_SYN_VIVADO_CLK_PERIOD=${FPGA_SYN_VIVADO_CLK_PERIOD:-50.0}
FPGA_SYN_VIVADO_PART=${FPGA_SYN_VIVADO_PART:-xc7a200tffv1156-1}
FPGA_SYN_SEARCH_FMAX=${FPGA_SYN_SEARCH_FMAX:-0}

HLS_TOOL=${HLS_TOOL:-1}
HLS_NAILGUN_SHARE_RESOURCES=${HLS_NAILGUN_SHARE_RESOURCES:-1}

COLLECT_ASIP_ARGS=""
COLLECT_ASIP_FMAX_ARGS=""
if [[ "$ASIP_SYN_ENABLE" == 1 ]]
then
    if [[ "$ASIP_SYN_SKIP_BASELINE" == 0 ]]
    then
        if [[ "$ASIP_SYN_TOOL" == "synopsys" ]]
        then
            if [[ "$ASIP_SYN_BASELINE_USE" != "" ]]
            then
                if [[ ! -d "$ASIP_SYN_BASELINE_USE" ]]
                then
                    echo "Missing: $ASIP_SYN_BASELINE_USE"
                    exit 1
                fi
                COLLECT_ASIP_ARGS="$COLLECT_ASIP_ARGS --baseline-dir $ASIP_SYN_BASELINE_USE"
                if [[ "$ASIP_SYN_SEARCH_FMAX" == "1" ]]
                then
                    COLLECT_ASIP_FMAX_ARGS="$COLLECT_ASIP_FMAX_ARGS --baseline-dir $(realpath -s $ASIP_SYN_BASELINE_USE)_fmax"
                fi
            else
                mkdir -p $WORK/docker/asip_syn/baseline/rtl
                cp $WORK/docker/hls/baseline/rtl/* $WORK/docker/asip_syn/baseline/rtl
                ./asip_syn_script.sh $WORK/docker/asip_syn/baseline/ $WORK/docker/asip_syn/baseline/rtl $ASIP_SYN_SYNOPSYS_CORE_NAME $ASIP_SYN_SYNOPSYS_PDK $ASIP_SYN_SYNOPSYS_CLK_PERIOD $WORK/docker/asip_syn/baseline/constraints.sdc
                COLLECT_ASIP_ARGS="$COLLECT_ASIP_ARGS --baseline-dir $WORK/docker/asip_syn/baseline/"
                if [[ "$ASIP_SYN_SEARCH_FMAX" == "1" ]]
                then
                    echo "TODO"
                    DSE_DIR=$WORK/docker/asip_syn/baseline_dse
                    FMAX_DIR=$WORK/docker/asip_syn/baseline_fmax
                    # TODO: copy fmax dir
                    # TODO: cleanup dse dir
                    COLLECT_ASIP_FMAX_ARGS="$COLLECT_ASIP_FMAX_ARGS --baseline-dir $FMAX_DIR"
                fi
           fi
        elif [[ "$ASIP_SYN_TOOL" == "ol2" ]]
        then
            echo "Unimplemented ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        else
            echo "Unsupported ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        fi
    fi
    if [[ "$ASIP_SYN_SKIP_DEFAULT" == 0 ]]
    then
        if [[ "$ASIP_SYN_TOOL" == "synopsys" ]]
        then
            mkdir -p $WORK/docker/asip_syn/default/rtl
            cp $WORK/docker/hls/default/rtl/* $WORK/docker/asip_syn/default/rtl
            ./asip_syn_script.sh $WORK/docker/asip_syn/default $WORK/docker/asip_syn/default/rtl $ASIP_SYN_SYNOPSYS_CORE_NAME $ASIP_SYN_SYNOPSYS_PDK $ASIP_SYN_SYNOPSYS_CLK_PERIOD $WORK/docker/asip_syn/default/constraints.sdc
            COLLECT_ASIP_ARGS="$COLLECT_ASIP_ARGS --default-dir $WORK/docker/asip_syn/default/"
            if [[ "$ASIP_SYN_SEARCH_FMAX" == "1" ]]
            then
                echo "TODO"
                DSE_DIR=$WORK/docker/asip_syn/default_dse
                FMAX_DIR=$WORK/docker/asip_syn/default_fmax
                # TODO: copy fmax dir
                # TODO: cleanup dse dir
                COLLECT_ASIP_FMAX_ARGS="$COLLECT_ASIP_FMAX_ARGS --default-dir $FMAX_DIR"
            fi
        elif [[ "$ASIP_SYN_TOOL" == "ol2" ]]
        then
            echo "Unimplemented ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        else
            echo "Unsupported ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        fi
    fi
    if [[ "$ASIP_SYN_SKIP_SHARED" == 0 && $HLS_TOOL == "nailgun" && $HLS_NAILGUN_SHARE_RESOURCES == "1" ]]
    then
        if [[ "$ASIP_SYN_TOOL" == "synopsys" ]]
        then
            mkdir -p $WORK/docker/asip_syn/shared/rtl
            cp $WORK/docker/hls/shared/rtl/* $WORK/docker/asip_syn/shared/rtl
            ./asip_syn_script.sh $WORK/docker/asip_syn/shared $WORK/docker/asip_syn/shared/rtl $ASIP_SYN_SYNOPSYS_CORE_NAME $ASIP_SYN_SYNOPSYS_PDK $ASIP_SYN_SYNOPSYS_CLK_PERIOD $WORK/docker/asip_syn/shared/constraints.sdc
            COLLECT_ASIP_ARGS="$COLLECT_ASIP_ARGS --shared-dir $WORK/docker/asip_syn/shared/"
            if [[ "$ASIP_SYN_SEARCH_FMAX" == "1" ]]
            then
                echo "TODO"
                DSE_DIR=$WORK/docker/asip_syn/shared_dse
                FMAX_DIR=$WORK/docker/asip_syn/shared_fmax
                # TODO: copy fmax dir
                # TODO: cleanup dse dir
                COLLECT_ASIP_FMAX_ARGS="$COLLECT_ASIP_FMAX_ARGS --shared-dir $FMAX_DIR"
            fi
        elif [[ "$ASIP_SYN_TOOL" == "ol2" ]]
        then
            echo "Unimplemented ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        else
            echo "Unsupported ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        fi
    fi
fi
if [[ "$COLLECT_ASIP_ARGS" != "" ]]
then
    python3 scripts/collect_asip_syn_metrics.py $COLLECT_ASIP_ARGS --out $WORK/docker/asip_syn/metrics.csv
fi
if [[ "$COLLECT_ASIP_FMAX_ARGS" != "" ]]
then
    python3 scripts/collect_asip_syn_metrics.py $COLLECT_ASIP_FMAX_ARGS --out $WORK/docker/asip_syn/metrics_fmax.csv
fi

COLLECT_FPGA_ARGS=""
if [[ "$FPGA_SYN_ENABLE" == 1 ]]
then
    if [[ "$FPGA_SYN_SKIP_BASELINE" == 0 ]]
    then
        if [[ "$FPGA_SYN_TOOL" == "vivado" ]]
        then
            if [[ "$FPGA_SYN_BASELINE_USE" != "" ]]
            then
                if [[ ! -d "$FPGA_SYN_BASELINE_USE" ]]
                then
                    echo "Missing: $FPGA_SYN_BASELINE_USE"
                    exit 1
                fi
                COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --baseline-dir $FPGA_SYN_BASELINE_USE"
                if [[ "$FPGA_SYN_SEARCH_FMAX" == "1" ]]
                then
                    COLLECT_FPGA_FMAX_ARGS="$COLLECT_FPGA_FMAX_ARGS --baseline-dir $(realpath -s $FPGA_SYN_BASELINE_USE)_fmax"
                fi
            else
                ./scripts/fpga_syn_script.sh $WORK/docker/fpga_syn/baseline/ $WORK/docker/hls/baseline/rtl $FPGA_SYN_VIVADO_CORE_NAME $FPGA_SYN_VIVADO_PART $FPGA_SYN_VIVADO_CLK_PERIOD
                COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --baseline-dir $WORK/docker/fpga_syn/baseline/"
                if [[ "$FPGA_SYN_SEARCH_FMAX" == "1" ]]
                then
                    echo "TODO"
                    DSE_DIR=$WORK/docker/asip_syn/baseline_dse
                    FMAX_DIR=$WORK/docker/asip_syn/baseline_fmax
                    # TODO: copy fmax dir
                    # TODO: cleanup dse dir
                    COLLECT_FPGA_FMAX_ARGS="$COLLECT_FPGA_FMAX_ARGS --baseline-dir $FMAX_DIR"
                fi
            fi
        else
            echo "Unsupported FPGA_SYN_TOOL: $FPGA_SYN_TOOL"
            exit 1
        fi
    fi
    if [[ "$FPGA_SYN_SKIP_DEFAULT" == 0 ]]
    then
        if [[ "$FPGA_SYN_TOOL" == "vivado" ]]
        then
            ./scripts/fpga_syn_script.sh $WORK/docker/fpga_syn/default/ $WORK/docker/hls/default/rtl $FPGA_SYN_VIVADO_CORE_NAME $FPGA_SYN_VIVADO_PART $FPGA_SYN_VIVADO_CLK_PERIOD
            COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --default-dir $WORK/docker/fpga_syn/default/"
            if [[ "$FPGA_SYN_SEARCH_FMAX" == "1" ]]
            then
                echo "TODO"
                DSE_DIR=$WORK/docker/asip_syn/default_dse
                FMAX_DIR=$WORK/docker/asip_syn/default_fmax
                # TODO: copy fmax dir
                # TODO: cleanup dse dir
                COLLECT_FPGA_FMAX_ARGS="$COLLECT_FPGA_FMAX_ARGS --default-dir $FMAX_DIR"
            fi
        else
            echo "Unsupported FPGA_SYN_TOOL: $FPGA_SYN_TOOL"
            exit 1
        fi
    fi
    if [[ "$FPGA_SYN_SKIP_SHARED" == 0 && $HLS_TOOL == "nailgun" && $HLS_NAILGUN_SHARE_RESOURCES == "1" ]]
    then
        if [[ "$FPGA_SYN_TOOL" == "vivado" ]]
        then
            ./scripts/fpga_syn_script.sh $WORK/docker/fpga_syn/shared/ $WORK/docker/hls/shared/rtl $FPGA_SYN_VIVADO_CORE_NAME $FPGA_SYN_VIVADO_PART $FPGA_SYN_VIVADO_CLK_PERIOD
            COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --shared-dir $WORK/docker/fpga_syn/shared/"
            if [[ "$FPGA_SYN_SEARCH_FMAX" == "1" ]]
            then
                echo "TODO"
                DSE_DIR=$WORK/docker/asip_syn/shared_dse
                FMAX_DIR=$WORK/docker/asip_syn/shared_fmax
                # TODO: copy fmax dir
                # TODO: cleanup dse dir
                COLLECT_FPGA_FMAX_ARGS="$COLLECT_FPGA_FMAX_ARGS --shared-dir $FMAX_DIR"
            fi
        else
            echo "Unsupported FPGA_SYN_TOOL: $FPGA_SYN_TOOL"
            exit 1
        fi
    fi
fi

if [[ "$COLLECT_FPGA_ARGS" != "" ]]
then
    python3 scripts/collect_fpga_syn_metrics.py $COLLECT_FPGA_ARGS --out $WORK/docker/fpga_syn/metrics.csv
fi
if [[ "$COLLECT_FPGA_FMAX_ARGS" != "" ]]
then
    python3 scripts/collect_fpga_syn_metrics.py $COLLECT_FPGA_ARGS --out $WORK/docker/fpga_syn_fmax/metrics.csv
fi
