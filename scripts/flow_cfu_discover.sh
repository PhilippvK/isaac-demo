#!/bin/bash
set -euo pipefail
DIR=$(readlink -f "$1")
PHASE=${2:?Specify bench or trace}
: "${CFU_PLAYGROUND_DIR:?Set CFU_PLAYGROUND_DIR}"
if [[ $(basename "$(dirname "$(dirname "$DIR")")") != embench_iot ]]; then
    echo "CFU discovery currently supports embench_iot" >&2
    exit 1
fi
BENCH=$(basename "$(dirname "$DIR")")
BENCH_ROOT=${CFU_EMBENCH_DIR:-$PWD/install/mlonmcu/deps/src/benchmarks/embench}
TRACE_ARGS=()
if [[ $PHASE == trace ]]; then
    OUTPUT=$DIR/run
    TRACE_ARGS+=(--trace)
elif [[ $PHASE == bench ]]; then
    OUTPUT=$DIR/run_cfu_bench
else
    echo "Unsupported discovery phase: $PHASE" >&2
    exit 1
fi
python3 scripts/cfu_discover.py --root "$CFU_PLAYGROUND_DIR" \
    --compiler "${CFU_DISCOVERY_COMPILER:-$LLVM_INSTALL_DIR/bin/clang}" \
    --gnu "${ISAAC_GNU_INSTALL_DIR:-$PWD/install/gnu_cfu}" \
    --benchmark-dir "$BENCH_ROOT/src/$BENCH" --support-dir "$BENCH_ROOT/support" \
    --output "$OUTPUT" --timeout "${CFU_SIM_TIMEOUT:-600}" "${TRACE_ARGS[@]}"
