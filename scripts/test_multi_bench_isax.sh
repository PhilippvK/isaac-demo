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

MULTI=${MULTI:-0}
UNION=${UNION:-0}
FILTERED=${FILTERED:-0}
SELECTED=${SELECTED:-0}
FILTERED_ALT=${FILTERED_ALT:-0}
TOPK=${TOPK:-0}
TOPK_ALT=${TOPK_ALT:-0}
# SUFFIX=""
IN_SUFFIX=${IN_SUFFIX:-""}
OUT_SUFFIX=${OUT_SUFFIX:-""}


# Get index
INDEX_FILE=$DIR/dropped_${IN_SUFFIX}index.yml

# Define benchmarks
# BENCHMARKS=(embench/aha-mont64 embench/crc32 embench/edn embench/huffbench embench/matmult-int embench/md5sum embench/nbody embench/nettle-aes embench/nettle-sha256 embench/picojpeg embench/primecount embench/qrduino embench/st embench/tarfind embench/ud embench/wikisort)
BENCH_NAMES_TXT=$DIR/bench_names.txt

if [[ ! -f "$BENCH_NAMES_TXT" ]]
then
    echo "Missing: $BENCH_NAMES_TXT"
    exit 1
fi
BENCHMARKS=()
for bench_name in $(cat $BENCH_NAMES_TXT)
do
    BENCHMARKS+=($bench_name)
done
echo BENCHMARKS=${BENCHMARKS[*]}


SET_NAME=${ISAAC_SET_NAME:-XIsaac}
if [[ "$MULTI" == "1" ]]
then
    SET_NAMES_TXT=$DIR/set_names.txt
    if [[ ! -f "$SET_NAMES_TXT" ]]
    then
        echo "Missing: $SET_NAMES_TXT"
    fi
    INDEX_FILE=""
    SET_NAME=""
    for set_name in $(cat $SET_NAMES_TXT)
    do
        INDEX_FILE_=$DIR/${set_name}_index.yml
        if [[ "$SET_NAME" == "" ]]
        then
            INDEX_FILE=$INDEX_FILE_
            SET_NAME=$set_name
        else
            INDEX_FILE="$INDEX_FILE;$INDEX_FILE_"
            SET_NAME="$SET_NAME;$set_name"
        fi
    done
    DIR=$DIR/multi/
    mkdir -p $DIR
elif [[ "$UNION" == "1" ]]
then
    INDEX_FILE=$DIR/union${IN_SUFFIX}_index.yml
    DIR=$DIR/union${OUT_SUFFIX}/
    mkdir -p $DIR
elif [[ "$FILTERED_ALT" == "1" ]]
then
    INDEX_FILE=$DIR/alt/filtered${IN_SUFFIX}_index.yml
    DIR=$DIR/filtered_alt${OUT_SUFFIX}/
    mkdir -p $DIR
elif [[ "$SELECTED" == "1" && "$FILTERED" == "1" ]]
then
    INDEX_FILE=$DIR/selected/filtered${IN_SUFFIX}_index.yml
    DIR=$DIR/selected_filtered${OUT_SUFFIX}/
    mkdir -p $DIR
elif [[ "$SELECTED" == "1" ]]
then
    INDEX_FILE=$DIR/selected${IN_SUFFIX}_index.yml
    DIR=$DIR/selected${OUT_SUFFIX}/
    mkdir -p $DIR
elif [[ "$FILTERED" == "1" ]]
then
    INDEX_FILE=$DIR/filtered${IN_SUFFIX}_index.yml
    DIR=$DIR/filtered${OUT_SUFFIX}/
    mkdir -p $DIR
elif [[ "$TOPK_ALT" == "1" ]]
then
    INDEX_FILE=$DIR/topk_alt${IN_SUFFIX}_index.yml
    DIR=$DIR/alt${OUT_SUFFIX}/
    mkdir -p $DIR
elif [[ "$TOPK" == "1" ]]
then
    INDEX_FILE=$DIR/topk${IN_SUFFIX}_index.yml
fi



# Define dirs & vars
WORK=$DIR/work
SESS=$DIR/sess
RUN=$DIR/run
RUN_MEM=$DIR/run_mem
GEN_DIR=$WORK/gen
DOCKER_DIR=$WORK/docker
SEAL5_DEST_DIR=$DOCKER_DIR/seal5/
ENC_SCORE_CSV=$WORK/encoding_score${OUT_SUFFIX}.csv
NAMES_CSV=$WORK/names${OUT_SUFFIX}.csv
ISE_INSTRS_PKL=$WORK/ise_instrs.pkl
FORCE_ARGS="--force"
XLEN=${XLEN:-32}
BASE_EXTENSIONS=${ISAAC_BASE_EXTENSIONS:-"i,m,a,f,d,c,zicsr,zifencei"}
ETISS_CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}
# CDSL_FILE=$GEN_DIR/$SET_NAME.core_desc
SPLITTED=${SPLITTED:-1}
SEAL5_IMAGE=isaac-quickstart-seal5:latest
SEAL5_SCORE_CSV=$SEAL5_DEST_DIR/seal5_score.csv
ETISS_DEST_DIR=$DOCKER_DIR/etiss/
ETISS_IMAGE=isaac-quickstart-etiss:latest
ETISS_INSTALL_DIR=$ETISS_DEST_DIR/etiss_install
LLVM_INSTALL_DIR=$SEAL5_DEST_DIR/llvm_install
TARGET=${TARGET:-etiss}
ARCH=${ARCH:-rv32imfd}
ABI=${ABI:-ilp32d}
UNROLL=${UNROLL:-auto}
OPTIMIZE=${OPTIMIZE:-3}
GLOBAL_ISEL=${GLOBAL_ISEL:-0}
ETISS_SCRIPT=$ETISS_INSTALL_DIR/bin/run_helper.sh
NUM_THREADS=16  # TODO: auto
# IMAGE=isaac-quickstart-hls:latest
# IMAGE=jhvjkcyyfdxghjk/isax-tools-integration-env
HLS_IMAGE=isax-tools-integration-env:latest
TOOLS_PATH=/work/git/tuda/isax-tools-integration5

