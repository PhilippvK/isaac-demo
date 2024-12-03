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

python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 --label $LABEL-trace2 -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=XIsaacCore -c llvm.install_dir=$WORK/docker/llvm_install -c etiss.arch=rv32imfd_xisaac

python3 -m mlonmcu.cli.main export --run -f -- $RUN2

python3 -m isaac_toolkit.session.create --session $SESS2 $FORCE_ARGS

python3 -m isaac_toolkit.frontend.elf.riscv $RUN2/generic_mlonmcu --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.frontend.linker_map $RUN2/mlif/generic/linker.map --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.frontend.instr_trace.etiss $RUN2/etiss_instrs.log --session $SESS2 --operands $FORCE_ARGS
python3 -m isaac_toolkit.frontend.disass.objdump $RUN2/generic_mlonmcu.dump --session $SESS2 $FORCE_ARGS

python3 -m isaac_toolkit.analysis.static.dwarf --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.llvm_bbs --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.mem_footprint --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.analysis.static.linker_map --session $SESS2 $FORCE_ARGS
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
