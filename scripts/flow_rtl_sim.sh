#!/usr/bin/env bash
# Execute the extraction benchmark on generated Nailgun RTL, without FPGA tools.
set -euo pipefail
DIR=$(realpath "${1:?Usage: flow_rtl_sim.sh EXPERIMENT_DIR}")
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
source "$ROOT/scripts/isel_config.sh"
isaac_select_isel "$DIR" eval
suffix=""
if [[ ${FINAL:-0} == 1 ]]; then suffix=_final
elif [[ ${PRELIM:-0} == 1 ]]; then suffix=_prelim
elif [[ ${FILTERED2:-0} == 1 ]]; then suffix=_filtered2
elif [[ ${FILTERED:-0} == 1 ]]; then suffix=_filtered
fi
if [[ ${SELECTED:-0} == 1 && ( $suffix == _filtered || $suffix == _filtered2 ) ]]; then suffix+=_selected; fi
core=${RTL_SIM_CORE:-${HLS_NAILGUN_CORE_NAME:-${RTL_TARGET:-CVA5}}}
case "$core" in CVA5|cva5) core=cva5 ;; VEX_5S|vex_5s|VexRiscv_5s|vex) core=vex ;; *) echo "Unsupported RTL core: $core" >&2; exit 2 ;; esac
mode=local; [[ ${USE_HLS_DOCKER:-0} == 1 ]] && mode=docker
hls=${RTL_SIM_HLS_DIR:-$DIR/work/$mode/hls$suffix}
commands=${RTL_SIM_COMPILE_COMMANDS:-$DIR/run/compile_commands.json}
dest=${RTL_SIM_OUTPUT_DIR:-$DIR/work/rtl_sim$suffix$EVAL_SUFFIX}
seal_mode=local
if [[ ${USE_SEAL5_SERVICE:-0} == 1 ]]; then seal_mode=service
elif [[ ${USE_SEAL5_DOCKER:-0} == 1 ]]; then seal_mode=docker
fi
seal_root=$DIR/work/$seal_mode
if [[ $seal_mode == local && ${LLVM_MAJOR:-19} != 19 ]]; then seal_root+=/llvm${LLVM_MAJOR}; fi
compiler=${RTL_SIM_COMPILER:-$seal_root/seal5$suffix/llvm_install/bin/clang}
gnu=${RTL_SIM_GNU:-${ISAAC_GNU_INSTALL_DIR:-$ROOT/install/gnu_cfu}}
mkdir -p "$dest"
read -ra variants <<< "${RTL_SIM_VARIANTS:-baseline default}"
# Clear success markers before rebuilding, including on a failed rerun.
python3 - "$dest" "${variants[@]}" <<'PYINIT'
import json, pathlib, sys
root=pathlib.Path(sys.argv[1])
(root/'summary.json').write_text(json.dumps({'passed':False,'status':'running'})+'\n')
for name in sys.argv[2:]:
    if name not in ('baseline','default','custom','shared'): raise ValueError('Unknown RTL variant: '+name)
    dest=root/name;dest.mkdir(parents=True,exist_ok=True)
    (dest/'execution.json').write_text(json.dumps({'passed':False,'status':'not executed'})+'\n')
