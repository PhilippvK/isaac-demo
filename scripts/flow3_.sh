#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

STAGE="default"
STAGE_DIR=$DIR/$STAGE

RUN=$STAGE_DIR/run
SESS=$STAGE_DIR/sess
WORK=$STAGE_DIR/work

# Create workdir
mkdir -p $WORK

CDFG_STAGE=${CDFG_STAGE:-32}
# PURGE_DB=${FORCE_PURGE_DB:-0}
PURGE_DB=0  # TODO: comment in

# Make choices (func_name + bb_name)
if [[ "$PURGE_DB" == "1" ]]
then
    python3 isaac-toolkit/isaac_toolkit/utils/memgraph/purge_db.py --sess $SESS
fi
python3 -m isaac_toolkit.generate.cdfg.memgraph --sess $SESS --label $LABEL --stage $CDFG_STAGE $FORCE_ARGS
python3 -m isaac_toolkit.backend.memgraph.annotate_bb_weights --session $SESS --label $LABEL $FORCE_ARGS
# python3 -m isaac_toolkit.frontend.memgraph.llvm_mir_cdfg --session $SESS --label $LABEL $FORCE_ARGS
