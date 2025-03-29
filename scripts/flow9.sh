#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))
LABEL=isaac-demo-$BENCH-$DATE

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

# TODO: expose
# START_CLK_NS=40
START_CLK_NS=25
START_UTIL=40
# CORE_NAME=VexRiscv_4s
CORE_NAME=VexRiscv_5s

# TODO: measure how long it takes

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

cp $WORK/docker/hls/output/ISAX_XIsaac.sv $WORK/docker/hls/output/$CORE_NAME
docker run -it --rm -v /work/git/tuda/isax-tools-integration/:/isax-tools -v $(pwd):$(pwd) isaac-quickstart-hls:latest "date && cd /isax-tools && volare enable --pdk sky130 0fe599b2afb6708d281543108caf8310912f54af && python3 dse.py $WORK/docker/hls/output/$CORE_NAME/ $WORK/docker/hls/syn_dir prj LEGACY $START_CLK_NS $START_UTIL top clk"
PERIOD_NS=$(cat $WORK/docker/hls/syn_dir/best.csv | tail -1 | cut -d, -f2)
FP_UTIL=$(cat $WORK/docker/hls/syn_dir/best.csv | tail -1 | cut -d, -f3)
echo "PERIOD_NS=${PERIOD_NS}ns FP_UTIL=${FP_UTIL}%"
PRJ="prj_LEGACY_${PERIOD_NS}ns_${FP_UTIL}%"
python3 scripts/collect_syn_metrics.py $WORK/docker/hls/syn_dir/$PRJ --output $WORK/docker/hls/syn_metrics.csv --print --min --rename
# NEW:
# python3 -m isaac_toolkit.eval.ise.asip_syn.ol2 --sess $SESS --workdir $WORK --set-name XIsaac --docker --core $CORE_NAME --pdk sky130
# python3 -m isaac_toolkit.eval.ise.asip_syn.synopsys --sess $SESS --workdir $WORK --set-name XIsaac --docker --core $CORE_NAME --pdk nangate45
