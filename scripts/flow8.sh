#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

WORK=$DIR/work

# TODO: expose
SET_NAME=${ISAAX_SET_NAME:-XIsaac}
# TOOLS_PATH=${TUDA_TOOLS_PATH:-/work/git/tuda/isax-tools-integration5}
TOOLS_PATH=/work/git/tuda/isax-tools-integration-july2025
HLS_IMAGE=${HLS_IMAGE:-philippvk/hls-quickstart:latest}

GUROBI_LIC=${GUROBI_LIC:-""}
HLS_DIR=${HLS_DIR:=/path/to/isax-tools-integration}

# IMAGE=isaac-quickstart-hls:latest
# IMAGE=jhvjkcyyfdxghjk/isax-tools-integration-env

# Load config
HLS_ENABLE=${HLS_ENABLE:-1}
HLS_BASELINE_USE=${HLS_BASELINE_USE:-""}
HLS_DEFAULT_USE=${HLS_DEFAULT_USE:-""}
HLS_SKIP_BASELINE=${HLS_SKIP_BASELINE:-0}
HLS_SKIP_DEFAULT=${HLS_SKIP_DEFAULT:-0}
HLS_SKIP_CUSTOM=${HLS_SKIP_CUSTOM:-0}  # WIP: II>1
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
FILTERED2=${FILTERED2:-0}
SELECTED=${SELECTED:-0}
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
elif [[ "$FILTERED2" == "1" && "$SELECTED" == 1 ]]
then
    GEN_DIR=$WORK/gen_filtered2_selected/
