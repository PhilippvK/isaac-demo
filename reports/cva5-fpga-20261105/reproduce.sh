#!/bin/bash
set -eo pipefail
ROOT=$(cd -- "$(dirname -- "$0")" && pwd)
variants=(baseline crc32-scaiev2-final memory-cva5-final branches-fixed store-probes)
bash "$ROOT/run.sh" "${variants[@]}"
for variant in "${variants[@]}"; do
  cd "$ROOT/$variant"
  /nfs/tools/xilinx/Vivado/2024.1/bin/vivado -mode batch -log implementation.log -journal implementation.jou -source "$ROOT/implement.tcl" > implementation.stdout.log 2>&1
done
python3 "$ROOT/summarize.py"
