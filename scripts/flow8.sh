#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

WORK=$DIR/work

# TODO: expose
SET_NAME=${ISAAX_SET_NAME:-XIsaac}

ISAXES=ISAAC

# IMAGE=isaac-quickstart-hls:latest
# IMAGE=jhvjkcyyfdxghjk/isax-tools-integration-env
IMAGE=isax-tools-integration-env:latest
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
    docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $IMAGE "date && cd /isax-tools/nailgun && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$WORK/docker/hls/baseline/output/.config OUTPUT_PATH=$WORK/docker/hls/baseline/output NO_ISAX=y SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
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
        docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $IMAGE "date && cd /isax-tools/nailgun && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$WORK/docker/hls/default/output/.config OUTPUT_PATH=$WORK/docker/hls/default/output ISAXES=$ISAXES SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
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
        docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $IMAGE "date && cd /isax-tools/nailgun && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$WORK/docker/hls/shared/output/.config OUTPUT_PATH=$WORK/docker/hls/shared/output SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI MLIR_ENTRY_POINT_PATH=$WORK/docker/hls/ISAX_ISAAC_EN_shared.mlir OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
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
# NEW:
# python3 -m isaac_toolkit.retargeting.hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME

ARGS=""
if [[ -f $WORK/docker/seal5_reports/diff.csv ]]
then
    ARGS="$ARGS --seal5-diff-csv $WORK/docker/seal5_reports/diff.csv"
fi
if [[ -f $WORK/docker/etiss_patch.stat ]]
then
    ARGS="$ARGS --etiss-patch-stat $WORK/docker/etiss_patch.stat"
fi
if [[ -f $WORK/docker/hls/default/hls_metrics.csv ]]
then
    ARGS="$ARGS --hls-metrics-csv $WORK/docker/hls/default/hls_metrics.csv"
fi
python3 scripts/locs_helper.py $ARGS --output $WORK/combined_locs.csv
sudo chmod 777 -R $WORK/docker/hls
