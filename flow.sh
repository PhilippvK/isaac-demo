#!/bin/bash

set -e

BENCH=${1:-coremark}
DATE=$(date +%Y%m%dT%H%M%S)
# DATE=20241111T020822
LABEL=isaac-demo-$BENCH-$DATE
STAGE=32  # 32 -> post finalizeisel/expandpseudos

OUT_DIR_BASE=$(pwd)/out
OUT_DIR=out/$BENCH/$DATE
mkdir -p $OUT_DIR

RUN=$OUT_DIR/run
SESS=$OUT_DIR/sess
WORK=$OUT_DIR/work

python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-baseline

python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm -f memgraph_llvm_cdfg -c memgraph_llvm_cdfg.session=$LABEL -c memgraph_llvm_cdfg.stage=$STAGE -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 -c mlif.num_threads=1 --label $LABEL-trace

python3 -m mlonmcu.cli.main export --run -- $RUN

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
python3 -m isaac_toolkit.frontend.memgraph.llvm_mir_cdfg --session $SESS --label $LABEL $FORCE_ARGS
