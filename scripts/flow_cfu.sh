#!/bin/bash
set -euo pipefail

DIR=$(readlink -f "$1")
: "${CFU_PLAYGROUND_DIR:?Set CFU_PLAYGROUND_DIR to the pinned CFU-Playground checkout}"
if [[ $(basename "$(dirname "$(dirname "$DIR")")") != embench_iot ]]; then
    echo "The initial CFU benchmark runner supports embench_iot runs" >&2
    exit 1
fi
SELECTION=combined
if [[ ${FILTERED:-0} == 1 && ${SELECTED:-0} == 1 ]]; then
    SELECTION=filtered_selected
elif [[ ${FILTERED:-0} == 1 || ${SELECTED:-0} == 1 ]]; then
    echo "CFU evaluation currently supports combined or filtered-selected candidates" >&2
    exit 1
fi
BENCH=$(basename "$(dirname "$DIR")")
BENCH_ROOT=${CFU_EMBENCH_DIR:-$PWD/install/mlonmcu/deps/src/benchmarks/embench}
TRACE_ARGS=()
if [[ ${CFU_INSTRUCTION_TRACE:-0} == 1 ]]; then
    TRACE_ARGS+=(--instruction-trace)
fi
RUNNER_ARGS=(--runner "${CFU_RUNNER:-verilator}")
if [[ ${CFU_RUNNER:-verilator} == renode ]]; then
    : "${CFU_RENODE_EXECUTABLE:?Set CFU_RENODE_EXECUTABLE}"
    : "${CFU_RENODE_VIL:?Set CFU_RENODE_VIL to the prepared Renode integration sources}"
    RUNNER_ARGS+=(--renode "$CFU_RENODE_EXECUTABLE" --vil-dir "$CFU_RENODE_VIL")
fi
if [[ ${CFU_RUNNER:-verilator} == fpga ]]; then
    : "${CFU_VIVADO:?Set CFU_VIVADO to the Vivado executable}"
    RUNNER_ARGS+=(--vivado "$CFU_VIVADO")
    if [[ ${CFU_SYNTHESIZE_ONLY:-0} == 1 ]]; then
        RUNNER_ARGS+=(--synthesize-only)
    else
        : "${CFU_BOARD_SERIAL:?Set CFU_BOARD_SERIAL}"
        : "${CFU_SERIAL_PORT:?Set CFU_SERIAL_PORT}"
        RUNNER_ARGS+=(--board-serial "$CFU_BOARD_SERIAL" --serial-port "$CFU_SERIAL_PORT")
    fi
fi
python3 scripts/cfu_evaluate.py --run-dir "$DIR" --root "$CFU_PLAYGROUND_DIR" \
    --benchmark-dir "$BENCH_ROOT/src/$BENCH" --support-dir "$BENCH_ROOT/support" \
    --gnu "${ISAAC_GNU_INSTALL_DIR:-$PWD/install/gnu_cfu}" --selection "$SELECTION" \
    --timeout "${CFU_SIM_TIMEOUT:-600}" "${TRACE_ARGS[@]}" "${RUNNER_ARGS[@]}"
