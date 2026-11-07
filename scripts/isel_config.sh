#!/bin/bash
# Shared selector policy for discovery and evaluation scripts.
isaac_select_isel() {
    local experiment_dir=$1 phase=$2 requested=${ISAAC_ISEL:-} saved
    if [[ -n "$requested" ]]; then
        case "$requested" in
            dag|iseldag|selectiondag) requested=0 ;;
            gisel|globalisel) requested=1 ;;
            *) echo "ISAAC_ISEL must be dag or gisel" >&2; return 2 ;;
        esac
        if [[ -n "${GLOBAL_ISEL:-}" && "$GLOBAL_ISEL" != "$requested" ]]; then
            echo "ISAAC_ISEL conflicts with GLOBAL_ISEL" >&2; return 2
        fi
    elif [[ -n "${GLOBAL_ISEL:-}" ]]; then
        requested=$GLOBAL_ISEL
    elif [[ "$phase" != trace && -f "$experiment_dir/run/instruction-selector.json" ]]; then
        saved=$(python3 -c 'import json,sys; print(int(json.load(open(sys.argv[1]))["global_isel"]))' "$experiment_dir/run/instruction-selector.json") || return
        requested=$saved
    else
        requested=0
    fi
    case "$requested" in
        0) ISAAC_SELECTED_ISEL=dag ;;
        1) ISAAC_SELECTED_ISEL=gisel ;;
        *) echo "GLOBAL_ISEL must be 0 or 1" >&2; return 2 ;;
    esac
    export GLOBAL_ISEL=$requested ISAAC_SELECTED_ISEL
    EVAL_SUFFIX=""
    if [[ -n "${ISEL_VARIANT:-}" ]]; then
        case "$ISEL_VARIANT" in dag|gisel) EVAL_SUFFIX="_isel_$ISEL_VARIANT" ;;
            *) echo "ISEL_VARIANT must be dag or gisel" >&2; return 2 ;;
        esac
    fi
}

isaac_record_isel() {
    local output_dir=$1
    mkdir -p "$output_dir"
    python3 - "$output_dir/instruction-selector.json" "$GLOBAL_ISEL" <<'PY'
import json, pathlib, sys
path = pathlib.Path(sys.argv[1])
value = bool(int(sys.argv[2]))
path.write_text(json.dumps({'selector': 'gisel' if value else 'dag',
                            'global_isel': value}, indent=2) + '\n')
PY
}
