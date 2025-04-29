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

FORCE_ARGS=""

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

python3 -m isaac_toolkit.analysis.static.dwarf --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.llvm_bbs --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.mem_footprint --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.linker_map --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.trunc_trace --session $SESS --start-func mlonmcu_run $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.trunc_trace --session $SESS --end-func stop_bench $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.instr_operands --session $SESS --imm-only $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.histogram.opcode --sess $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.histogram.opcode_per_llvm_bb --sess $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.histogram.instr --sess $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.histogram.disass_instr --sess $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.histogram.disass_opcode --sess $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.basic_blocks --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.map_llvm_bbs_new --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.track_used_functions --session $SESS $FORCE_ARGS
