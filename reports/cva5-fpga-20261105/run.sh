#!/bin/bash
set -eo pipefail
ROOT=$(cd -- "$(dirname -- "$0")" && pwd)
export ROOT_PATH="$ROOT"
export CONSTRAINTS_FILE="$ROOT/../../scripts/fpga_syn/constraints/CVA5/cva5_top.xdc"
export TOPLEVEL=cva5_top PART=xc7a200tffv1156-1 CLOCK_PERIOD=50.0
for variant in "$@"; do
  cd "$ROOT/$variant"
  mkdir -p reports
  export FILES_TXT="$PWD/files.txt"
  /nfs/tools/xilinx/Vivado/2024.1/bin/vivado -mode batch -source "$ROOT/synthesize.tcl" > vivado.stdout.log 2>&1
done
