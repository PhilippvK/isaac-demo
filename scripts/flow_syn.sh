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
# docker run -i --rm -v /work/git/tuda/isax-tools-integration/:/isax-tools -v $(pwd):$(pwd) isaac-quickstart-hls:latest "date && cd /isax-tools && volare enable --pdk sky130 0fe599b2afb6708d281543108caf8310912f54af && python3 dse.py $WORK/docker/hls/output/$CORE_NAME/ $WORK/docker/hls/syn_dir prj LEGACY $START_CLK_NS $START_UTIL top clk"
# PERIOD_NS=$(cat $WORK/docker/hls/syn_dir/best.csv | tail -1 | cut -d, -f2)
# FP_UTIL=$(cat $WORK/docker/hls/syn_dir/best.csv | tail -1 | cut -d, -f3)
# echo "PERIOD_NS=${PERIOD_NS}ns FP_UTIL=${FP_UTIL}%"
# PRJ="prj_LEGACY_${PERIOD_NS}ns_${FP_UTIL}%"
# python3 $SCRIPTS_DIR/collect_syn_metrics.py $WORK/docker/hls/syn_dir/$PRJ --output $WORK/docker/hls/syn_metrics.csv --print --min --rename
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
ASIP_SYN_SYNOPSYS_CLK_PERIOD=${ASIP_SYN_SYNOPSYS_CLK_PERIOD:-${ASIP_SYN_SYNOPSYS_CLOCK_NS:-50.0}}
ASIP_SYN_SYNOPSYS_PDK=${ASIP_SYN_SYNOPSYS_PDK:-nangate45}

FPGA_SYN_VIVADO_CORE_NAME=${FPGA_SYN_VIVADO_CORE_NAME:-CVA5}
FPGA_SYN_VIVADO_CLK_PERIOD=${FPGA_SYN_VIVADO_CLK_PERIOD:-50.0}
FPGA_SYN_VIVADO_PART=${FPGA_SYN_VIVADO_PART:-xc7a200tffv1156-1}
FPGA_SYN_SEARCH_FMAX=${FPGA_SYN_SEARCH_FMAX:-0}

HLS_TOOL=${HLS_TOOL:-1}
HLS_NAILGUN_SHARE_RESOURCES=${HLS_NAILGUN_SHARE_RESOURCES:-1}

