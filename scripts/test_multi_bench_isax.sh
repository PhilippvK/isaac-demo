#!/bin/bash

set -e

if [[ "$#" -ne 1 ]]
then
    echo "Illegal number of parameters"
    exit 1
fi

DIR=$1

if [[ ! -d "$DIR" ]]
then
    echo "Not a directory: $DIR"
fi

DIR=$(readlink -f $DIR)

LABEL=foobar

# Get index
INDEX_FILE=$DIR/dropped_index.yml

# Define benchmarks
BENCHMARKS=(embench/aha-mont64 embench/crc32 embench/edn embench/huffbench embench/matmult-int embench/md5sum embench/nbody embench/nettle-aes embench/nettle-sha256 embench/picojpeg embench/primecount embench/qrduino embench/st embench/tarfind embench/ud embench/wikisort)

# Define dirs & vars
WORK=$DIR/work
SESS=$DIR/sess
RUN=$DIR/run
RUN_MEM=$DIR/run_mem
GEN_DIR=$WORK/gen
DOCKER_DIR=$WORK/docker
SEAL5_DEST_DIR=$DOCKER_DIR/seal5/
SUFFIX=""

# Create workdir
mkdir -p $WORK
mkdir -p $DOCKER_DIR

# Create dummy session
FORCE_ARGS="--force"
python3 -m isaac_toolkit.session.create --session $SESS $FORCE_ARGS

# isaac_0_generate

ENC_SCORE_CSV=$WORK/encoding_score${SUFFIX}.csv

python3 scripts/analyze_encoding.py $INDEX_FILE -o $WORK/total_encoding_metrics${SUFFIX}.csv --score $ENC_SCORE_CSV

NAMES_CSV=$WORK/names${SUFFIX}.csv
ISE_INSTRS_PKL=$WORK/ise_instrs.pkl
python3 scripts/assign_names.py $INDEX_FILE --inplace --csv $NAMES_CSV --pkl $ISE_INSTRS_PKL
python3 -m isaac_toolkit.generate.ise.generate_cdsl --sess $SESS --workdir $WORK --gen-dir $GEN_DIR --index $INDEX_FILE $FORCE_ARGS

# assign_0_enc

python3 scripts/annotate_enc_score.py $INDEX_FILE --inplace --enc-score-csv $ENC_SCORE_CSV

# isaac_0_etiss
XLEN=${XLEN:-32}
BASE_EXTENSIONS=${ISAAC_BASE_EXTENSIONS:-"i,m,a,f,d,c,zicsr,zifencei"}
ETISS_CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}
SET_NAME=${ISAAC_SET_NAME:-XIsaac}

python3 -m isaac_toolkit.generate.iss.generate_etiss_core --workdir $WORK --gen-dir $GEN_DIR --core-name $ISAAC_CORE_NAME --set-name $SET_NAME --xlen $XLEN --semihosting --base-extensions $BASE_EXTENSIONS --auto-encoding --split --base-dir $(pwd)/etiss_arch_riscv/rv_base/ --tum-dir $(pwd)/etiss_arch_riscv --index $INDEX_FILE


# seal5_0_splitted

# CDSL_FILE=$GEN_DIR/$SET_NAME.core_desc
CDSL_FILE=$GEN_DIR/$SET_NAME.splitted.core_desc

mkdir -p $SEAL5_DEST_DIR

SEAL5_IMAGE=isaac-quickstart-seal5:latest

