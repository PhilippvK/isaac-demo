#!/usr/bin/env bash
# Explicit hardware execution stage; normal RTL stages never program the board.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
export RTL_SIM_EXECUTION=fpga
export RTL_SIM_TIMEOUT=${FPGA_RUN_TIMEOUT:-1800}
exec bash "$ROOT/scripts/flow_rtl_sim.sh" "$@"