# ASIP backends share variant selection, baseline reuse and report collection.
SCRIPTS_DIR=${SCRIPTS_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}
FLOW_SCRIPTS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
COLLECT_ASIP_ARGS=()
ASIP_VARIANTS=()
if [[ "$ASIP_SYN_ENABLE" == 1 ]]; then
    case "$ASIP_SYN_TOOL" in
        synopsys|dc)
            backend_suffix=""
            asip_core=$ASIP_SYN_SYNOPSYS_CORE_NAME
            asip_pdk=$ASIP_SYN_SYNOPSYS_PDK
            asip_clock=$ASIP_SYN_SYNOPSYS_CLK_PERIOD ;;
        ol2|openlane|openlane2|librelane)
            backend_suffix=_openlane2
            [[ $ASIP_SYN_TOOL != librelane ]] || backend_suffix=_librelane
            asip_core=${ASIP_SYN_OL2_CORE_NAME:-$ASIP_SYN_SYNOPSYS_CORE_NAME}
            asip_pdk=${ASIP_SYN_OL2_PDK:-sky130A}
            asip_clock=${ASIP_SYN_OL2_CLOCK_NS:-$ASIP_SYN_SYNOPSYS_CLK_PERIOD} ;;
        *) echo "Unsupported ASIP_SYN_TOOL: $ASIP_SYN_TOOL" >&2; exit 2 ;;
    esac
    if [[ "$ASIP_SYN_SEARCH_FMAX" == 1 ]]; then
        echo 'ASIP Fmax search is not implemented; run explicit period sweeps.' >&2; exit 2
    fi
    hls_mode=docker
    [[ ${USE_HLS_DOCKER:-1} != 0 ]] || hls_mode=local
    suffix=""
    if [[ ${PRELIM:-0} == 1 ]]; then suffix=_prelim
    elif [[ ${FINAL:-0} == 1 ]]; then suffix=_final
    elif [[ ${FILTERED2:-0} == 1 ]]; then suffix=_filtered2
    elif [[ ${FILTERED:-0} == 1 ]]; then suffix=_filtered; fi
    if [[ ${SELECTED:-0} == 1 && ( $suffix == _filtered || $suffix == _filtered2 ) ]]; then suffix+=_selected; fi
    asip_hls=${ASIP_SYN_HLS_DIR:-$WORK/$hls_mode/hls$suffix}
    asip_output=${ASIP_SYN_OUTPUT_DIR:-$WORK/$hls_mode/asip_syn$backend_suffix$suffix${EVAL_SUFFIX:-}}
    for variant in baseline default shared; do
        case "$variant" in
            baseline) [[ $ASIP_SYN_SKIP_BASELINE == 0 ]] || continue ;;
            default) [[ $ASIP_SYN_SKIP_DEFAULT == 0 ]] || continue ;;
            shared) [[ $ASIP_SYN_SKIP_SHARED == 0 && $HLS_TOOL == nailgun && $HLS_NAILGUN_SHARE_RESOURCES == 1 ]] || continue ;;
        esac
        destination=$asip_output/$variant
        if [[ $variant == baseline && -n $ASIP_SYN_BASELINE_USE ]]; then
            destination=$ASIP_SYN_BASELINE_USE
            [[ -f $destination/metrics.csv ]] || { echo "Missing baseline metrics: $destination" >&2; exit 2; }
        else
            rtl=$asip_hls/$variant/rtl
            [[ -f $rtl/files.txt ]] || rtl=$asip_hls/$variant/output
            [[ -f $rtl/files.txt ]] || rtl=$asip_hls/$variant
            ASIP_SYN_TOOL=$ASIP_SYN_TOOL bash "$SCRIPTS_DIR/asip_syn_script.sh" \
                "$destination" "$rtl" "$asip_core" "$asip_pdk" "$asip_clock"
        fi
        COLLECT_ASIP_ARGS+=(--"$variant"-dir "$destination")
        ASIP_VARIANTS+=("$variant")
    done
    if [[ ${#COLLECT_ASIP_ARGS[@]} != 0 ]]; then
        mkdir -p "$asip_output"
        "${ASIP_SYN_PYTHON:-python3}" "$SCRIPTS_DIR/collect_asip_syn_metrics.py" \
            "${COLLECT_ASIP_ARGS[@]}" --expected-tool "$ASIP_SYN_TOOL" \
            --expected-pdk "$asip_pdk" --expected-clock-ns "$asip_clock" --output "$asip_output/metrics.csv"
        preserve_args=()
        [[ -z $ASIP_SYN_BASELINE_USE ]] || preserve_args+=(--baseline-dir "$ASIP_SYN_BASELINE_USE")
        "${ASIP_SYN_PYTHON:-python3}" "$FLOW_SCRIPTS_DIR/asip_syn/preserve.py" \
            "$asip_output" "${ASIP_SYN_REPORT_DIR:-$DIR/asip_syn$backend_suffix$suffix${EVAL_SUFFIX:-}}" \
            "${ASIP_VARIANTS[@]}" "${preserve_args[@]}"
    fi
fi

# FPGA backends share selection and collection; work paths retain backend identity.
if [[ "$FPGA_SYN_ENABLE" == 1 ]]; then
    case "$FPGA_SYN_TOOL" in
        vivado)
            fpga_backend_suffix=""
            fpga_core=$FPGA_SYN_VIVADO_CORE_NAME
            fpga_part=$FPGA_SYN_VIVADO_PART
            fpga_clock=${FPGA_SYN_VIVADO_CLOCK_NS:-$FPGA_SYN_VIVADO_CLK_PERIOD} ;;
        f4pga|symbiflow)
            fpga_backend_suffix=_f4pga
            fpga_core=${FPGA_SYN_F4PGA_CORE_NAME:-$FPGA_SYN_VIVADO_CORE_NAME}
            fpga_part=${FPGA_SYN_F4PGA_PART:-xc7a100tcsg324-1}
            fpga_clock=${FPGA_SYN_F4PGA_CLOCK_NS:-50} ;;
        *) echo "Unsupported FPGA_SYN_TOOL: $FPGA_SYN_TOOL" >&2; exit 2 ;;
    esac
    if [[ $FPGA_SYN_SEARCH_FMAX == 1 ]]; then
        echo 'FPGA Fmax search is not implemented; run explicit period sweeps.' >&2; exit 2
    fi
    hls_mode=docker
    [[ ${USE_HLS_DOCKER:-1} != 0 ]] || hls_mode=local
    suffix=""
    if [[ ${PRELIM:-0} == 1 ]]; then suffix=_prelim
    elif [[ ${FINAL:-0} == 1 ]]; then suffix=_final
    elif [[ ${FILTERED2:-0} == 1 ]]; then suffix=_filtered2
    elif [[ ${FILTERED:-0} == 1 ]]; then suffix=_filtered; fi
    if [[ ${SELECTED:-0} == 1 && ( $suffix == _filtered || $suffix == _filtered2 ) ]]; then suffix+=_selected; fi
    fpga_hls=${FPGA_SYN_HLS_DIR:-$WORK/$hls_mode/hls$suffix}
    fpga_output=${FPGA_SYN_OUTPUT_DIR:-$WORK/$hls_mode/fpga_syn$fpga_backend_suffix$suffix${EVAL_SUFFIX:-}}
    collect_fpga_args=()
    preserve_fpga_args=()
    for variant in baseline default shared; do
        case "$variant" in
            baseline) [[ $FPGA_SYN_SKIP_BASELINE == 0 ]] || continue ;;
            default) [[ $FPGA_SYN_SKIP_DEFAULT == 0 ]] || continue ;;
            shared) [[ $FPGA_SYN_SKIP_SHARED == 0 && $HLS_TOOL == nailgun && $HLS_NAILGUN_SHARE_RESOURCES == 1 ]] || continue ;;
        esac
        destination=$fpga_output/$variant
        if [[ $variant == baseline && -n $FPGA_SYN_BASELINE_USE ]]; then
            destination=$FPGA_SYN_BASELINE_USE
        else
            rtl=$fpga_hls/$variant/rtl
            [[ -f $rtl/files.txt ]] || rtl=$fpga_hls/$variant/output
            [[ -f $rtl/files.txt ]] || rtl=$fpga_hls/$variant
            if [[ ! -f $rtl/files.txt ]]; then
                case "$fpga_core" in VEX_5S) rtl=$rtl/VexRiscv_5s ;; CVA5) rtl=$rtl/CVA5 ;; esac
            fi
            FPGA_SYN_TOOL=$FPGA_SYN_TOOL bash "$SCRIPTS_DIR/fpga_syn_script.sh" \
                "$destination" "$rtl" "$fpga_core" "$fpga_part" "$fpga_clock"
        fi
        collect_fpga_args+=(--"$variant"-dir "$destination")
        preserve_fpga_args+=(--"$variant"-dir "$destination")
    done
    if [[ ${#collect_fpga_args[@]} != 0 ]]; then
        mkdir -p "$fpga_output"
        "${FPGA_SYN_PYTHON:-python3}" "$SCRIPTS_DIR/collect_fpga_syn_metrics.py" \
            "${collect_fpga_args[@]}" --expected-tool "$FPGA_SYN_TOOL" \
            --expected-core "$fpga_core" --expected-part "$fpga_part" --expected-clock-ns "$fpga_clock" --output "$fpga_output/metrics.csv"
        if [[ $fpga_backend_suffix == _f4pga ]]; then
            "${FPGA_SYN_PYTHON:-python3}" "$FLOW_SCRIPTS_DIR/fpga_syn/f4pga/preserve.py" \
                --metrics "$fpga_output/metrics.csv" "${preserve_fpga_args[@]}" \
                --output "${FPGA_SYN_REPORT_DIR:-$DIR/fpga_syn_f4pga$suffix${EVAL_SUFFIX:-}}"
        fi
    fi
fi
