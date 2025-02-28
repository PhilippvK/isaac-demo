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

python3 -m isaac_toolkit.generate.ise.query_candidates_from_db --sess $SESS --workdir $WORK --label $LABEL --stage $STAGE

python3 scripts/names_helper.py $WORK/combined_index.yml --output $WORK/names.csv

python3 scripts/combine_pdfs.py $WORK/combined_index.yml -o $WORK/all_io_subs.pdf
