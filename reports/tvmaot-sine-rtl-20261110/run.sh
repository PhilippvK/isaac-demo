#!/usr/bin/env bash
set -euo pipefail
# Source scripts/env.sh and configure TVM/LLVM/GNU paths in MLONMCU_HOME first.
# Choose CORE=vex (default) or CORE=cva5; set the matching generated RTL directory.
: "${RTL_DIR:?Set RTL_DIR to the generated core directory or its parent}"
: "${ISAAC_ROOT:=$PWD}"
args=()
if [[ ${CORE:-vex} == cva5 ]]; then args+=(-c "nailgun.verilator=${RTL_SIM_VERILATOR:-verilator}"); fi
python -m mlonmcu.cli.main flow run sine_model --backend tvmaot --target nailgun \
 -f validate_new --post validate_outputs \
 -c 'validate_outputs.validate_metrics=allclose(atol=1e-06,rtol=1e-06)' \
 -c gen_data.number=4 -c mlif.template_version=v2 -c mlif.toolchain=llvm \
 -c mlif.global_isel=1 -c mlif.unroll_loops=0 -c run.export_optional=1 \
 -c "nailgun.runner=$ISAAC_ROOT/scripts/rtl_sim/run.py" \
 -c "nailgun.core=${CORE:-vex}" -c "nailgun.rtl_dir=$RTL_DIR" "${args[@]}"