docker run -it --rm -v $(pwd):$(pwd) $SEAL5_IMAGE $SEAL5_DEST_DIR $CDSL_FILE $(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml $(pwd)/cfg/seal5/riscv.yml

SEAL5_SCORE_CSV=$SEAL5_DEST_DIR/seal5_score.csv

python3 scripts/seal5_score.py --output $SEAL5_SCORE_CSV --seal5-status-csv $SEAL5_DEST_DIR/seal5_reports/status.csv --seal5-status-compact-csv $SEAL5_DEST_DIR/seal5_reports/status_compact.csv

# assign_0_seal5

python3 scripts/annotate_seal5_score.py $INDEX_FILE --inplace --seal5-score-csv $SEAL5_SCORE_CSV

# etiss_0

ETISS_DEST_DIR=$DOCKER_DIR/etiss/


ETISS_IMAGE=isaac-quickstart-etiss:latest

mkdir -p $ETISS_DEST_DIR

docker run -it --rm -v $(pwd):$(pwd) $ETISS_IMAGE $ETISS_DEST_DIR $GEN_DIR/$ETISS_CORE_NAME.core_desc

# compare_multi_0

ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss_install
LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/llvm_install

TARGET=${TARGET:-etiss}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
GLOBAL_ISEL=${GLOBAL_ISEL:-0}

FULL_ARCH=${ARCH}_xisaac

ETISS_SCRIPT=$ETISS_INSTALL_DIR/bin/run_helper.sh

BENCHMARK_ARGS=""
for bench in "${BENCHMARKS[@]}"
do
    BENCHMARK_ARGS="$BENCHMARK_ARGS $bench"
done

NUM_THREADS=4

python3 -m mlonmcu.cli.main flow run $BENCHMARK_ARGS --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$ETISS_CORE_NAME -c $TARGET.print_outputs=1 -c llvm.install_dir=$LLVM_INSTALL_DIR --config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=$FULL_ARCH --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions" --parallel $NUM_THREADS -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL
python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_multi${SUFFIX}
python3 scripts/analyze_reuse.py ${RUN}_compare_multi${SUFFIX}/report.csv --print-df --output ${RUN}_compare_multi${SUFFIX}.csv

python3 -m mlonmcu.cli.main flow compile $BENCHMARK_ARGS --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-compare-mem -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$ETISS_CORE_NAME -c $TARGET.print_outputs=1 -c llvm.install_dir=$LLVM_INSTALL_DIR --config-gen etiss.arch=$ARCH --config-gen etiss.arch=$FULL_ARCH --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1 --parallel $NUM_THREADS -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL
python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_multi_mem${SUFFIX}
python3 scripts/analyze_reuse.py ${RUN}_compare_multi_mem${SUFFIX}/report.csv --print-df --mem --output ${RUN}_compare_multi_mem${SUFFIX}.csv

# compare_0_per_instr;assign_0_compare_per_instr;filter_0;compare_0_filtered;assign_0_compare_filtered;compare_others_0_filtered;assign_0_compare_others_filtered

# trace_multi_0 + reanalyze_multi_0

for bench in "${BENCHMARKS[@]}"
do
    RUN2=${RUN}_multi/${bench}
    mkdir -p $(dirname $RUN2)

    python3 -m mlonmcu.cli.main flow run $bench --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 --label $LABEL-trace2${SUFFIX} -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$ETISS_CORE_NAME -c llvm.install_dir=$LLVM_INSTALL_DIR -c $TARGET.arch=$FULL_ARCH -c mlif.global_isel=$GLOBAL_ISEL
    python3 -m mlonmcu.cli.main export --run -f -- $RUN2

    SESS2=${SESS}_multi/${bench}
    mkdir -p $(dirname $SESS2)

    python3 -m isaac_toolkit.session.create --session $SESS2 $FORCE_ARGS

    python3 -m isaac_toolkit.frontend.elf.riscv $RUN2/generic_mlonmcu --session $SESS2 $FORCE_ARGS
    python3 -m isaac_toolkit.frontend.linker_map $RUN2/mlif/generic/linker.map --session $SESS2 $FORCE_ARGS
    # python3 -m isaac_toolkit.frontend.instr_trace.etiss $RUN2/etiss_instrs.log --session $SESS2 --operands $FORCE_ARGS
    python3 -m isaac_toolkit.frontend.instr_trace.etiss $RUN2/etiss_instrs.log --session $SESS2 $FORCE_ARGS
    python3 -m isaac_toolkit.frontend.disass.objdump $RUN2/generic_mlonmcu.dump --session $SESS2 $FORCE_ARGS

    # Import instruction names from original session
    # NAMES_CSV=$WORK/names${SUFFIX}.csv
    # ISE_INSTRS_PKL_OLD=$SESS/table/ise_instrs.pkl
    # ISE_INSTRS_PKL_NEW=$WORK/ise_instrs.pkl
    # python3 scripts/update_ise_instrs_pkl.py $ISE_INSTRS_PKL_OLD --out $ISE_INSTRS_PKL_NEW --names-csv $NAMES_CSV

    python3 -m isaac_toolkit.frontend.ise.instrs $ISE_INSTRS_PKL --session $SESS2 $FORCE_ARGS
    # rm $ISE_INSTRS_PKL_NEW

    python3 -m isaac_toolkit.analysis.static.dwarf --session $SESS2 $FORCE_ARGS
    python3 -m isaac_toolkit.analysis.static.llvm_bbs --session $SESS2 $FORCE_ARGS
    python3 -m isaac_toolkit.analysis.static.mem_footprint --session $SESS2 $FORCE_ARGS
    python3 -m isaac_toolkit.analysis.static.linker_map --session $SESS2 $FORCE_ARGS
    python3 -m isaac_toolkit.analysis.dynamic.trace.trunc_trace --session $SESS2 --start-func mlonmcu_run $FORCE_ARGS
    python3 -m isaac_toolkit.analysis.dynamic.trace.trunc_trace --session $SESS2 --end-func stop_bench $FORCE_ARGS
    # python3 -m isaac_toolkit.analysis.dynamic.trace.instr_operands --session $SESS2 --imm-only $FORCE_ARGS
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
    # python3 -m isaac_toolkit.eval.ise.compare_bench --sess $SESS2 --report $REPORT_COMPARE --mem-report $REPORT_COMPARE_MEM $FORCE_ARGS
    # python3 -m isaac_toolkit.eval.ise.compare_sess --sess $SESS2 --with $SESS $FORCE_ARGS
    # python3 -m isaac_toolkit.eval.ise.score.total --sess $SESS2
    # python3 -m isaac_toolkit.eval.ise.summary --sess $SESS2  # -> combine all data into single table/plot/pdf?

    python3 scripts/calc_util_score.py --dynamic-counts-custom-pkl $SESS2/table/dynamic_counts_custom.pkl --static-counts-custom-pkl $SESS2/table/dynamic_counts_custom.pkl --out $SESS2/util_score.csv

    # cleanup run dir
    rm -r $RUN2
    # TODO: cleanup instr_trace.pkl?

done

# hls_0

ISAXES=ISAAC

# IMAGE=isaac-quickstart-hls:latest
# IMAGE=jhvjkcyyfdxghjk/isax-tools-integration-env
HLS_IMAGE=isax-tools-integration-env:latest
TOOLS_PATH=/work/git/tuda/isax-tools-integration5

# Load config
HLS_ENABLE=${HLS_ENABLE:-1}
HLS_SKIP_BASELINE=${HLS_SKIP_BASELINE:-0}
HLS_SKIP_DEFAULT=${HLS_SKIP_DEFAULT:-0}
HLS_SKIP_SHARED=${HLS_SKIP_SHARED:-0}
HLS_TOOL=${HLS_TOOL:-nailgun}
HLS_NAILGUN_CORE_NAME=${HLS_NAILGUN_CORE_NAME:-CVA5}
HLS_NAILGUN_CORE_NAME2=${HLS_NAILGUN_CORE_NAME2:-CVA5}
HLS_NAILGUN_ILP_SOLVER=${HLS_NAILGUN_ILP_SOLVER:-GUROBI}
HLS_NAILGUN_RESOURCE_MODEL=${HLS_NAILGUN_RESOURCE_MODEL:-ol_sky130}
HLS_NAILGUN_CLOCK_NS=${HLS_NAILGUN_CLOCK_NS:-100}
HLS_NAILGUN_SCHEDULE_TIMEOUT=${HLS_NAILGUN_SCHEDULE_TIMEOUT:-10}
HLS_NAILGUN_REFINE_TIMEOUT=${HLS_NAILGUN_REFINE_TIMEOUT:-10}
HLS_NAILGUN_CELL_LIBRARY=${HLS_NAILGUN_CELL_LIBRARY:-"$(pwd)/cfg/longnail/library.yaml"}
HLS_NAILGUN_OL2_ENABLE=${HLS_NAILGUN_OL2_ENABLE:-n}
# CONFIG_LN_MAX_LOOP_UNROLL_FACTOR=16
HLS_NAILGUN_SCHED_ALGO_MS=${HLS_NAILGUN_SCHED_ALGO_MS:-y}
HLS_NAILGUN_SCHED_ALGO_PA=${HLS_NAILGUN_SCHED_ALGO_PA:-y}
HLS_NAILGUN_SCHED_ALGO_RA=${HLS_NAILGUN_SCHED_ALGO_RA:-y}
HLS_NAILGUN_SCHED_ALGO_MI=${HLS_NAILGUN_SCHED_ALGO_MI:-y}
HLS_NAILGUN_OL2_CONFIG_TEMPLATE="$(pwd)/cfg/openlane/minimal_config_fast.json"
HLS_NAILGUN_OL2_UNTIL_STEP=${HLS_NAILGUN_OL2_UNTIL_STEP:-"OpenROAD.Floorplan"}
HLS_NAILGUN_OL2_TARGET_FREQ=${HLS_NAILGUN_OL2_TARGET_FREQ:-20}
HLS_NAILGUN_OL2_TARGET_UTIL=${HLS_NAILGUN_OL2_TARGET_UTIL:-20}
HLS_NAILGUN_SHARE_RESOURCES=${HLS_NAILGUN_SHARE_RESOURCES:-0}
# LN_OPTY_CUSTOM_MODEL_PATH
# LN_PREDEFINED_SOLUTION_SELECTION

PRELIM=${PRELIM:-0}
FILTERED=${FILTERED:-0}
FINAL=${FINAL:-0}

if [[ "$HLS_ENABLE" == "0" ]]
then
    echo "HLS disabled. Skipping step!"
    exit 0
fi

if [[ "$FINAL" == "1" ]]
then
    GEN_DIR=$WORK/gen_final/
elif [[ "$PRELIM" == "1" ]]
then
    GEN_DIR=$WORK/gen_prelim/
elif [[ "$FILTERED" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered/
else
    GEN_DIR=$WORK/gen/
fi

# CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}

if [[ $HLS_TOOL == "nailgun" ]]
then

    if [[ $HLS_NAILGUN_RESOURCE_MODEL == "none" ]]
    then
        USE_OL2_MODEL=n
    elif [[ $HLS_NAILGUN_RESOURCE_MODEL == "ol_sky130" ]]
    then
        USE_OL2_MODEL=y
    else
        echo "Unsupported HLS_NAILGUN_RESOURCE_MODEL: $HLS_NAILGUN_RESOURCE_MODEL"
        exit 1
    fi



    if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
    then
        if [[ "$HLS_NAILGUN_CORE_NAME" == "CVA5" ]]
        then
            echo "ASIP syn unsupported for CVA5."
            exit 1
        fi
    fi


    cp $GEN_DIR/$SET_NAME.hls.core_desc $TOOLS_PATH/nailgun/isaxes/isaac.core_desc  # TODO: do not hardcode
    # TODO: allow running the flow for multiple isaxes in parallel
    mkdir -p $WORK/docker/hls/
    sudo chmod 777 -R $WORK/docker/hls


    if [[ $ILP_SOLVER == "GUROBI" ]]
    then
        echo "TODO: CHECK FOR LICENSE"
    fi


    # First get RTL for the baseline core with out isax
    test -d $WORK/docker/hls/baseline/output && rm -r $WORK/docker/hls/baseline/output || :
    mkdir -p $WORK/docker/hls/baseline/output
    docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$WORK/docker/hls/baseline/output/.config OUTPUT_PATH=$WORK/docker/hls/baseline/output NO_ISAX=y SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
    sudo chmod 777 -R $WORK/docker/hls

    if [[ "$HLS_SKIP_BASELINE" == 0 ]]
    then
        # TODO: make sure that dir is empty?
        mkdir -p $WORK/docker/hls/baseline/rtl
        ./scripts/copy_rtl_files.sh $WORK/docker/hls/baseline/output/$HLS_NAILGUN_CORE_NAME2/files.txt $WORK/docker/hls/baseline/rtl
        if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
        then
            SDC_PATH=$(ls $WORK/docker/hls/baseline/output/hw_syn/runs/*/final/sdc/*.sdc)
            echo "SDC_PATH=$SDC_PATH"
            mkdir -p $WORK/docker/asip_syn/baseline
            grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/baseline/constraints.sdc

            # mkdir -p $WORK/docker/asip_syn/baseline/rtl
            # python3 scripts/get_rtl_files.py $WORK/docker/hls/baseline/output/hw_syn/config.json > $WORK/docker/hls/baseline/output/hw_syn/files.txt
            # ./scripts/copy_rtl_files.sh $WORK/docker/hls/baseline/output/hw_syn/files.txt $WORK/docker/asip_syn/baseline/rtl
        fi
    fi

    if [[ "$HLS_SKIP_DEFAULT" == 0 ]]
    then
        test -d $WORK/docker/hls/default/output && rm -r $WORK/docker/hls/default/output || :
        mkdir -p $WORK/docker/hls/default/output
        docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$WORK/docker/hls/default/output/.config OUTPUT_PATH=$WORK/docker/hls/default/output ISAXES=$ISAXES SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
        sudo chmod 777 -R $WORK/docker/hls

        # TODO: make sure that dir is empty?
        mkdir -p $WORK/docker/hls/default/rtl
        # cp $WORK/docker/hls/default/output/$HLS_NAILGUN_CORE_NAME/*.v $WORK/docker/hls/default/rtl/ || :
        # cp $WORK/docker/hls/default/output/$HLS_NAILGUN_CORE_NAME/*.sv $WORK/docker/hls/default/rtl/ || :
        cp $WORK/docker/hls/default/output/ISAX_$SET_NAME.sv $WORK/docker/hls/default/rtl/
        ./scripts/copy_rtl_files.sh $WORK/docker/hls/default/output/$HLS_NAILGUN_CORE_NAME2/files.txt $WORK/docker/hls/default/rtl
        echo -e "\nISAX_$SET_NAME.sv" >> $WORK/docker/hls/default/rtl/files.txt
        (git diff --no-index $WORK/docker/hls/baseline/rtl $WORK/docker/hls/default/rtl || : ) > $WORK/docker/hls/default/rtl.patch
        (git diff --no-index $WORK/docker/hls/baseline/rtl $WORK/docker/hls/default/rtl --shortstat || : ) > $WORK/docker/hls/default/rtl.patch.stat
        # python3 scripts/stat2locs.py $WORK/docker/hls/default/rtl.patch.stat $WORK/docker/hls/default/rtl.csv
        if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
        then
            # SDC_PATH=$(ls $WORK/docker/hls/default/output/hw_syn/runs/*/*-openroad-floorplan/*.sdc)
            SDC_PATH=$(ls $WORK/docker/hls/default/output/hw_syn/runs/*/final/sdc/*.sdc)
            echo "SDC_PATH=$SDC_PATH"
            mkdir -p $WORK/docker/asip_syn/default
            grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/default/constraints.sdc

            # mkdir -p $WORK/docker/asip_syn/rtl
            # python3 scripts/get_rtl_files.py $WORK/docker/hls/default/output/hw_syn/config.json > $WORK/docker/hls/default/output/hw_syn/files.txt
            # ./scripts/copy_rtl_files.sh $WORK/docker/hls/default/output/hw_syn/files.txt $WORK/docker/asip_syn/rtl
        fi


        python3 scripts/collect_hls_metrics.py $WORK/docker/hls/default/output --output $WORK/docker/hls/default/hls_metrics.csv --print
        python3 scripts/parse_kconfig.py $WORK/docker/hls/default/output/Kconfig $WORK/docker/hls/default/hls_schedules.csv
        python3 scripts/get_selected_schedule_metrics.py $WORK/docker/hls/default/hls_schedules.csv $WORK/docker/hls/default/output/selected_solutions.yaml $WORK/docker/hls/default/hls_selected_schedule_metrics.csv
    fi

    if [[ "$HLS_SKIP_SHARED" == 0 && $HLS_NAILGUN_SHARE_RESOURCES == "1" ]]
    then
        test -d $WORK/docker/hls/shared/output && rm -r $WORK/docker/hls/shared/output || :
        mkdir -p $WORK/docker/hls/shared/output
        sed -e "s/lil.enc_immediates/lil.sharing_group = 1, lil.enc_immediates/g" $WORK/docker/hls/default/output/mlir/ISAX_ISAAC_EN.mlir > $WORK/docker/hls/ISAX_ISAAC_EN_shared.mlir
        docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$WORK/docker/hls/shared/output/.config OUTPUT_PATH=$WORK/docker/hls/shared/output SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI MLIR_ENTRY_POINT_PATH=$WORK/docker/hls/ISAX_ISAAC_EN_shared.mlir OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
        sudo chmod 777 -R $WORK/docker/hls

        # TODO: make sure that dir is empty?
        mkdir -p $WORK/docker/hls/shared/rtl
        cp $WORK/docker/hls/shared/output/ISAX_$SET_NAME.sv $WORK/docker/hls/shared/rtl/
        ./scripts/copy_rtl_files.sh $WORK/docker/hls/shared/output/$HLS_NAILGUN_CORE_NAME2/files.txt $WORK/docker/hls/shared/rtl
        echo -e "\nISAX_$SET_NAME.sv" >> $WORK/docker/hls/shared/rtl/files.txt
        (git diff --no-index $WORK/docker/hls/baseline/rtl $WORK/docker/hls/shared/rtl || : )> $WORK/docker/hls/shared/rtl.patch
        (git diff --no-index $WORK/docker/hls/baseline/rtl $WORK/docker/hls/shared/rtl --shortstat || : ) > $WORK/docker/hls/shared/rtl.patch.stat
        # python3 scripts/stat2locs.py $WORK/docker/hls/shared/rtl.patch.stat $WORK/docker/hls/shared/rtl.csv
        if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
        then
            # SDC_PATH=$(ls $WORK/docker/hls/shared/output/hw_syn/runs/*/*-openroad-floorplan/*.sdc)
            SDC_PATH=$(ls $WORK/docker/hls/shared/output/hw_syn/runs/*/final/sdc/*.sdc)
            echo "SDC_PATH=$SDC_PATH"
            mkdir -p $WORK/docker/asip_syn/shared
            grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/shared/constraints.sdc

            # mkdir -p $WORK/docker/asip_syn/shared/rtl
            # python3 scripts/get_rtl_files.py $WORK/docker/hls/shared/output/hw_syn/config.json > $WORK/docker/hls/shared/output/hw_syn/files.txt
            # ./scripts/copy_rtl_files.sh $WORK/docker/hls/shared/output/hw_syn/files.txt $WORK/docker/asip_syn/shared/rtl
        fi

        python3 scripts/collect_hls_metrics.py $WORK/docker/hls/shared/output --output $WORK/docker/hls/shared/hls_metrics.csv --print
        python3 scripts/parse_kconfig.py $WORK/docker/hls/shared/output/Kconfig $WORK/docker/hls/shared/hls_schedules.csv
        python3 scripts/get_selected_schedule_metrics.py $WORK/docker/hls/shared/hls_schedules.csv $WORK/docker/hls/shared/output/selected_solutions.yaml $WORK/docker/hls/shared/hls_selected_schedule_metrics.csv
    fi
else
    echo "Unsupported HLS_TOOL: $HLS_TOOL"
    exit 1
fi

# assign_0_hls
# ...

# asip_syn_0

ASIP_SYN_SKIP_BASELINE=${ASIP_SYN_SKIP_BASELINE:-0}
ASIP_SYN_SKIP_DEFAULT=${ASIP_SYN_SKIP_DEFAULT:-0}
ASIP_SYN_SKIP_SHARED=${ASIP_SYN_SKIP_SHARED:-0}

FPGA_SYN_SKIP_BASELINE=${FPGA_SYN_SKIP_BASELINE:-0}
FPGA_SYN_SKIP_DEFAULT=${FPGA_SYN_SKIP_DEFAULT:-0}
FPGA_SYN_SKIP_SHARED=${FPGA_SYN_SKIP_SHARED:-0}

ASIP_SYN_ENABLE=${ASIP_SYN_ENABLE:-1}
ASIP_SYN_TOOL=${ASIP_SYN_TOOL:-vivado}

COLLECT_ASIP_ARGS=""
if [[ "$ASIP_SYN_ENABLE" == 1 ]]
then
    if [[ "$ASIP_SYN_SKIP_BASELINE" == 0 ]]
    then
        if [[ "$ASIP_SYN_TOOL" == "synopsys" ]]
        then
            mkdir -p $WORK/docker/asip_syn/baseline/rtl
            cp $WORK/docker/hls/baseline/rtl/* $WORK/docker/asip_syn/baseline/rtl
            ./asip_syn_script.sh $WORK/docker/asip_syn/baseline/ $WORK/docker/asip_syn/baseline/rtl $ASIP_SYN_SYNOPSYS_CORE_NAME $ASIP_SYN_SYNOPSYS_PDK $ASIP_SYN_SYNOPSYS_CLK_PERIOD $WORK/docker/asip_syn/baseline/constraints.sdc
            COLLECT_ASIP_ARGS="$COLLECT_ASIP_ARGS --baseline-dir $WORK/docker/asip_syn/baseline/"
        elif [[ "$ASIP_SYN_TOOL" == "ol2" ]]
        then
            echo "Unimplemented ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        else
            echo "Unsupported ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        fi
    fi
    if [[ "$ASIP_SYN_SKIP_DEFAULT" == 0 ]]
    then
        if [[ "$ASIP_SYN_TOOL" == "synopsys" ]]
        then
            mkdir -p $WORK/docker/asip_syn/default/rtl
            cp $WORK/docker/hls/default/rtl/* $WORK/docker/asip_syn/default/rtl
            ./asip_syn_script.sh $WORK/docker/asip_syn/default $WORK/docker/asip_syn/default/rtl $ASIP_SYN_SYNOPSYS_CORE_NAME $ASIP_SYN_SYNOPSYS_PDK $ASIP_SYN_SYNOPSYS_CLK_PERIOD $WORK/docker/asip_syn/default/constraints.sdc
            COLLECT_ASIP_ARGS="$COLLECT_ASIP_ARGS --default-dir $WORK/docker/asip_syn/default/"
        elif [[ "$ASIP_SYN_TOOL" == "ol2" ]]
        then
            echo "Unimplemented ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        else
            echo "Unsupported ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        fi
    fi
    if [[ "$ASIP_SYN_SKIP_SHARED" == 0 && $HLS_TOOL == "nailgun" && $HLS_NAILGUN_SHARE_RESOURCES == "1" ]]
    then
        if [[ "$ASIP_SYN_TOOL" == "synopsys" ]]
        then
            mkdir -p $WORK/docker/asip_syn/shared/rtl
            cp $WORK/docker/hls/shared/rtl/* $WORK/docker/asip_syn/shared/rtl
            ./asip_syn_script.sh $WORK/docker/asip_syn/shared $WORK/docker/asip_syn/shared/rtl $ASIP_SYN_SYNOPSYS_CORE_NAME $ASIP_SYN_SYNOPSYS_PDK $ASIP_SYN_SYNOPSYS_CLK_PERIOD $WORK/docker/asip_syn/shared/constraints.sdc
            COLLECT_ASIP_ARGS="$COLLECT_ASIP_ARGS --shared-dir $WORK/docker/asip_syn/shared/"
        elif [[ "$ASIP_SYN_TOOL" == "ol2" ]]
        then
            echo "Unimplemented ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        else
            echo "Unsupported ASIP_SYN_TOOL: $ASIP_SYN_TOOL"
            exit 1
        fi
    fi
fi
if [[ "$COLLECT_ASIP_ARGS" != "" ]]
then
    python3 scripts/collect_asip_syn_metrics.py $COLLECT_ASIP_ARGS --out $WORK/docker/asip_syn/metrics.csv
fi

# fpga_syn_0

FPGA_SYN_ENABLE=${FPGA_SYN_ENABLE:-1}
FPGA_SYN_TOOL=${FPGA_SYN_TOOL:-vivado}

ASIP_SYN_SYNOPSYS_CORE_NAME=${ASIP_SYN_SYNOPSYS_CORE_NAME:-CVA5}
ASIP_SYN_SYNOPSYS_CLK_PERIOD=${ASIP_SYN_SYNOPSYS_CLK_PERIOD:-50.0}
ASIP_SYN_SYNOPSYS_PDK=${ASIP_SYN_SYNOPSYS_PDK:-nangate45}

FPGA_SYN_VIVADO_CORE_NAME=${FPGA_SYN_VIVADO_CORE_NAME:-CVA5}
FPGA_SYN_VIVADO_CLK_PERIOD=${FPGA_SYN_VIVADO_CLK_PERIOD:-50.0}
FPGA_SYN_VIVADO_PART=${FPGA_SYN_VIVADO_PART:-xc7a200tffv1156-1}

COLLECT_FPGA_ARGS=""
if [[ "$FPGA_SYN_ENABLE" == 1 ]]
then
    if [[ "$FPGA_SYN_SKIP_BASELINE" == 0 ]]
    then
        if [[ "$FPGA_SYN_TOOL" == "vivado" ]]
        then
            ./scripts/fpga_syn_script.sh $WORK/docker/fpga_syn/baseline/ $WORK/docker/hls/baseline/rtl $FPGA_SYN_VIVADO_CORE_NAME $FPGA_SYN_VIVADO_PART $FPGA_SYN_VIVADO_CLK_PERIOD
            COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --baseline-dir $WORK/docker/fpga_syn/baseline/"
        else
            echo "Unsupported FPGA_SYN_TOOL: $FPGA_SYN_TOOL"
            exit 1
        fi
    fi
    if [[ "$FPGA_SYN_SKIP_DEFAULT" == 0 ]]
    then
        if [[ "$FPGA_SYN_TOOL" == "vivado" ]]
        then
            ./scripts/fpga_syn_script.sh $WORK/docker/fpga_syn/default/ $WORK/docker/hls/default/rtl $FPGA_SYN_VIVADO_CORE_NAME $FPGA_SYN_VIVADO_PART $FPGA_SYN_VIVADO_CLK_PERIOD
            COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --default-dir $WORK/docker/fpga_syn/default/"
        else
            echo "Unsupported FPGA_SYN_TOOL: $FPGA_SYN_TOOL"
            exit 1
        fi
    fi
    if [[ "$FPGA_SYN_SKIP_SHARED" == 0 && $HLS_TOOL == "nailgun" && $HLS_NAILGUN_SHARE_RESOURCES == "1" ]]
    then
        if [[ "$FPGA_SYN_TOOL" == "vivado" ]]
        then
            ./scripts/fpga_syn_script.sh $WORK/docker/fpga_syn/shared/ $WORK/docker/hls/shared/rtl $FPGA_SYN_VIVADO_CORE_NAME $FPGA_SYN_VIVADO_PART $FPGA_SYN_VIVADO_CLK_PERIOD
            COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --shared-dir $WORK/docker/fpga_syn/shared/"
        else
            echo "Unsupported FPGA_SYN_TOOL: $FPGA_SYN_TOOL"
            exit 1
        fi
    fi
fi

if [[ "$COLLECT_FPGA_ARGS" != "" ]]
then
    python3 scripts/collect_fpga_syn_metrics.py $COLLECT_FPGA_ARGS --out $WORK/docker/fpga_syn/metrics.csv
fi

# assign_0_syn
# ...
