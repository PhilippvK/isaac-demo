#!/usr/bin/env bash
# Build the simulator version validated with the Nailgun core adapters.
set -euo pipefail
prefix=$(realpath -m "${1:?Usage: install_verilator.sh INSTALL_PREFIX}")
source_dir=${prefix}-src
revision=51cdf52d0f3a3e59b51fd87762646a851e9f4aff
if [[ ! -d $source_dir ]]; then
    git clone --depth 1 --branch v5.040 https://github.com/verilator/verilator.git "$source_dir"
fi
[[ $(git -C "$source_dir" rev-parse HEAD) == "$revision" ]] || { echo "Unexpected Verilator source revision" >&2; exit 2; }
cd "$source_dir"
autoconf
./configure --prefix="$prefix"
make -C src -j"${RTL_SIM_JOBS:-4}" opt
# Install only after a successful build; make install also expects the debug binary.
make -C src -j"${RTL_SIM_JOBS:-4}" dbg
make install
"$prefix/bin/verilator" --version