elif [[ "$FILTERED2" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered2/
elif [[ "$FILTERED" == "1" && "$SELECTED" == 1 ]]
then
    GEN_DIR=$WORK/gen_filtered_selected/
elif [[ "$FILTERED" == "1" ]]
then
    GEN_DIR=$WORK/gen_filtered/
else
    GEN_DIR=$WORK/gen/
fi

# CORE_NAME=${ISAAC_CORE_NAME:-XIsaacCore}

if [[ $HLS_TOOL == "nailgun" ]]
then
    if [[ "$USE_HLS_DOCKER" == "1" ]]
    then
        if [[ "$HLS_DOCKER_LEGACY" == "1" ]]
        then
            if [[ ! -d "$TOOLS_PATH" ]]
            then
                echo "Tools path does not exist: $TOOLS_PATH"
                exit 1
            fi
            DEST_DIR=$WORK/docker/hls
        fi
    else
        if [[ ! -d "$HLS_DIR" ]]
        then
            echo "HLS_DIR does not exist: $HLS_DIR"
            exit 1
        fi
            DEST_DIR=$WORK/local/hls
    fi


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
            ISAXES=${set_name_upper}.HLS
        else
            # For 2+ sets the name is always 'merged'
            SET_NAME_OUT=merged
            ISAXES=$ISAXES,${set_name_upper}.HLS
        fi
        # cp $GEN_DIR/$set_name.hls.core_desc $TOOLS_PATH/nailgun/isaxes/$set_name_lower.core_desc  # TODO: do not hardcode
    done
    echo ISAXES=$ISAXES
    # read -n 1
    # TODO: allow running the flow for multiple isaxes in parallel
    mkdir -p $DEST_DIR
    # sudo chmod 777 -R $DEST_DIR


    if [[ $ILP_SOLVER == "GUROBI" ]]
    then
        echo "TODO: CHECK FOR LICENSE"
    fi


    # First get RTL for the baseline core with out isax
    if [[ "$HLS_SKIP_BASELINE" == 0 ]]
    then
        echo BASELINE
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
            # OUTPUT_DIR=$DEST_DIR/baseline/output
            OUTPUT_DIR=$DEST_DIR/baseline/output
            test -d $OUTPUT_DIR && rm -rf $OUTPUT_DIR || :
            mkdir -p $OUTPUT_DIR
            # docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export NP_GIT=$(which git) && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR NO_ISAX=y SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
           HLS_ARGS="SKIP_AWESOME_LLVM=y OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL NO_ISAX=y SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME"
           DOCKER_ENV_ARGS=""
           DOCKER_MOUNT_ARGS="$(pwd):$(pwd)"
           if [[ "$GUROBI_LIC" != "" ]]
           then
               GUROBI_LIC_DIR=$(dirname $GUROBI_LIC)
               DOCKER_MOUNT_ARGS="$DOCKER_MOUNT_ARGS -v $GUROBI_LIC_DIR:$GUROBI_LIC_DIR"
               DOCKER_ENV_ARGS="$DOCKER_ENV_ARGS -e GUROBI_LIC=$GUROBI_LIC"
           fi

           if [[ "$USE_HLS_DOCKER" == "1" ]]
           then
              # python3 -m isaac_toolkit.retargeting.hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME
               if [[ "$HLS_DOCKER_LEGACY" == "1" ]]
               then
                   docker run -i --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export NP_GIT=$(which git) && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR $HLS_ARGS make gen_config ci && chmod 777 -R $OUTPUT_DIR"
              else
                  docker run -i --rm -v $DOCKER_MOUNT_ARGS $DOCKER_ENV_ARGS $HLS_IMAGE $OUTPUT_DIR $GEN_DIR $HLS_ARGS
              fi
           # sudo chmod 777 -R $DEST_DIR
           else
              echo GUROBI_LIC=$GUROBI_LIC HLS_DIR=$HLS_DIR $DOCKER_DIR/hls_script_local.sh $OUTPUT_DIR $GEN_DIR $HLS_ARGS
              GUROBI_LIC=$GUROBI_LIC HLS_DIR=$HLS_DIR $DOCKER_DIR/hls_script_local.sh $OUTPUT_DIR $GEN_DIR $HLS_ARGS
              # HLS_SCRIPT_LOCAL=$DOCKER_DIR/hls_script_local.sh python3 -m isaac_toolkit.retargeting.hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME
           fi
           # sudo chmod 777 -R $DEST_DIR
        fi
        echo "DONE1"

        # TODO: make sure that dir is empty?
        mkdir -p $DEST_DIR/baseline/rtl
        ./scripts/copy_rtl_files.sh $OUTPUT_DIR/$HLS_NAILGUN_CORE_NAME2/files.txt $DEST_DIR/baseline/rtl
        if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
        then
            SDC_PATH=$(ls $OUTPUT_DIR/hw_syn/runs/*/final/sdc/*.sdc)
            echo "SDC_PATH=$SDC_PATH"
            mkdir -p $WORK/docker/asip_syn/baseline
            grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/baseline/constraints.sdc

            # mkdir -p $WORK/docker/asip_syn/baseline/rtl
            # python3 scripts/get_rtl_files.py $DEST_DIR/baseline/output/hw_syn/config.json > $DEST_DIR/baseline/output/hw_syn/files.txt
            # ./scripts/copy_rtl_files.sh $DEST_DIR/baseline/output/hw_syn/files.txt $WORK/docker/asip_syn/baseline/rtl
        fi
    fi

    if [[ "$HLS_SKIP_DEFAULT" == 0 ]]
    then
        echo DEFAULT
        OUTPUT_DIR=$DEST_DIR/default/output
        test -d $OUTPUT_DIR && rm -rf $OUTPUT_DIR || :
        mkdir -p $OUTPUT_DIR
        # docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export NP_GIT=$(which git) && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$DEST_DIR/default/output/.config OUTPUT_PATH=$DEST_DIR/default/output ISAXES=$ISAXES SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
        # read -n 1
        HLS_ARGS="SKIP_AWESOME_LLVM=y OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL SIM_EN=n ISAXES="$ISAXES" CORE=$HLS_NAILGUN_CORE_NAME LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI"
        DOCKER_ENV_ARGS=""
        DOCKER_MOUNT_ARGS="$(pwd):$(pwd)"
        if [[ "$GUROBI_LIC" != "" ]]
        then
            GUROBI_LIC_DIR=$(dirname $GUROBI_LIC)
            DOCKER_MOUNT_ARGS="$DOCKER_MOUNT_ARGS -v $GUROBI_LIC_DIR:$GUROBI_LIC_DIR"
            DOCKER_ENV_ARGS="$DOCKER_ENV_ARGS -e GUROBI_LIC=$GUROBI_LIC"
        fi

        if [[ "$USE_HLS_DOCKER" == "1" ]]
        then
           # python3 -m isaac_toolkit.retargeting.hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME
            if [[ "$HLS_DOCKER_LEGACY" == "1" ]]
            then
                # echo docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export NP_GIT=$(which git) && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR $HLS_ARGS make gen_config ci && chmod 777 -R $OUTPUT_DIR"
                # read -n 1
                docker run -i --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export NP_GIT=$(which git) && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR $HLS_ARGS make gen_config ci && chmod 777 -R $OUTPUT_DIR"
           else
               # echo docker run -it --rm -v $DOCKER_MOUNT_ARGS $DOCKER_ENV_ARGS $HLS_IMAGE $OUTPUT_DIR $GEN_DIR $HLS_ARGS
               # read -n 1
               docker run -i --rm -v $DOCKER_MOUNT_ARGS $DOCKER_ENV_ARGS $HLS_IMAGE $OUTPUT_DIR $GEN_DIR $HLS_ARGS
           fi
        # sudo chmod 777 -R $DEST_DIR
        else
           # echo GUROBI_LIC=$GUROBI_LIC HLS_DIR=$HLS_DIR $DOCKER_DIR/hls_script_local.sh $OUTPUT_DIR $GEN_DIR $HLS_ARGS
           # read -n 1
           GUROBI_LIC=$GUROBI_LIC HLS_DIR=$HLS_DIR $DOCKER_DIR/hls_script_local.sh $OUTPUT_DIR $GEN_DIR $HLS_ARGS
           # HLS_SCRIPT_LOCAL=$DOCKER_DIR/hls_script_local.sh python3 -m isaac_toolkit.retargeting.hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME
        fi
        # sudo chmod 777 -R $DEST_DIR
        echo "DONE2"

        # TODO: make sure that dir is empty?
        mkdir -p $DEST_DIR/default/rtl
        # cp $DEST_DIR/default/output/$HLS_NAILGUN_CORE_NAME/*.v $DEST_DIR/default/rtl/ || :
        # cp $DEST_DIR/default/output/$HLS_NAILGUN_CORE_NAME/*.sv $DEST_DIR/default/rtl/ || :
        cp $DEST_DIR/default/output/ISAX_$SET_NAME_OUT.sv $DEST_DIR/default/rtl/
        ./scripts/copy_rtl_files.sh $DEST_DIR/default/output/$HLS_NAILGUN_CORE_NAME2/files.txt $DEST_DIR/default/rtl
        echo -e "\nISAX_$SET_NAME_OUT.sv" >> $DEST_DIR/default/rtl/files.txt
        (git diff --no-index $DEST_DIR/baseline/rtl $DEST_DIR/default/rtl || : ) > $DEST_DIR/default/rtl.patch
        (git diff --no-index $DEST_DIR/baseline/rtl $DEST_DIR/default/rtl --shortstat || : ) > $DEST_DIR/default/rtl.patch.stat
        # python3 scripts/stat2locs.py $DEST_DIR/default/rtl.patch.stat $DEST_DIR/default/rtl.csv
        if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
        then
            # SDC_PATH=$(ls $DEST_DIR/default/output/hw_syn/runs/*/*-openroad-floorplan/*.sdc)
            SDC_PATH=$(ls $DEST_DIR/default/output/hw_syn/runs/*/final/sdc/*.sdc)
            echo "SDC_PATH=$SDC_PATH"
            mkdir -p $WORK/docker/asip_syn/default
            grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/default/constraints.sdc

            # mkdir -p $WORK/docker/asip_syn/rtl
            # python3 scripts/get_rtl_files.py $DEST_DIR/default/output/hw_syn/config.json > $DEST_DIR/default/output/hw_syn/files.txt
            # ./scripts/copy_rtl_files.sh $DEST_DIR/default/output/hw_syn/files.txt $WORK/docker/asip_syn/rtl
        fi


        python3 scripts/collect_hls_metrics.py $DEST_DIR/default/output --output $DEST_DIR/default/hls_metrics.csv --print
        python3 scripts/parse_kconfig.py $DEST_DIR/default/output/Kconfig $DEST_DIR/default/hls_schedules.csv
        python3 scripts/get_selected_schedule_metrics.py $DEST_DIR/default/hls_schedules.csv $DEST_DIR/default/output/selected_solutions.yaml $DEST_DIR/default/hls_selected_schedule_metrics.csv
    fi

    if [[ "$HLS_SKIP_CUSTOM" == 0 ]]
    then
        echo CUSTOM
        if [[ "$HLS_DEFAULT_USE" != "" ]]
        then
            if [[ ! -d "$HLS_DEFAULT_USE" ]]
            then
                echo "Missing: $HLS_DEFAULT_USE"
                exit 1
            fi
            SCHEDULES_CSV=$HLS_DEFAULT_USE/hls_schedules.csv
        else
            SCHEDULES_CSV=$DEST_DIR/default/hls_schedules.csv
        fi
        if [[ ! -f "$SCHEDULES_CSV" ]]
        then
            echo "Missing: $SCHEDULES_CSV"
            exit 1
        fi
        OUTPUT_DIR=$DEST_DIR/custom/output
        test -d $OUTPUT_DIR && rm -rf $OUTPUT_DIR || :
        mkdir -p $OUTPUT_DIR
        SELECTED_SOLUTIONS_YAML=$DEST_DIR/custom/output/selected_solutions.yaml
        python3 scripts/select_hls_schedules.py $SCHEDULES_CSV --output $SELECTED_SOLUTIONS_YAML --prefer-ii 2 3 4 5 6 7 8 1

        # docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export NP_GIT=$(which git) && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$DEST_DIR/custom/output/.config OUTPUT_PATH=$DEST_DIR/custom/output ISAXES=$ISAXES SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL LN_PREDEFINED_SOLUTION_SELECTION=$SELECTED_SOLUTIONS_YAML make gen_config ci"
        HLS_ARGS="SKIP_AWESOME_LLVM=y OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL SIM_EN=n ISAXES="$ISAXES" CORE=$HLS_NAILGUN_CORE_NAME LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI LN_PREDEFINED_SOLUTION_SELECTION=$SELECTED_SOLUTIONS_YAML"
        # TODO: update args
        DOCKER_ENV_ARGS=""
        DOCKER_MOUNT_ARGS="$(pwd):$(pwd)"
        if [[ "$GUROBI_LIC" != "" ]]
        then
            GUROBI_LIC_DIR=$(dirname $GUROBI_LIC)
            DOCKER_MOUNT_ARGS="$DOCKER_MOUNT_ARGS -v $GUROBI_LIC_DIR:$GUROBI_LIC_DIR"
            DOCKER_ENV_ARGS="$DOCKER_ENV_ARGS -e GUROBI_LIC=$GUROBI_LIC"
        fi

        if [[ "$USE_HLS_DOCKER" == "1" ]]
        then
           # python3 -m isaac_toolkit.retargeting.hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME
            if [[ "$HLS_DOCKER_LEGACY" == "1" ]]
            then
                docker run -i --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export NP_GIT=$(which git) && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR $HLS_ARGS make gen_config ci && chmod 777 -R $OUTPUT_DIR"
           else
               docker run -i --rm -v $DOCKER_MOUNT_ARGS $DOCKER_ENV_ARGS $HLS_IMAGE $OUTPUT_DIR $GEN_DIR $HLS_ARGS
           fi
        # sudo chmod 777 -R $DEST_DIR
        else
           GUROBI_LIC=$GUROBI_LIC HLS_DIR=$HLS_DIR $DOCKER_DIR/hls_script_local.sh $OUTPUT_DIR $GEN_DIR $HLS_ARGS
           # HLS_SCRIPT_LOCAL=$DOCKER_DIR/hls_script_local.sh python3 -m isaac_toolkit.retargeting.hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME
        fi
        # sudo chmod 777 -R $DEST_DIR

        # TODO: make sure that dir is empty?
        mkdir -p $DEST_DIR/custom/rtl
        # cp $DEST_DIR/custom/output/$HLS_NAILGUN_CORE_NAME/*.v $DEST_DIR/custom/rtl/ || :
        # cp $DEST_DIR/custom/output/$HLS_NAILGUN_CORE_NAME/*.sv $DEST_DIR/custom/rtl/ || :
        cp $DEST_DIR/custom/output/ISAX_$SET_NAME_OUT.sv $DEST_DIR/custom/rtl/
        ./scripts/copy_rtl_files.sh $DEST_DIR/custom/output/$HLS_NAILGUN_CORE_NAME2/files.txt $DEST_DIR/custom/rtl
        echo -e "\nISAX_$SET_NAME_OUT.sv" >> $DEST_DIR/custom/rtl/files.txt
        (git diff --no-index $DEST_DIR/baseline/rtl $DEST_DIR/custom/rtl || : ) > $DEST_DIR/custom/rtl.patch
        (git diff --no-index $DEST_DIR/baseline/rtl $DEST_DIR/custom/rtl --shortstat || : ) > $DEST_DIR/custom/rtl.patch.stat
        # python3 scripts/stat2locs.py $DEST_DIR/custom/rtl.patch.stat $DEST_DIR/custom/rtl.csv
        if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
        then
            # SDC_PATH=$(ls $DEST_DIR/custom/output/hw_syn/runs/*/*-openroad-floorplan/*.sdc)
            SDC_PATH=$(ls $DEST_DIR/custom/output/hw_syn/runs/*/final/sdc/*.sdc)
            echo "SDC_PATH=$SDC_PATH"
            mkdir -p $WORK/docker/asip_syn/custom
            grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/custom/constraints.sdc

            # mkdir -p $WORK/docker/asip_syn/rtl
            # python3 scripts/get_rtl_files.py $DEST_DIR/custom/output/hw_syn/config.json > $DEST_DIR/custom/output/hw_syn/files.txt
            # ./scripts/copy_rtl_files.sh $DEST_DIR/custom/output/hw_syn/files.txt $WORK/docker/asip_syn/rtl
        fi


        python3 scripts/collect_hls_metrics.py $DEST_DIR/custom/output --output $DEST_DIR/custom/hls_metrics.csv --print
        python3 scripts/parse_kconfig.py $DEST_DIR/custom/output/Kconfig $DEST_DIR/custom/hls_schedules.csv
        python3 scripts/get_selected_schedule_metrics.py $DEST_DIR/custom/hls_schedules.csv $DEST_DIR/custom/output/selected_solutions.yaml $DEST_DIR/custom/hls_selected_schedule_metrics.csv
        # TODO: CUSTOM_SHARED?
    fi

    if [[ "$HLS_SKIP_SHARED" == 0 && $HLS_NAILGUN_SHARE_RESOURCES == "1" ]]
    then
        echo SHARED
        OUTPUT_DIR=$DEST_DIR/shared/output
        test -d $OUTPUT_DIR && rm -rf $OUTPUT_DIR || :
        mkdir -p $OUTPUT_DIR
        sed -e "s/lil.enc_immediates/lil.sharing_group = 1, lil.enc_immediates/g" $DEST_DIR/default/output/mlir/ISAX_XISAAC.HLS_EN.mlir > $DEST_DIR/ISAX_XISAAC.HLS_EN.mlir
        # docker run -it --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export NP_GIT=$(which git) && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$DEST_DIR/shared/output/.config OUTPUT_PATH=$DEST_DIR/shared/output SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME SKIP_AWESOME_LLVM=y LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI MLIR_ENTRY_POINT_PATH=$DEST_DIR/ISAX_XISAAC_EN_shared.mlir OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL make gen_config ci"
        HLS_ARGS="SKIP_AWESOME_LLVM=y OL2_ENABLE=$HLS_NAILGUN_OL2_ENABLE OL2_CONFIG_TEMPLATE=$HLS_NAILGUN_OL2_CONFIG_TEMPLATE OL2_UNTIL_STEP=$HLS_NAILGUN_OL2_UNTIL_STEP OL2_TARGET_FREQ=$HLS_NAILGUN_OL2_TARGET_FREQ OL2_TARGET_UTIL=$HLS_NAILGUN_OL2_TARGET_UTIL SIM_EN=n CORE=$HLS_NAILGUN_CORE_NAME LN_ILP_SOLVER=$HLS_NAILGUN_ILP_SOLVER USE_OL2_MODEL=$USE_OL2_MODEL CELL_LIBRARY=$HLS_NAILGUN_CELL_LIBRARY CLOCK_TIME=$HLS_NAILGUN_CLOCK_NS SCHEDULE_TIMEOUT=$HLS_NAILGUN_SCHEDULE_TIMEOUT REFINE_TIMEOUT=$HLS_NAILGUN_REFINE_TIMEOUT SCHED_ALGO_MS=$HLS_NAILGUN_SCHED_ALGO_MS SCHED_ALGO_PA=$HLS_NAILGUN_SCHED_ALGO_PA SCHED_ALGO_RA=$HLS_NAILGUN_SCHED_ALGO_RA SCHED_ALGO_MI=$HLS_NAILGUN_SCHED_ALGO_MI MLIR_ENTRY_POINT_PATH=$DEST_DIR/ISAX_XISAAC.HLS_EN.mlir"
        DOCKER_ENV_ARGS=""
        DOCKER_MOUNT_ARGS="$(pwd):$(pwd)"
        if [[ "$GUROBI_LIC" != "" ]]
        then
            GUROBI_LIC_DIR=$(dirname $GUROBI_LIC)
            DOCKER_MOUNT_ARGS="$DOCKER_MOUNT_ARGS -v $GUROBI_LIC_DIR:$GUROBI_LIC_DIR"
            DOCKER_ENV_ARGS="$DOCKER_ENV_ARGS -e GUROBI_LIC=$GUROBI_LIC"
        fi

        if [[ "$USE_HLS_DOCKER" == "1" ]]
        then
           # python3 -m isaac_toolkit.retargeting.hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME
            if [[ "$HLS_DOCKER_LEGACY" == "1" ]]
            then
                docker run -i --rm -v $TOOLS_PATH:/isax-tools -v $(pwd):$(pwd) $HLS_IMAGE "date && cd /isax-tools/nailgun && export NP_GIT=$(which git) && export GRB_LICENSE_FILE=/isax-tools/gurobi.lic && CONFIG_PATH=$OUTPUT_DIR/.config OUTPUT_PATH=$OUTPUT_DIR $HLS_ARGS make gen_config ci && chmod 777 -R $OUTPUT_DIR"
           else
               docker run -i --rm -v $DOCKER_MOUNT_ARGS $DOCKER_ENV_ARGS $HLS_IMAGE $OUTPUT_DIR $GEN_DIR $HLS_ARGS
           fi
        # sudo chmod 777 -R $DEST_DIR
        else
           GUROBI_LIC=$GUROBI_LIC HLS_DIR=$HLS_DIR $DOCKER_DIR/hls_script_local.sh $OUTPUT_DIR $GEN_DIR $HLS_ARGS
           # HLS_SCRIPT_LOCAL=$DOCKER_DIR/hls_script_local.sh python3 -m isaac_toolkit.retargeting.hls --sess $SESS --workdir $WORK --set-name $SET_NAME --docker --core $HLS_NAILGUN_CORE_NAME
        fi
        # sudo chmod 777 -R $DEST_DIR

        # TODO: make sure that dir is empty?
        mkdir -p $DEST_DIR/shared/rtl
        cp $DEST_DIR/shared/output/ISAX_$SET_NAME_OUT.sv $DEST_DIR/shared/rtl/
        ./scripts/copy_rtl_files.sh $DEST_DIR/shared/output/$HLS_NAILGUN_CORE_NAME2/files.txt $DEST_DIR/shared/rtl
        echo -e "\nISAX_$SET_NAME_OUT.sv" >> $DEST_DIR/shared/rtl/files.txt
        (git diff --no-index $DEST_DIR/baseline/rtl $DEST_DIR/shared/rtl || : )> $DEST_DIR/shared/rtl.patch
        (git diff --no-index $DEST_DIR/baseline/rtl $DEST_DIR/shared/rtl --shortstat || : ) > $DEST_DIR/shared/rtl.patch.stat
        # python3 scripts/stat2locs.py $DEST_DIR/shared/rtl.patch.stat $DEST_DIR/shared/rtl.csv
        if [[ "$HLS_NAILGUN_OL2_ENABLE" == "y" ]]
        then
            # SDC_PATH=$(ls $DEST_DIR/shared/output/hw_syn/runs/*/*-openroad-floorplan/*.sdc)
            SDC_PATH=$(ls $DEST_DIR/shared/output/hw_syn/runs/*/final/sdc/*.sdc)
            echo "SDC_PATH=$SDC_PATH"
            mkdir -p $WORK/docker/asip_syn/shared
            grep -v "set_driving_cell" $SDC_PATH > $WORK/docker/asip_syn/shared/constraints.sdc

            # mkdir -p $WORK/docker/asip_syn/shared/rtl
            # python3 scripts/get_rtl_files.py $DEST_DIR/shared/output/hw_syn/config.json > $DEST_DIR/shared/output/hw_syn/files.txt
            # ./scripts/copy_rtl_files.sh $DEST_DIR/shared/output/hw_syn/files.txt $WORK/docker/asip_syn/shared/rtl
        fi

        python3 scripts/collect_hls_metrics.py $DEST_DIR/shared/output --output $DEST_DIR/shared/hls_metrics.csv --print
        python3 scripts/parse_kconfig.py $DEST_DIR/shared/output/Kconfig $DEST_DIR/shared/hls_schedules.csv
        python3 scripts/get_selected_schedule_metrics.py $DEST_DIR/shared/hls_schedules.csv $DEST_DIR/shared/output/selected_solutions.yaml $DEST_DIR/shared/hls_selected_schedule_metrics.csv
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
if [[ -f $DEST_DIR/default/hls_metrics.csv ]]
then
    ARGS="$ARGS --hls-metrics-csv $DEST_DIR/default/hls_metrics.csv"
fi
python3 scripts/locs_helper.py $ARGS --output $WORK/combined_locs.csv
if [[ "$USER" == "root" ]]
then
    chmod 777 -R $DEST_DIR
else
    sudo chmod 777 -R $DEST_DIR
fi
