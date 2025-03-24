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

# echo "$WORK/docker/llvm_install"
# sleep 10

RUN2=${RUN}_new
SESS2=${SESS}_new

echo "!=$RUN2/generic_mlonmcu"

FORCE_ARGS=""

FORCE=1
if [[ "$FORCE" == "1" ]]
then
    FORCE_ARGS="--force"
fi

python3 -m isaac_toolkit.session.create --session $SESS2 $FORCE_ARGS

python3 -m isaac_toolkit.frontend.elf.riscv $RUN2/generic_mlonmcu --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.frontend.linker_map $RUN2/mlif/generic/linker.map --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.frontend.instr_trace.etiss $RUN2/etiss_instrs.log --session $SESS2 --operands $FORCE_ARGS
python3 -m isaac_toolkit.frontend.disass.objdump $RUN2/generic_mlonmcu.dump --session $SESS2 $FORCE_ARGS

python3 -m isaac_toolkit.analysis.static.dwarf --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.llvm_bbs --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.mem_footprint --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.linker_map --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.trunc_trace --session $SESS2 --start-func mlonmcu_run $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.trunc_trace --session $SESS2 --end-func stop_bench $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.instr_operands --session $SESS2 --imm-only $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.histogram.opcode --sess $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.histogram.instr --sess $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.histogram.disass_instr --sess $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.histogram.disass_opcode --sess $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.basic_blocks --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.map_llvm_bbs_new --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.dynamic.trace.track_used_functions --session $SESS2 $FORCE_ARGS

python3 -m isaac_toolkit.visualize.pie.runtime --sess $SESS2 --legend $FORCE_ARGS
python3 -m isaac_toolkit.visualize.pie.mem_footprint --sess $SESS2 --legend $FORCE_ARGS
python3 -m isaac_toolkit.visualize.pie.disass_counts --sess $SESS2 --legend $FORCE_ARGS

# NEW:
python3 -m isaac_toolkit.eval.ise.util --sess $SESS2 --names-csv $WORK/names.csv $FORCE_ARGS
python3 -m isaac_toolkit.eval.ise.compare_bench --sess $SESS --report $REPORT_COMPARE --mem-report $REPORT_COMPARE_MEM $FORCE_ARGS
python3 -m isaac_toolkit.eval.ise.compare_sess --sess $SESS2 --with $SESS $FORCE_ARGS
# python3 -m isaac_toolkit.eval.ise.score.total --sess $SESS2
# python3 -m isaac_toolkit.eval.ise.summary --sess $SESS2  # -> combine all data into single table/plot/pdf?