PYINIT
finish_rtl_sim() {
    local stage_status=$? report_status=0
    python3 "$ROOT/scripts/rtl_sim/summarize.py" "$dest" --variants "${variants[@]}" || report_status=$?
    python3 "$ROOT/scripts/rtl_sim/preserve.py" "$dest" "${RTL_SIM_REPORT_DIR:-$DIR/rtl_sim$suffix$EVAL_SUFFIX}" "${variants[@]}" || report_status=$?
    if [[ $stage_status != 0 ]]; then exit "$stage_status"; fi
    exit "$report_status"
}
trap finish_rtl_sim EXIT
# Explicit stage invocation always runs. RTL_SIM_ENABLE controls automatic insertion.
for variant in "${variants[@]}"; do
    case "$variant" in baseline|default|custom|shared) ;; *) echo "Unknown RTL variant: $variant" >&2; exit 2 ;; esac
    rtl=$hls/$variant/rtl
    [[ -f $rtl/files.txt ]] || rtl=$hls/$variant/output
    [[ -n ${RTL_SIM_RTL_DIR:-} ]] && rtl=$RTL_SIM_RTL_DIR
    args=(--isel "$ISAAC_SELECTED_ISEL")
    if [[ -x $compiler ]]; then args+=(--compiler "$compiler"); fi
    if [[ -n ${ARCH:-} ]]; then args+=(--arch "${RTL_SIM_BASE_ARCH:-$ARCH}" --abi "${ABI:-ilp32}"); fi
    if [[ $variant != baseline ]]; then
        [[ -x $compiler ]] || { echo "Missing retargeted compiler: $compiler" >&2; exit 2; }
        : "${ARCH:?Set ARCH to the base architecture used for extraction}"
        args+=(--compiler "$compiler" --arch "${RTL_SIM_ARCH:-${ARCH}_xisaac}" --abi "${ABI:-ilp32}")
    fi
    if [[ ${RTL_SIM_BUILD_MODE:-mlonmcu} == replay ]]; then
        python3 "$ROOT/scripts/rtl_sim/build_benchmark.py" "$commands" "$dest/$variant/firmware" --gnu "$gnu" "${args[@]}" > "$dest/$variant-build.log" 2>&1
    elif [[ ${RTL_SIM_BUILD_MODE:-mlonmcu} == mlonmcu ]]; then
        build_compiler=$compiler
        [[ -x $build_compiler ]] || build_compiler=${RTL_SIM_BASE_COMPILER:-${LLVM_INSTALL_DIR:-$ROOT/install/llvm}/bin/clang}
        build_arch=${RTL_SIM_BASE_ARCH:-${ARCH:-rv32im_zicsr_zifencei}}
        [[ $variant == baseline ]] || build_arch=${RTL_SIM_ARCH:-${ARCH}_xisaac}
        python3 "$ROOT/scripts/rtl_sim/build_mlonmcu.py" "${RTL_SIM_BENCHMARK:-$(basename "$(dirname "$DIR")")}" "$dest/$variant/firmware" \
            --compiler "$build_compiler" --gnu "$gnu" --arch "$build_arch" --abi "${ABI:-ilp32}" --isel "$ISAAC_SELECTED_ISEL" \
            --backend "${BACKEND:-none}" --optimize "${OPTIMIZE:-3}" --unroll "${UNROLL:-auto}" --extra-args="${RTL_SIM_MLONMCU_ARGS:-}" \
            --run --core "$core" --rtl "$rtl" --verilator "${RTL_SIM_VERILATOR:-verilator}" \
            --max-cycles "${RTL_SIM_MAX_CYCLES:-100000000}" --timeout "${RTL_SIM_TIMEOUT:-600}" \
            --jobs "${RTL_SIM_JOBS:-4}" --data-wait "${RTL_SIM_DATA_WAIT:-0}" \
            --ram-size "${RTL_SIM_RAM_SIZE:-262144}" --stack-size "${RTL_SIM_STACK_SIZE:-8192}" \
            --heap-size "${RTL_SIM_HEAP_SIZE:-4096}" > "$dest/$variant-build.log" 2>&1
    else
        echo "Unknown RTL_SIM_BUILD_MODE: $RTL_SIM_BUILD_MODE" >&2; exit 2
    fi
    isaac_record_isel "$dest/$variant"
    if [[ ${RTL_SIM_BUILD_MODE:-mlonmcu} == replay ]]; then
        python3 "$ROOT/scripts/rtl_sim/run.py" --core "$core" --rtl "$rtl" \
            --firmware "$dest/$variant/firmware/benchmark.bin" --output "$dest/$variant" \
            --verilator "${RTL_SIM_VERILATOR:-verilator}" --max-cycles "${RTL_SIM_MAX_CYCLES:-100000000}" \
            --ram-size "${RTL_SIM_RAM_SIZE:-262144}" --data-wait "${RTL_SIM_DATA_WAIT:-0}" --timeout "${RTL_SIM_TIMEOUT:-600}" --jobs "${RTL_SIM_JOBS:-4}"
    fi
done
