#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE
STAGE=32  # 32 -> post finalizeisel/expandpseudos
# STAGE=64  # 64 -> pre/post regalloc
# STAGE=128  # 64 -> post machine-sink
# STAGE=256  # 64 -> pre virtregrewriter

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

# Create workdir
mkdir -p $WORK

PURGE_DB=${FORCE_PURGE_DB:-0}

# Make choices (func_name + bb_name)
if [[ "$PURGE_DB" == "1" ]]
then
    python3 isaac-toolkit/isaac_toolkit/utils/memgraph/purge_db.py --sess $SESS
fi
python3 -m isaac_toolkit.generate.cdfg.memgraph --sess $SESS --label $LABEL --stage $STAGE $FORCE_ARGS
python3 -m isaac_toolkit.backend.memgraph.annotate_bb_weights --session $SESS --label $LABEL $FORCE_ARGS
# python3 -m isaac_toolkit.frontend.memgraph.llvm_mir_cdfg --session $SESS --label $LABEL $FORCE_ARGS
