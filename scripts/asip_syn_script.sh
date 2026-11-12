#!/usr/bin/env bash
# Standard-cell synthesis, with explicit tool/library settings.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
output=${1:?Usage: asip_syn_script.sh OUTPUT RTL [CORE PDK CLOCK_NS CONSTRAINTS]}
rtl=${2:?Missing RTL directory}
core=${3:-VEX_5S}
pdk=${4:-nangate45}
case "$pdk" in
  NangateOpenCellLibrary|nangate45) pdk=nangate45; library_name=NangateOpenCellLibrary_typical.db ;;
  sky130|sky130hd) pdk=sky130hd; library_name=sky130_fd_sc_hd__tt_025C_1v80.db ;;
  *) echo "Unsupported synthesis PDK: $pdk" >&2; exit 2 ;;
esac
library=${ASIP_SYN_LIBRARY:-${TECHLIB_PATH:-$ROOT/install/asip-libs/$pdk}/$library_name}
if [[ ! -f $library && $pdk == nangate45 && -n ${TECHLIB_PATH:-} ]]; then
  library=$TECHLIB_PATH/NangateOpenCellLibrary_typical_ccs_scan.db
fi
if [[ ! -f $library ]]; then
  echo "Missing library: $library; set ASIP_SYN_LIBRARY to a compiled .db" >&2
  exit 2
fi
args=(--rtl "$rtl" --output "$output" --core "$core" --pdk "$pdk"
      --library "$library" --clock-ns "${5:-10}" --jobs "${ASIP_SYN_JOBS:-8}"
      --timeout "${ASIP_SYN_TIMEOUT:-3600}")
# Historical flow_syn.sh passes a destination path that has never been created.
# Use technology-aware default constraints unless a real SDC is supplied.
if [[ -n ${6:-} ]]; then
  if [[ -f $6 ]]; then
    args+=(--constraints "$6")
  elif [[ $(realpath -m -- "$6") != "$(realpath -m -- "$output/constraints.sdc")" ]]; then
    echo "Missing constraints file: $6" >&2; exit 2
  fi
fi
exec "${ASIP_SYN_PYTHON:-python3}" "$ROOT/scripts/asip_syn/run.py" "${args[@]}"