# Load config
HLS_ENABLE=${HLS_ENABLE:-1}
HLS_SKIP_BASELINE=${HLS_SKIP_BASELINE:-0}
HLS_BASELINE_USE=${HLS_BASELINE_USE:-""}
# HLS_BASELINE_USE=""
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
ASIP_SYN_SKIP_BASELINE=${ASIP_SYN_SKIP_BASELINE:-0}
ASIP_SYN_BASELINE_USE=${ASIP_SYN_BASELINE_USE:-""}
ASIP_SYN_SKIP_DEFAULT=${ASIP_SYN_SKIP_DEFAULT:-0}
ASIP_SYN_SKIP_SHARED=${ASIP_SYN_SKIP_SHARED:-0}
FPGA_SYN_SKIP_BASELINE=${FPGA_SYN_SKIP_BASELINE:-0}
FPGA_SYN_BASELINE_USE=${FPGA_SYN_BASELINE_USE:-""}
FPGA_SYN_SKIP_DEFAULT=${FPGA_SYN_SKIP_DEFAULT:-0}
FPGA_SYN_SKIP_SHARED=${FPGA_SYN_SKIP_SHARED:-0}
ASIP_SYN_ENABLE=${ASIP_SYN_ENABLE:-1}
ASIP_SYN_TOOL=${ASIP_SYN_TOOL:-synopsys}
FPGA_SYN_ENABLE=${FPGA_SYN_ENABLE:-1}
FPGA_SYN_TOOL=${FPGA_SYN_TOOL:-vivado}
ASIP_SYN_SYNOPSYS_CORE_NAME=${ASIP_SYN_SYNOPSYS_CORE_NAME:-CVA5}
ASIP_SYN_SYNOPSYS_CLK_PERIOD=${ASIP_SYN_SYNOPSYS_CLK_PERIOD:-50.0}
ASIP_SYN_SYNOPSYS_PDK=${ASIP_SYN_SYNOPSYS_PDK:-nangate45}
FPGA_SYN_VIVADO_CORE_NAME=${FPGA_SYN_VIVADO_CORE_NAME:-CVA5}
FPGA_SYN_VIVADO_CLK_PERIOD=${FPGA_SYN_VIVADO_CLK_PERIOD:-50.0}
FPGA_SYN_VIVADO_PART=${FPGA_SYN_VIVADO_PART:-xc7a200tffv1156-1}
ISAAC_ENABLE=${ISAAC_ENABLE:-1}
SEAL5_ENABLE=${SEAL5_ENABLE:-1}
SEAL5_SPLITTED=${SEAL5_SPLITTED:-0}
ETISS_ENABLE=${ETISS_ENABLE:-1}
COMPARE_MULTI_ENABLE=${COMPARE_MULTI_ENABLE:-1}
COMPARE_MULTI_PER_INSTR=${COMPARE_MULTI_PER_INSTR:-0}
SELECT_ENABLE=${SELECT_ENABLE:-1}
FILTER_ENABLE=${FILTER_ENABLE:-0}
# FILTER_SELECTED_ENABLE=${FILTER_SELECTED_ENABLE:-1}
# SELECT_FILTERED_ENABLE=${SELECT_FILTERED_ENABLE:-0}
RETRACE_ENABLE=${RETRACE_ENABLE:-0}
# RETRACE_SELECTED_ENABLE=${RETRACE_SELECTED_ENABLE:-1}
# RETRACE_FILTERED_ENABLE=${RETRACE_FILTERED_ENABLE:-0}
# RETRACE_FILTERED_SELECTED_ENABLE=${RETRACE_FILTERED_SELECTED_ENABLE:-0}
# RETRACE_SELECTED_FILTERED_ENABLE=${RETRACE_SELECTED_FILTERED_ENABLE:-0}
REANALYZE_ENABLE=${REANALYZE_ENABLE:-0}
# REANALYZE_SELECTED_ENABLE=${REANALYZE_SELECTED_ENABLE:-1}
# REANALYZE_FILTERED_ENABLE=${REANALYZE_FILTERED_ENABLE:-0}
# REANALYZE_FILTERED_SELECTED_ENABLE=${REANALYZE_FILTERED_SELECTED_ENABLE:-0}
# REANALYZE_SELECTED_FILTERED_ENABLE=${REANALYZE_SELECTED_FILTERED_ENABLE:-0}
# VERBOSE_ARGS="-v"
VERBOSE_ARGS=""
PROGRESS_ARGS="--progress"
AGG_ENABLE=${AGG_ENABLE:-1}
# PROGESS_ARGS=""

# Create workdir
mkdir -p $WORK
mkdir -p $DOCKER_DIR

# Create dummy session
python3 -m isaac_toolkit.session.create --session $SESS $FORCE_ARGS

# isaac_0_generate

