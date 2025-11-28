#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

ISAAC_LOG_LEVEL=${ISAAC_LOG_LEVEL:-info}
ISAAC_PROGRESS=${ISAAC_PROGRESS:-0}
ISAAC_TOOLKIT_CONFIG_YAML=${ISAAC_TOOLKIT_CONFIG_YAML:-""}
TARGET=${TARGET:-etiss}
FORCE_ARGS=""

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

PROGRESS_ARGS=""
if [[ "$ISAAC_PROGRESS" == "1" ]]
then
    PROGRESS_ARGS="--progress"
fi

LOGGING_ARGS="--log $ISAAC_LOG_LEVEL"

python3 -m isaac_toolkit.session.create --session $SESS $FORCE_ARGS $LOGGING_ARGS

if [[ "$ISAAC_TOOLKIT_CONFIG_YAML" != "" ]]
then
    python3 -m isaac_toolkit.frontend.cfg.yaml $ISAAC_TOOLKIT_CONFIG_YAML --session $SESS $FORCE_ARGS $LOGGING_ARGS
fi

python3 -m isaac_toolkit.flow.demo.stage.load $RUN --session $SESS $FORCE_ARGS $LOGGING_ARGS $PROGRESS_ARGS

# Old:
# python3 -m isaac_toolkit.frontend.elf.riscv $RUN/generic_mlonmcu --session $SESS $FORCE_ARGS $LOGGING_ARGS
# python3 -m isaac_toolkit.frontend.linker_map $RUN/mlif/generic/linker.map --session $SESS $FORCE_ARGS $LOGGING_ARGS
# python3 -m isaac_toolkit.frontend.instr_trace.etiss $RUN/etiss_instrs.log --session $SESS --operands $FORCE_ARGS $LOGGING_ARGS $PROGRESS_ARGS
# python3 -m isaac_toolkit.frontend.disass.objdump $RUN/generic_mlonmcu.dump --session $SESS $FORCE_ARGS $LOGGING_ARGS
# python3 -m isaac_toolkit.frontend.compile_commands.json $RUN/mlif/compile_commands.json --session $SESS $FORCE_ARGS $LOGGING_ARGS
# NEW: python3 -m isaac_toolkit.frontend.mlonmcu.exported_run $RUN --session $SESS $FORCE_ARGS
# NEW: python3 -m isaac_toolkit.frontend.mlonmcu.exported_session $? --session $SESS $FORCE_ARGS
