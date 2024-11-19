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

# cp $WORK/docker/hls/output/ISAX_XIsaac.sv $WORK/docker/hls/output/VexRiscv_4s
# docker run -it --rm -v /work/git/tuda/isax-tools-integration/:/isax-tools -v $(pwd):$(pwd) isaac-quickstart-hls:latest "date && cd /isax-tools && volare enable --pdk sky130 0fe599b2afb6708d281543108caf8310912f54af && python3 dse.py $WORK/docker/hls/output/VexRiscv_4s/ $WORK/docker/hls/syn_dir prj LEGACY 40 20 top clk"
PERIOD_NS=$(cat out/nettle-aes/20241111T162222/work/docker/hls/syn_dir/best.csv | tail -1 | cut -d, -f2)
FP_UTIL=$(cat out/nettle-aes/20241111T162222/work/docker/hls/syn_dir/best.csv | tail -1 | cut -d, -f3)
echo "PERIOD_NS=${PERIOD_NS}ns FP_UTIL=${FP_UTIL}%"
PRJ="prj_LEGACY_${PERIOD_NS}ns_${FP_UTIL}%"
python3 collect_syn_metrics.py $WORK/docker/hls/syn_dir/$PRJ --output $WORK/docker/hls/syn_metrics.csv --print --min --rename
