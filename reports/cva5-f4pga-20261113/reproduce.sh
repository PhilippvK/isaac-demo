#!/usr/bin/env bash
set -euo pipefail
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
DEST=${1:-$ROOT/work/cva5-f4pga-reproduction}
RUNTIME_ENV=${FPGA_SYN_F4PGA_ENV_SCRIPT:?Set the installed F4PGA runtime environment script}
SV2V=${FPGA_SYN_F4PGA_SV2V:-sv2v}
PYTHON_COMMAND=${FPGA_SYN_PYTHON:-python3}
mkdir -p "$DEST/input"
tar -xzf "$HERE/rtl-inputs.tar.gz" -C "$DEST/input"
for variant in baseline crc32; do
    "$PYTHON_COMMAND" "$ROOT/scripts/fpga_syn/f4pga/run.py" \
        "$DEST/$variant" "$DEST/input/$variant/CVA5" --core CVA5 \
        --env-script "$RUNTIME_ENV" --sv2v "$SV2V" \
        --firmware "$HERE/firmware/$variant.bin" --timeout 7200
done