if [[ "$ISAAC_ENABLE" == 1 ]]
then
    if [[ "$MULTI" == "0" ]]
    then
        python3 -m isaac_toolkit.utils.analyze_encoding $INDEX_FILE -o $WORK/total_encoding_metrics${OUT_SUFFIX}.csv --score $ENC_SCORE_CSV

        python3 -m isaac_toolkit.utils.assign_names $INDEX_FILE --inplace --csv $NAMES_CSV --pkl $ISE_INSTRS_PKL
        python3 -m isaac_toolkit.generate.ise.generate_cdsl --sess $SESS --workdir $WORK --gen-dir $GEN_DIR --index $INDEX_FILE $FORCE_ARGS

        # assign_0_enc

        python3 -m isaac_toolkit.utils.annotate_enc_score $INDEX_FILE --inplace --enc-score-csv $ENC_SCORE_CSV
    fi

    # isaac_0_etiss

    TUM_DIR=${CDSL_TUM_DIR:-$(pwd)/etiss_arch_riscv}
    BASE_DIR=${CDSL_BASE_DIR:-$(pwd)/etiss_arch_riscv/rv_base}
    EXTRA_INCLUDES=${CDSL_EXTRA_INCLUDES:-""}
    EXTRA_ARGS=""
    ADD_MNEMONIC_PREFIX=$MULTI
    if [[ "$ADD_MNEMONIC_PREFIX" == "1" ]]
    then
        EXTRA_ARGS="$EXTRA_ARGS --add-mnemonic-prefix"
    fi
    python3 -m isaac_toolkit.generate.iss.generate_etiss_core --workdir $WORK --gen-dir $GEN_DIR --core-name $ISAAC_CORE_NAME --set-name $SET_NAME --index $INDEX_FILE --xlen $XLEN --semihosting --base-extensions $BASE_EXTENSIONS --auto-encoding --split --base-dir $BASE_DIR --tum-dir $TUM_DIR --extra-includes $EXTRA_INCLUDES --index $INDEX_FILE $EXTRA_ARGS
fi


# seal5_0_splitted

