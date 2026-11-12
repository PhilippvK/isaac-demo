#!/usr/bin/env bash
# Validation-only controller overlay: OpenLane 2.3.10 on LibreLane's pinned tools.
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
exec docker run --rm --network none --user "$(id -u):$(id -g)" -e HOME=/tmp \
  --mount "type=bind,source=$PWD,target=$PWD" \
  --mount "type=bind,source=$ROOT/install/asip-pdks,target=$ROOT/install/asip-pdks,readonly" \
  --mount "type=bind,source=$ROOT/install/asip-tools/openlane2,target=/openlane2,readonly" \
  -e PYTHONPATH=/openlane2 -w "$PWD" --entrypoint python3 \
  ghcr.io/librelane/librelane@sha256:4bc9042ba177f73f275b5b39e7d372a07d3f4043f548a0ba7f640097b7205051 \
  -m openlane "$@"
