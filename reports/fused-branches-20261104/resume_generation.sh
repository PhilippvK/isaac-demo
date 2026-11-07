#!/bin/bash
set -eo pipefail
source scripts/env.sh
export SEAL5_HOME=$PWD/llvm-project-22
python -m seal5.cli.main --dir "$SEAL5_HOME" transform --only write_cdsl_full
python -m seal5.cli.main --dir "$SEAL5_HOME" generate --skip pattern_gen
python -m seal5.cli.main --dir "$SEAL5_HOME" patch -s 1 2
SEAL5_START_AT=build-tools bash reports/fused-branches-20261104/retarget.sh
