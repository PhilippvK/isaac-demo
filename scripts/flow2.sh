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

TARGET=${TARGET:-etiss}
FORCE_ARGS=""

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

python3 -m isaac_toolkit.session.create --session $SESS $FORCE_ARGS

python3 -m isaac_toolkit.frontend.elf.riscv $RUN/generic_mlonmcu --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.frontend.linker_map $RUN/mlif/generic/linker.map --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.frontend.instr_trace.etiss $RUN/${TARGET}_instrs.log --session $SESS --operands $FORCE_ARGS
python3 -m isaac_toolkit.frontend.disass.objdump $RUN/generic_mlonmcu.dump --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.frontend.compile_commands.json $RUN/mlif/compile_commands.json --session $SESS $FORCE_ARGS
# NEW: python3 -m isaac_toolkit.frontend.mlonmcu.exported_run $RUN --session $SESS $FORCE_ARGS
# NEW: python3 -m isaac_toolkit.frontend.mlonmcu.exported_session $? --session $SESS $FORCE_ARGS
