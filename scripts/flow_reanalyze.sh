#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

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

FINAL=${FINAL:-0}
PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}
BUILD_ARCH=${BUILD_ARCH:-0}

if [[ "$FINAL" == "1" ]]
then
    SUFFIX="_final"
elif [[ "$PRELIM" == "1" ]]
then
    SUFFIX="_prelim"
elif [[ "$FILTERED2" == "1" && "$SELECTED" == "1" ]]
then
    SUFFIX="_filtered2_selected"
elif [[ "$FILTERED2" == "1" ]]
then
    SUFFIX="_filtered2"
elif [[ "$FILTERED" == "1" && "$SELECTED" == 1 ]]
then
    SUFFIX="_filtered_selected"
elif [[ "$FILTERED" == "1" ]]
then
    SUFFIX="_filtered"
else
    SUFFIX=""
fi

RUN2=${RUN}_new${SUFFIX}
SESS2=${SESS}_new${SUFFIX}

RUN_COMPARE=${RUN}_compare
RUN_COMPARE_MEM=${RUN}_compare_mem
REPORT_COMPARE=$RUN_COMPARE/report.csv
REPORT_COMPARE_MEM=$RUN_COMPARE_MEM/report.csv


python3 -m isaac_toolkit.session.create --session $SESS2 $FORCE_ARGS

python3 -m isaac_toolkit.frontend.elf.riscv $RUN2/generic_mlonmcu --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.frontend.linker_map $RUN2/mlif/generic/linker.map --session $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.frontend.instr_trace.etiss $RUN2/etiss_instrs.log --session $SESS2 --operands $FORCE_ARGS
python3 -m isaac_toolkit.frontend.disass.objdump $RUN2/generic_mlonmcu.dump --session $SESS2 $FORCE_ARGS

# Import instruction names from original session
NAMES_CSV=$WORK/names${SUFFIX}.csv
ISE_INSTRS_PKL_OLD=$SESS/table/ise_instrs.pkl
ISE_INSTRS_PKL_NEW=$WORK/ise_instrs.pkl
python3 scripts/update_ise_instrs_pkl.py $ISE_INSTRS_PKL_OLD --out $ISE_INSTRS_PKL_NEW --names-csv $NAMES_CSV

python3 -m isaac_toolkit.frontend.ise.instrs $ISE_INSTRS_PKL_NEW --session $SESS2 $FORCE_ARGS
rm $ISE_INSTRS_PKL_NEW

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
# python3 -m isaac_toolkit.eval.ise.util --sess $SESS2 --names-csv $WORK/names.csv $FORCE_ARGS
python3 -m isaac_toolkit.eval.ise.util --sess $SESS2 $FORCE_ARGS
python3 -m isaac_toolkit.eval.ise.compare_bench --sess $SESS2 --report $REPORT_COMPARE --mem-report $REPORT_COMPARE_MEM $FORCE_ARGS
python3 -m isaac_toolkit.eval.ise.compare_sess --sess $SESS2 --with $SESS $FORCE_ARGS
# TODO: move to isaac-toolkit
python3 $SCRIPTS_DIR/diff_summary.py $DIR > $DIR/diff_summary.txt
which diff-so-fancy && python3 $SCRIPTS_DIR/diff_summary.py $DIR --fancy > $DIR/diff_summary_fancy.txt || :
# python3 -m isaac_toolkit.eval.ise.score.total --sess $SESS2
# python3 -m isaac_toolkit.eval.ise.summary --sess $SESS2  # -> combine all data into single table/plot/pdf?

python3 scripts/calc_util_score.py --dynamic-counts-custom-pkl $SESS2/table/dynamic_counts_custom.pkl --static-counts-custom-pkl $SESS2/table/dynamic_counts_custom.pkl --out $WORK/util_score${SUFFIX}.csv
