#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$ROOT"
: "${LM_LICENSE_FILE:?Set the Synopsys license-server environment}"
python3 scripts/asip_syn/evaluate.py \
  --rtl reports/vex-5s-hls-20261107/hls-run \
  --output "${OUT:-$ROOT/reports/asip-synthesis-20261112/reproduction}" \
  --libraries install/asip-libs --clock-ns 10 --jobs 4 --parallel 2 \
  --dc-shell "${ASIP_SYN_DC_SHELL:-/nfs/tools/synopsys/syn/W-2024.09-SP2/bin/dc_shell}" \
  --lc-shell "${ASIP_SYN_LC_SHELL:-/nfs/tools/synopsys/lc/X-2025.06-SP3/bin/lc_shell}"
