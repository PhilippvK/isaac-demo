#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE
STAGE=32  # 32 -> post finalizeisel/expandpseudos

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

python3 -m isaac_toolkit.session.create --session $SESS $FORCE_ARGS

python3 -m isaac_toolkit.frontend.elf.riscv $RUN/generic_mlonmcu --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.frontend.linker_map $RUN/mlif/generic/linker.map --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.frontend.instr_trace.etiss $RUN/etiss_instrs.log --session $SESS --operands $FORCE_ARGS
python3 -m isaac_toolkit.frontend.disass.objdump $RUN/generic_mlonmcu.dump --session $SESS $FORCE_ARGS

python3 -m isaac_toolkit.frontend.memgraph.llvm_mir_cdfg --session $SESS --label $LABEL $FORCE_ARGS

python3 -m isaac_toolkit.analysis.static.dwarf --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.llvm_bbs --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.mem_footprint --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.linker_map --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.instr_operands --session $SESS --imm-only $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.histogram.opcode --sess $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.histogram.instr --sess $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.histogram.disass_instr --sess $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.histogram.disass_opcode --sess $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.basic_blocks --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.map_llvm_bbs_new --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.track_used_functions --session $SESS $FORCE_ARGS
python3 -m isaac_toolkit.backend.memgraph.annotate_bb_weights --session $SESS --label $LABEL $FORCE_ARGS


python3 -m isaac_toolkit.visualize.pie.runtime --sess $SESS --legend $FORCE_ARGS
python3 -m isaac_toolkit.visualize.pie.mem_footprint --sess $SESS --legend $FORCE_ARGS
python3 -m isaac_toolkit.visualize.pie.disass_counts --sess $SESS --legend $FORCE_ARGS