if [[ "$SEAL5_ENABLE" == 1 ]]
then
    mkdir -p $SEAL5_DEST_DIR

    CDSL_FILES=""
    CFG_FILES="$(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml $(pwd)/cfg/seal5/riscv.yml"

    for set_name in ${SET_NAME//;/ }
    do
        if [[ "$SPLITTED" == "1" ]]
        then
            CDSL_FILE=$GEN_DIR/$set_name.splitted.core_desc
        else
            CDSL_FILE=$GEN_DIR/$set_name.core_desc
        fi
        CDSL_FILES="$CDSL_FILES $CDSL_FILE"
    done

    docker run -i --rm -v $(pwd):$(pwd) $SEAL5_IMAGE $SEAL5_DEST_DIR $CDSL_FILES $CFG_FILES

    python3 -m isaac_toolkit.utils.seal5_score --output $SEAL5_SCORE_CSV --seal5-status-csv $SEAL5_DEST_DIR/seal5_reports/status.csv --seal5-status-compact-csv $SEAL5_DEST_DIR/seal5_reports/status_compact.csv

    # assign_0_seal5

    if [[ "$MULTI" == "0" ]]
    then
        python3 -m isaac_toolkit.utils.annotate_seal5_score $INDEX_FILE --inplace --seal5-score-csv $SEAL5_SCORE_CSV
    fi
fi

# etiss_0

if [[ "$ETISS_ENABLE" == 1 ]]
then
    mkdir -p $ETISS_DEST_DIR

    docker run -i --rm -v $(pwd):$(pwd) $ETISS_IMAGE $ETISS_DEST_DIR $GEN_DIR/$ETISS_CORE_NAME.core_desc
fi

# compare_multi_0


if [[ "$COMPARE_MULTI_ENABLE" == 1 ]]
then
    BENCHMARK_ARGS=""
    for bench in "${BENCHMARKS[@]}"
    do
        BENCHMARK_ARGS="$BENCHMARK_ARGS $bench"
    done
    # TODO: only enable one set per prog?
    if [[ "$MULTI" == "1" ]]
    then
        FULL_ARCH=${ARCH}
        for set_name in ${SET_NAME//;/ }
        do
            set_name_lower=$(echo $set_name | tr '[:upper:]' '[:lower:]')
            FULL_ARCH="${FULL_ARCH}_${set_name_lower}"
        done
    else
        FULL_ARCH=${ARCH}_xisaac
    fi
    PRINT_OUTPUTS=0
    python3 -m mlonmcu.cli.main flow run $BENCHMARK_ARGS --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$ETISS_CORE_NAME -c $TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=$FULL_ARCH --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions" --parallel $NUM_THREADS -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL $PROGRESS_ARGS
    python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_multi${OUT_SUFFIX}
    python3 $SCRIPTS_DIR/analyze_reuse.py ${RUN}_compare_multi${OUT_SUFFIX}/report.csv --print-df --output ${RUN}_compare_multi${OUT_SUFFIX}.csv

    python3 -m mlonmcu.cli.main flow compile $BENCHMARK_ARGS --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare-mem -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$ETISS_CORE_NAME -c $TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --config-gen $TARGET.arch=$ARCH --config-gen $TARGET.arch=$FULL_ARCH --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1 --parallel $NUM_THREADS -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL $PROGRESS_ARGS
    python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_multi_mem${OUT_SUFFIX}
    python3 $SCRIPTS_DIR/analyze_reuse.py ${RUN}_compare_multi_mem${OUT_SUFFIX}/report.csv --print-df --mem --output ${RUN}_compare_multi_mem${OUT_SUFFIX}.csv
fi

if [[ "$COMPARE_MULTI_PER_INSTR_ENABLE" == 1 && "$MULTI" == "0" ]]
then
    BENCHMARK_ARGS=""
    for bench in "${BENCHMARKS[@]}"
    do
        BENCHMARK_ARGS="$BENCHMARK_ARGS $bench"
    done
    # TODO: only enable one set per prog?
    if [[ ! -f $NAMES_CSV ]]
    then
        echo "Missing: $NAMES_CSV"
        exit 1
    fi

    CONFIG_GEN_ARGS="--config-gen $TARGET.arch=$ARCH"

    for name in $(cat $NAMES_CSV | tail -n "+2" | cut -d, -f2)
    do
        CONFIG_GEN_ARGS="$CONFIG_GEN_ARGS --config-gen $TARGET.arch=${ARCH}_xisaac${name}single"
    done
    # echo "CONFIG_GEN_ARGS=$CONFIG_GEN_ARGS"
    # read -n 1
    python3 -m mlonmcu.cli.main flow run $BENCHMARK_ARGS --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$ETISS_CORE_NAME -c $TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="Run Instructions" --parallel $NUM_THREADS -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL $CONFIG_GEN_ARGS $PROGRESS_ARGS
    python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_multi_per_instr${OUT_SUFFIX}


    # TODO: optionally skip mem
    # python3 -m mlonmcu.cli.main flow compile $BENCHMARK_ARGS --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm --label $LABEL-compare-mem -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$ETISS_CORE_NAME -c $TARGET.print_outputs=$PRINT_OUTPUTS -c llvm.install_dir=$LLVM_INSTALL_DIR --post config2cols -c config2cols.limit=$TARGET.arch --post rename_cols -c rename_cols.mapping="{'config_$TARGET.arch': 'Arch'}" --post compare_rows -c compare_rows.to_compare="ROM code" -c mlif.strip_strings=1 --parallel $NUM_THREADS -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -c mlif.global_isel=$GLOBAL_ISEL $CONFIG_GEN_ARGS $PROGRESS_ARGS
    # python3 -m mlonmcu.cli.main export --session -f -- ${RUN}_compare_multi_mem_per_instr${OUT_SUFFIX}

    # python3 -m isaac_toolkit.utils.analyze_compare.py ${RUN}_compare_multi_per_instr${OUT_SUFFIX}/report.csv --mem-report ${RUN}_compare_multi_mem_per_instr${OUT_SUFFIX}/report.csv --print-df --output ${DIR}/compare_multi_per_instr${OUT_SUFFIX}.csv
    python3 -m isaac_toolkit.utils.analyze_compare ${RUN}_compare_multi_per_instr${OUT_SUFFIX}/report.csv --print-df --output ${DIR}/compare_multi_per_instr${OUT_SUFFIX}.csv
    python3 -m isaac_toolkit.utils.annotate_per_instr_metrics $INDEX_FILE --inplace --report ${DIR}/compare_multi_per_instr${OUT_SUFFIX}.csv --multi --multi-agg-func sum
fi

# hls_0

if [[ "$HLS_ENABLE" == 1 ]]
then
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


        ISAXES=""
        # SET_NAME is a ;-separated list, ISAXES is ,-separated and upper case
        SET_NAME_OUT=""
        for set_name in ${SET_NAME//;/ }
        do
            # call your procedure/other scripts here below
            set_name_upper=$(echo $set_name | tr '[:lower:]' '[:upper:]')
            set_name_lower=$(echo $set_name | tr '[:upper:]' '[:lower:]')
            if [[ "$ISAXES" == "" ]]
            then
                SET_NAME_OUT=$set_name
                ISAXES=$set_name_upper
            else
                # For 2+ sets the name is always 'merged'
                SET_NAME_OUT=merged
                ISAXES=$ISAXES,$set_name_upper
            fi
            cp $GEN_DIR/$set_name.hls.core_desc $TOOLS_PATH/nailgun/isaxes/$set_name_lower.core_desc  # TODO: do not hardcode
        done
        echo ISAXES=$ISAXES
        # TODO: allow running the flow for multiple isaxes in parallel
        mkdir -p $WORK/docker/hls/
        sudo chmod 777 -R $WORK/docker/hls


        if [[ $ILP_SOLVER == "GUROBI" ]]
        then
            echo "TODO: CHECK FOR LICENSE"
        fi


        if [[ "$HLS_SKIP_BASELINE" == 0 ]]
        then
            echo "HLS_BASELINE_USE=$HLS_BASELINE_USE"
            if [[ "$HLS_BASELINE_USE" != "" ]]
            then
                if [[ ! -d "$HLS_BASELINE_USE" ]]
                then
                    echo "Missing: $HLS_BASELINE_USE"
                    exit 1
                fi
                OUTPUT_DIR=$HLS_BASELINE_USE/output
                if [[ ! -d "$OUTPUT_DIR" ]]
                then
                    echo "Missing: $OUTPUT_DIR"
                    exit 1
                fi
            else
                OUTPUT_DIR=$WORK/docker/hls/baseline/output
                test -d $OUTPUT_DIR && rm -r $OUTPUT_DIR || :
                mkdir -p $OUTPUT_DIR
                docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR NO_ISAX=y SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
                sudo chmod 777 -R $WORK/docker/hls
            fi

            # TODO: make sure that dir is empty?
            mkdir -p $WORK/docker/hls/baseline/rtl
            $SCRIPTS_DIR/copy_rtl_files.sh $OUTPUT_DIR/$HLS_NAILGUN_CORE_NAME2/files.txt $WORK/docker/hls/baseline/rtl
            if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
            then
                SDC_PATH=$(ls $OUTPUT_DIR/hw_syn/runs/*/final/sdc/*.sdc)
                echo "SDC_PATH=$SDC_PATH"
                mkdir -p $WORK/docker/asip_syn/baseline
                grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/baseline/constraints.sdc

                # mkdir -p $WORK/docker/asip_syn/baseline/rtl
                # python3 $SCRIPTS_DIR/get_rtl_files.py $WORK/docker/hls/baseline/output/hw_syn/config.json > $WORK/docker/hls/baseline/output/hw_syn/files.txt
                # $SCRIPTS_DIR/copy_rtl_files.sh $WORK/docker/hls/baseline/output/hw_syn/files.txt $WORK/docker/asip_syn/baseline/rtl
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
            $SCRIPTS_DIR/copy_rtl_files.sh $WORK/docker/hls/default/output/$HLS_NAILGUN_CORE_NAME2/files.txt $WORK/docker/hls/default/rtl
            # for set_name in ${SET_NAME//;/ }
            # do
            #     cp $WORK/docker/hls/default/output/ISAX_$set_name.sv $WORK/docker/hls/default/rtl/
            #     echo -e "\nISAX_$set_name.sv" >> $WORK/docker/hls/default/rtl/files.txt
            # done
            cp $WORK/docker/hls/default/output/ISAX_$SET_NAME_OUT.sv $WORK/docker/hls/default/rtl/
            echo -e "\nISAX_$SET_NAME_OUT.sv" >> $WORK/docker/hls/default/rtl/files.txt
            (git diff --no-index $WORK/docker/hls/baseline/rtl $WORK/docker/hls/default/rtl || : ) > $WORK/docker/hls/default/rtl.patch
            (git diff --no-index $WORK/docker/hls/baseline/rtl $WORK/docker/hls/default/rtl --shortstat || : ) > $WORK/docker/hls/default/rtl.patch.stat
            # python3 $SCRIPTS_DIR/stat2locs.py $WORK/docker/hls/default/rtl.patch.stat $WORK/docker/hls/default/rtl.csv
            if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
            then
                # SDC_PATH=$(ls $WORK/docker/hls/default/output/hw_syn/runs/*/*-openroad-floorplan/*.sdc)
                SDC_PATH=$(ls $WORK/docker/hls/default/output/hw_syn/runs/*/final/sdc/*.sdc)
                echo "SDC_PATH=$SDC_PATH"
                mkdir -p $WORK/docker/asip_syn/default
                grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/default/constraints.sdc

                # mkdir -p $WORK/docker/asip_syn/rtl
                # python3 $SCRIPTS_DIR/get_rtl_files.py $WORK/docker/hls/default/output/hw_syn/config.json > $WORK/docker/hls/default/output/hw_syn/files.txt
                # $SCRIPTS_DIR/copy_rtl_files.sh $WORK/docker/hls/default/output/hw_syn/files.txt $WORK/docker/asip_syn/rtl
            fi


            python3 $SCRIPTS_DIR/collect_hls_metrics.py $WORK/docker/hls/default/output --output $WORK/docker/hls/default/hls_metrics.csv --print
            python3 $SCRIPTS_DIR/parse_kconfig.py $WORK/docker/hls/default/output/Kconfig $WORK/docker/hls/default/hls_schedules.csv
            python3 $SCRIPTS_DIR/get_selected_schedule_metrics.py $WORK/docker/hls/default/hls_schedules.csv $WORK/docker/hls/default/output/selected_solutions.yaml $WORK/docker/hls/default/hls_selected_schedule_metrics.csv
            if [[ "$MULTI" == "0" ]]
            then
                python3 -m isaac_toolkit.utils.annotate_hls_score $INDEX_FILE --inplace --hls-schedules-csv $DOCKER_DIR/hls/default/hls_schedules.csv --hls-selected-schedules-yaml $DOCKER_DIR/hls/default/output/selected_solutions.yaml
            fi
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
            $SCRIPTS_DIR/copy_rtl_files.sh $WORK/docker/hls/shared/output/$HLS_NAILGUN_CORE_NAME2/files.txt $WORK/docker/hls/shared/rtl
            # for set_name in ${SET_NAME//;/ }
            # do
            #     cp $WORK/docker/hls/shared/output/ISAX_$set_name.sv $WORK/docker/hls/shared/rtl/
            #     echo -e "\nISAX_$set_name.sv" >> $WORK/docker/hls/shared/rtl/files.txt
            # done
            cp $WORK/docker/hls/shared/output/ISAX_$SET_NAME_OUT.sv $WORK/docker/hls/shared/rtl/
            echo -e "\nISAX_$SET_NAME_OUT.sv" >> $WORK/docker/hls/shared/rtl/files.txt
            (git diff --no-index $WORK/docker/hls/baseline/rtl $WORK/docker/hls/shared/rtl || : )> $WORK/docker/hls/shared/rtl.patch
            (git diff --no-index $WORK/docker/hls/baseline/rtl $WORK/docker/hls/shared/rtl --shortstat || : ) > $WORK/docker/hls/shared/rtl.patch.stat
            # python3 $SCRIPTS_DIR/stat2locs.py $WORK/docker/hls/shared/rtl.patch.stat $WORK/docker/hls/shared/rtl.csv
            if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
            then
                # SDC_PATH=$(ls $WORK/docker/hls/shared/output/hw_syn/runs/*/*-openroad-floorplan/*.sdc)
                SDC_PATH=$(ls $WORK/docker/hls/shared/output/hw_syn/runs/*/final/sdc/*.sdc)
                echo "SDC_PATH=$SDC_PATH"
                mkdir -p $WORK/docker/asip_syn/shared
                grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/shared/constraints.sdc

                # mkdir -p $WORK/docker/asip_syn/shared/rtl
                # python3 $SCRIPTS_DIR/get_rtl_files.py $WORK/docker/hls/shared/output/hw_syn/config.json > $WORK/docker/hls/shared/output/hw_syn/files.txt
                # $SCRIPTS_DIR/copy_rtl_files.sh $WORK/docker/hls/shared/output/hw_syn/files.txt $WORK/docker/asip_syn/shared/rtl
            fi

            python3 $SCRIPTS_DIR/collect_hls_metrics.py $WORK/docker/hls/shared/output --output $WORK/docker/hls/shared/hls_metrics.csv --print
            python3 $SCRIPTS_DIR/parse_kconfig.py $WORK/docker/hls/shared/output/Kconfig $WORK/docker/hls/shared/hls_schedules.csv
            python3 $SCRIPTS_DIR/get_selected_schedule_metrics.py $WORK/docker/hls/shared/hls_schedules.csv $WORK/docker/hls/shared/output/selected_solutions.yaml $WORK/docker/hls/shared/hls_selected_schedule_metrics.csv
        fi
    else
        echo "Unsupported HLS_TOOL: $HLS_TOOL"
        exit 1
    fi
fi

# assign_0_hls
# ...

if [[ "$SELECT_ENABLE" == 1 ]]
then
    # TODO: check if exists
    SPEC_GRAPH=$DIR/spec_graph${OUT_SUFFIX}.pkl
    python3 -m tool.detect_specializations $INDEX_FILE --graph $SPEC_GRAPH --noop
    python3 -m isaac_toolkit.utils.annotate_global_artifacts $INDEX_FILE --inplace --data ETISS_INSTALL_DIR=$WORK/docker/etiss/etiss_install
    python3 -m isaac_toolkit.annotate_global_artifacts $INDEX_FILE --inplace --data LLVM_INSTALL_DIR=$WORK/docker/seal5/llvm_install
    SELECTED_INDEX_FILE=$DIR/selected${OUT_SUFFIX}_index.yml
    BENCH_FULL=""
    for bench in "${BENCHMARKS[@]}"
    do
        if [[ "$BENCH_FULL" == "" ]]
        then
            BENCH_FULL="${bench}"
        else
            BENCH_FULL="$BENCH_FULL;${bench}"
        fi
    done
    PLOT_FILE=$DIR/select_plot${OUT_SUFFIX}.pdf
    SELECT_ARGS="$EXTRA_ARGS --spec-graph $SPEC_GRAPH --benchmark $BENCH_FULL --plot $PLOT_FILE"
    # INSTR_BENEFIT_FUNC="speedup_per_instr"
    INSTR_BENEFIT_FUNC="multi_speedup_per_instr"
    # INSTR_BENEFIT_FUNC="util_score_per_instr"
    # INSTR_BENEFIT_FUNC="multi_util_score_per_instr"
    TOTAL_BENEFIT_FUNC="speedup"
    # TOTAL_BENEFIT_FUNC="speedup_per_instr_sum"
    # TOTAL_BENEFIT_FUNC="multi_speedup_per_instr_sum"
    # TOTAL_BENEFIT_FUNC="util_score_per_instr_sum"
    # TOTAL_BENEFIT_FUNC="multi_util_score_per_instr_sum"
    # INSTR_COST_FUNC="enc_weight_per_instr"
    INSTR_COST_FUNC="hls_area_per_instr"
    # TOTAL_COST_FUNC="enc_weight_per_instr_sum"
    TOTAL_COST_FUNC="hls_area_per_instr_sum"
    # STRATEGY="SAME"
    STRATEGY="MAX"
    if [[ "$STRATEGY" == "SAME" ]]  #
    then
        USE_STOP_BENEFIT=1
        USE_MAX_COST=1
    elif [[ "$STRATEGY" == "MAX" ]]
    then
        USE_STOP_BENEFIT=0
        USE_MAX_COST=1
    else
        echo "Unknown STRATEGY: $STRATEGY"
        exit 1

    fi
    if [[ "$USE_STOP_BENEFIT" == "1" ]]
    then
        # python3 $SCRIPTS_DIR/extract_stop_benefit.py ${RUN}_compare_multi${SUFFIX}.csv $DIR/stop_benefit${SUFFIX}.txt
        if [[ ! -f $DIR/stop_benefit.txt ]]
        then
            echo "Missing: $DIR/stop_benefit.txt"
            exit 1
        fi
        STOP_BENEFIT_FACTOR=1.0
        STOP_BENEFIT_BASE=$(cat $DIR/stop_benefit.txt)
        STOP_BENEFIT=$(echo "scale=4; $STOP_BENEFIT_BASE*$STOP_BENEFIT_FACTOR" | bc)
        # echo STOP_BENEFIT=$STOP_BENEFIT
        # read -n 1

        SELECT_ARGS="$SELECT_ARGS --stop-benefit $STOP_BENEFIT"
    fi
    if [[ "$USE_MAX_COST" == "1" ]]
    then
        if [[ "$TOTAL_COST_FUNC" == "enc_weight_sum" ]]
        then
            MAX_COST=0.25
        elif [[ "$TOTAL_COST_FUNC" == "hls_area_per_instr_sum" ]]
        then
            # TODO: need to use final here! (symlink?)
            MULTI_HLS_CSV=$DIR/multi/work/docker/hls/default/hls_selected_schedule_metrics.csv
            if [[ ! -f $MULTI_HLS_CSV ]]
            then
                echo "Missing: $MULTI_HLS_CSV"
                exit 1
            fi
            MAX_COST=$(cat $MULTI_HLS_CSV | tail -n +2 | cut -d, -f13)

        else
            echo "Unhandled TOTAL_COST_FUNC: $TOTAL_COST_FUNC"
            exit 1

        fi
        SELECT_ARGS="$SELECT_ARGS --max-cost $MAX_COST"
    fi
    SELECT_ARGS="$SELECT_ARGS --instr-cost-func $INSTR_COST_FUNC"
    SELECT_ARGS="$SELECT_ARGS --total-cost-func $TOTAL_COST_FUNC"
    SELECT_ARGS="$SELECT_ARGS --instr-benefit-func $INSTR_BENEFIT_FUNC"
    SELECT_ARGS="$SELECT_ARGS --total-benefit-func $TOTAL_BENEFIT_FUNC"
    python3 $SCRIPTS_DIR/selection_algo.py $INDEX_FILE --out $SELECTED_INDEX_FILE --sankey $DIR/sankey_selected${OUT_SUFFIX}.md $SELECT_ARGS
    python3 -m isaac_toolkit.utils.names_helper $SELECTED_INDEX_FILE --output $WORK/names_selected.csv
fi

# compare_0_per_instr;assign_0_compare_per_instr;filter_0;compare_0_filtered;assign_0_compare_filtered;compare_others_0_filtered;assign_0_compare_others_filtered

# trace_multi_0 + reanalyze_multi_0

UTIL_SCORE_ARGS=""
AGG_COUNTS_ARGS=""
for bench in "${BENCHMARKS[@]}"
do
    RUN2=${RUN}_multi/${bench}
    mkdir -p $(dirname $RUN2)

    if [[ "$RETRACE_ENABLE" == 1 ]]
    then
        # TODO: only enable one set per prog?
        if [[ "$MULTI" == "1" ]]
        then
            FULL_ARCH=${ARCH}
            for set_name in ${SET_NAME//;/ }
            do
                set_name_lower=$(echo $set_name | tr '[:upper:]' '[:lower:]')
                FULL_ARCH="${FULL_ARCH}_${set_name_lower}"
            done
        else
            FULL_ARCH=${ARCH}_xisaac
        fi
        python3 -m mlonmcu.cli.main flow run $bench --target $TARGET -c run.export_optional=1 -c $TARGET.abi=$ABI -c mlif.debug_symbols=1 $VERBOSE_ARGS -c mlif.toolchain=llvm -c mlif.unroll_loops=$UNROLL -c mlif.optimize=$OPTIMIZE -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 --label $LABEL-trace2${OUT_SUFFIX} -c etissvp.script=$ETISS_SCRIPT -c etiss.cpu_arch=$ETISS_CORE_NAME -c llvm.install_dir=$LLVM_INSTALL_DIR -c $TARGET.arch=$FULL_ARCH -c mlif.global_isel=$GLOBAL_ISEL $PROGRESS_ARGS
        python3 -m mlonmcu.cli.main export --run -f -- $RUN2
    fi

    SESS2=${SESS}_multi/${bench}
    mkdir -p $(dirname $SESS2)

    if [[ "$REANALYZE_ENABLE" == 1 ]]
    then
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
        # python3 $SCRIPTS_DIR/update_ise_instrs_pkl.py $ISE_INSTRS_PKL_OLD --out $ISE_INSTRS_PKL_NEW --names-csv $NAMES_CSV

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

        python3 $SCRIPTS_DIR/calc_util_score.py --dynamic-counts-custom-pkl $SESS2/table/dynamic_counts_custom.pkl --static-counts-custom-pkl $SESS2/table/dynamic_counts_custom.pkl --out $SESS2/util_score.csv


        # cleanup run dir
        rm -r $RUN2
        # TODO: cleanup instr_trace.pkl?
    fi
    if [[ -f $SESS2/util_score.csv ]]
    then
        UTIL_SCORE_ARGS="$UTIL_SCORE_ARGS $SESS2/util_score.csv"
    fi
    if [[ -f $SESS2/table/dynamic_counts_custom.pkl ]]
    then
        AGG_COUNTS_ARGS="$AGG_COUNTS_ARGS $SESS2/table/dynamic_counts_custom.pkl"
    fi
done


if [[ "$AGG_ENABLE" == "1" && "$UTIL_SCORE_ARGS" != "" ]]
then
    # OUT_DIR=$DIR
    # python3 $SCRIPTS_DIR/analyze_multi_report.py ${RUN}_compare_multi${OUT_SUFFIX}/report.csv --sess-dir ${SESS}_multi/ --names-csv $NAMES_CSV --out $OUT_DIR
    AGG_UTIL_SCORE_CSV=$DIR/agg_util_score.csv
    python3 -m isaac_toolkit.utils.agg_util_scores $UTIL_SCORE_ARGS --out $AGG_UTIL_SCORE_CSV  # --names-csv $NAMES_CSV --out $OUT_DIR
    # python3 -m isaac_toolkit.utils.annotate_util_score $INDEX_FILE --inplace --util-score-csv $AGG_UTIL_SCORE_CSV --out-prefix "multi_"
    python3 -m isaac_toolkit.utils.annotate_util_score $INDEX_FILE --inplace --util-score-csv $AGG_UTIL_SCORE_CSV --out-prefix ""
    # TODO: MULTI!
fi

if [[ "$AGG_ENABLE" == "1" && "$AGG_COUNTS_ARGS" != "" ]]
then
    # OUT_DIR=$DIR
    # python3 $SCRIPTS_DIR/analyze_multi_report.py ${RUN}_compare_multi${OUT_SUFFIX}/report.csv --sess-dir ${SESS}_multi/ --names-csv $NAMES_CSV --out $OUT_DIR
    AGG_COUNTS_CSV=$DIR/agg_counts.csv
    python3 -m isaac_toolkit.utils.agg_counts $AGG_COUNTS_ARGS --out $AGG_COUNTS_CSV  # --names-csv $NAMES_CSV --out $OUT_DIR
    # python3 -m isaac_toolkit.utils.annotate_util_score $INDEX_FILE --inplace --util-score-csv $AGG_UTIL_SCORE_CSV --out-prefix "multi_"
    python3 -m isaac_toolkit.annotate_counts $INDEX_FILE --inplace --counts-csv $AGG_COUNTS_CSV --out-prefix ""
fi


if [[ "$FILTER_ENABLE" == 1 ]]
then
    FILTERED_INDEX_FILE=$DIR/filtered${OUT_SUFFIX}_index.yml
    # MIN_UTIL_SCORE=0.005
    MIN_UTIL_SCORE=0.001
    MIN_ESTIMATED_REDUCTION=0.005
    FILTER_ARGS="--min-util-score ${MIN_UTIL_SCORE} --min-estimated-reduction ${MIN_ESTIMATED_REDUCTION}"
    # TODO: support prefix
    python3 -m isaac_toolkit.utils.filter_index $INDEX_FILE --out $FILTERED_INDEX_FILE $FILTER_ARGS --sankey $DIR/sankey_filtered${OUT_SUFFIX}.md
    python3 -m isaac_toolkit.utils.names_helper $FILTERED_INDEX_FILE --output $WORK/names_filtered.csv
    # TODO: gen
fi


# asip_syn_0

COLLECT_ASIP_ARGS=""
if [[ "$ASIP_SYN_ENABLE" == 1 ]]
then
    if [[ "$ASIP_SYN_SKIP_BASELINE" == 0 ]]
    then
        if [[ "$ASIP_SYN_TOOL" == "synopsys" ]]
        then
            if [[ "$ASIP_SYN_BASELINE_USE" != "" ]]
            then
                if [[ ! -d "$ASIP_SYN_BASELINE_USE" ]]
                then
                    echo "Missing: $ASIP_SYN_BASELINE_USE"
                    exit 1
                fi
                COLLECT_ASIP_ARGS="$COLLECT_ASIP_ARGS --baseline-dir $ASIP_SYN_BASELINE_USE"
            else
                mkdir -p $WORK/docker/asip_syn/baseline/rtl
                cp -r $WORK/docker/hls/baseline/rtl/* $WORK/docker/asip_syn/baseline/rtl
                $SCRIPTS_DIR/asip_syn_script.sh $WORK/docker/asip_syn/baseline/ $WORK/docker/asip_syn/baseline/rtl $ASIP_SYN_SYNOPSYS_CORE_NAME $ASIP_SYN_SYNOPSYS_PDK $ASIP_SYN_SYNOPSYS_CLK_PERIOD $WORK/docker/asip_syn/baseline/constraints.sdc
                COLLECT_ASIP_ARGS="$COLLECT_ASIP_ARGS --baseline-dir $WORK/docker/asip_syn/baseline/"
            fi
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
            cp -r $WORK/docker/hls/default/rtl/* $WORK/docker/asip_syn/default/rtl
            $SCRIPTS_DIR/asip_syn_script.sh $WORK/docker/asip_syn/default $WORK/docker/asip_syn/default/rtl $ASIP_SYN_SYNOPSYS_CORE_NAME $ASIP_SYN_SYNOPSYS_PDK $ASIP_SYN_SYNOPSYS_CLK_PERIOD $WORK/docker/asip_syn/default/constraints.sdc
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
            cp -r $WORK/docker/hls/shared/rtl/* $WORK/docker/asip_syn/shared/rtl
            $SCRIPTS_DIR/asip_syn_script.sh $WORK/docker/asip_syn/shared $WORK/docker/asip_syn/shared/rtl $ASIP_SYN_SYNOPSYS_CORE_NAME $ASIP_SYN_SYNOPSYS_PDK $ASIP_SYN_SYNOPSYS_CLK_PERIOD $WORK/docker/asip_syn/shared/constraints.sdc
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
    python3 $SCRIPTS_DIR/collect_asip_syn_metrics.py $COLLECT_ASIP_ARGS --out $WORK/docker/asip_syn/metrics.csv
fi

# fpga_syn_0

COLLECT_FPGA_ARGS=""
if [[ "$FPGA_SYN_ENABLE" == 1 ]]
then
    if [[ "$FPGA_SYN_SKIP_BASELINE" == 0 ]]
    then
        if [[ "$FPGA_SYN_TOOL" == "vivado" ]]
        then
            if [[ "$FPGA_SYN_BASELINE_USE" != "" ]]
            then
                if [[ ! -d "$FPGA_SYN_BASELINE_USE" ]]
                then
                    echo "Missing: $FPGA_SYN_BASELINE_USE"
                    exit 1
                fi
                COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --baseline-dir $FPGA_SYN_BASELINE_USE"
            else
                $SCRIPTS_DIR/fpga_syn_script.sh $WORK/docker/fpga_syn/baseline/ $WORK/docker/hls/baseline/rtl $FPGA_SYN_VIVADO_CORE_NAME $FPGA_SYN_VIVADO_PART $FPGA_SYN_VIVADO_CLK_PERIOD
                COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --baseline-dir $WORK/docker/fpga_syn/baseline/"
            fi
        else
            echo "Unsupported FPGA_SYN_TOOL: $FPGA_SYN_TOOL"
            exit 1
        fi
    fi
    if [[ "$FPGA_SYN_SKIP_DEFAULT" == 0 ]]
    then
        if [[ "$FPGA_SYN_TOOL" == "vivado" ]]
        then
            $SCRIPTS_DIR/fpga_syn_script.sh $WORK/docker/fpga_syn/default/ $WORK/docker/hls/default/rtl $FPGA_SYN_VIVADO_CORE_NAME $FPGA_SYN_VIVADO_PART $FPGA_SYN_VIVADO_CLK_PERIOD
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
            $SCRIPTS_DIR/fpga_syn_script.sh $WORK/docker/fpga_syn/shared/ $WORK/docker/hls/shared/rtl $FPGA_SYN_VIVADO_CORE_NAME $FPGA_SYN_VIVADO_PART $FPGA_SYN_VIVADO_CLK_PERIOD
            COLLECT_FPGA_ARGS="$COLLECT_FPGA_ARGS --shared-dir $WORK/docker/fpga_syn/shared/"
        else
            echo "Unsupported FPGA_SYN_TOOL: $FPGA_SYN_TOOL"
            exit 1
        fi
    fi
fi

if [[ "$COLLECT_FPGA_ARGS" != "" ]]
then
    python3 $SCRIPTS_DIR/collect_fpga_syn_metrics.py $COLLECT_FPGA_ARGS --out $WORK/docker/fpga_syn/metrics.csv
fi

# assign_0_syn
# ...
