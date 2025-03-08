set ROOT_PATH      $env(ROOT_PATH)
# set DESIGN_RTL_DIR $ROOT_PATH/rtl
# set RISCV_PATH     $ROOT_PATH
# set LONGNAIL_RTL_DIR /work/git/isaac-demo/out/nettle-aes/20241111T162222/work/docker/hls/syn_dir/prj_LEGACY_50.00000000000001ns_55.0%/src/
set LONGNAIL_RTL_DIR $env(LONGNAIL_RTL_DIR)
# set CONSTRAINTS_FILE $ROOT_PATH/constraints/top.sdc
set CONSTRAINTS_FILE $env(CONSTRAINTS_FILE)
set GATE_PATH      $env(OUT_DIR)
set LOG_PATH       $env(LOG_DIR)
set TECHLIB_PATH   $env(TECHLIB_PATH)
set TOPLEVEL       top

set_app_var template_naming_style    "%s"
set_app_var template_parameter_style ""


# ------------------------------------------------------------------------------- #
# Libraries, Design Sources                                                       #
# ------------------------------------------------------------------------------- #

# set search_path [ join "$RISCV_PATH/rtl/include $search_path" ]
set search_path [ join "$TECHLIB_PATH $search_path" ]

set synthetic_library dw_foundation.sldb
source $ROOT_PATH/NangateOpenCell.dc_setup_synthesis.tcl
set link_library [list $target_library $synthetic_library]

# analyze -format sverilog -work work ${TECHLIB_PATH}/NangateOpenCellLibrary_cv32e40p_clock_gate.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/include/cv32e40p_apu_core_pkg.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/include/cv32e40p_fpu_pkg.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/include/cv32e40p_pkg.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_if_stage.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_cs_registers.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_register_file_decoder.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_register_file_encoder.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_register_file_ff.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_register_file_ft.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_load_store_unit.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_id_stage.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_aligner.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_aligner_ft.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_voter.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_decoder.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_decoder_ft.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_compressed_decoder.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_compressed_decoder_ft.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_fifo.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_prefetch_buffer.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_prefetch_buffer_ft.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_hwloop_regs.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_mult.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_mult_ft.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_int_controller.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_ex_stage.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_alu_div.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_alu.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_alu_ft.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_ff_one.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_popcnt.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_apu_disp.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_controller.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_controller_ft.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_obi_interface.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_prefetch_controller.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_sleep_unit.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_core.sv
# analyze -format sverilog -work work ${DESIGN_RTL_DIR}/cv32e40p_top.sv
analyze -format sverilog -work work ${LONGNAIL_RTL_DIR}/CommonLogicModule.sv
analyze -format sverilog -work work ${LONGNAIL_RTL_DIR}/ISAX_XIsaac.sv
analyze -format sverilog -work work ${LONGNAIL_RTL_DIR}/VexRiscv.v
analyze -format sverilog -work work ${LONGNAIL_RTL_DIR}/Vex_top.sv



# ------------------------------------------------------------------------------- #
# Standalone configuration                                                        #
# ------------------------------------------------------------------------------- #
# set COREV_PULP       0
# set COREV_CLUSTER    0
# set FPU              0
# set FPU_ADDMUL_LAT   0
# set FPU_OTHERS_LAT   0
# set ZFINX            0
# set NUM_MHPMCOUNTERS 1
#
# set PARAMETERS "COREV_PULP=${COREV_PULP},
# COREV_CLUSTER=${COREV_CLUSTER},
# FPU=${FPU},
# FPU_ADDMUL_LAT=${FPU_ADDMUL_LAT},
# FPU_OTHERS_LAT=${FPU_OTHERS_LAT},
# ZFINX=${ZFINX},
# NUM_MHPMCOUNTERS=${NUM_MHPMCOUNTERS}"


# ------------------------------------------------------------------------------- #
#  Elaborate, Clocks & Delays                                                     #
# ------------------------------------------------------------------------------- #

# elaborate $TOPLEVEL -work work -parameters $PARAMETERS
elaborate $TOPLEVEL -work work
link
uniquify
check_design

# source $ROOT_PATH/constraints/cv32e40p_core.sdc
# source $ROOT_PATH/constraints/top.sdc
source $CONSTRAINTS_FILE

set_operating_conditions $OPER_COND

# ------------------------------------------------------------------------------- #
#  Compile and Export                                                             #
# ------------------------------------------------------------------------------- #
set uniquify_naming_style "%s_%d"
uniquify -force

#-gate_clock -no_boundary_optimization -timing
#set_dont_touch core_i/pc_id
# set_dont_touch core_i/if_stage_i/prefetch_buffer_i/prefetch_buffer_i_0/instr_req_o
# set_dont_touch core_i/if_stage_i/prefetch_buffer_i/prefetch_buffer_i_1/instr_req_o
# set_dont_touch core_i/if_stage_i/prefetch_buffer_i/prefetch_buffer_i_2/instr_req_o
compile_ultra -no_autoungroup

report_timing > ${LOG_PATH}/report_timing.log
report_area -hierarchy > ${LOG_PATH}/report_area_hier.log
change_names -hierarchy -rules verilog
write -hierarchy -format verilog -output "${GATE_PATH}/${TOPLEVEL}.v"
write -hierarchy -format ddc     -output "${GATE_PATH}/${TOPLEVEL}.ddc"
write_sdf        -version 3.0            "${GATE_PATH}/${TOPLEVEL}.sdf"
write_sdc                                "${GATE_PATH}/${TOPLEVEL}.sdc"

# ------------------------------------------------------------------------------- #
#  TestMAX Compliance                                                             #
# ------------------------------------------------------------------------------- #
write_test_protocol              -output "${GATE_PATH}/${TOPLEVEL}.spf"
write_tmax_library               -path "${GATE_PATH}"

quit
