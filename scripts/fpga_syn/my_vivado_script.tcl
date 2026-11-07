set_param general.maxThreads 4
set ROOT_PATH      $env(ROOT_PATH)
set FILES_TXT $env(FILES_TXT)
set CONSTRAINTS_FILE $env(CONSTRAINTS_FILE)
set TOPLEVEL       $env(TOPLEVEL)
set PART       $env(PART)

create_project -force -part ${PART} CVA5IP ./vivado/CVA5IP

# Create Block Memory Generator IP
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 \
          -module_name blk_mem_gen_0

# Configure the IP
set_property -dict [list \
    CONFIG.Memory_Type {Single_Port_RAM} \
    CONFIG.Write_Width_A {32} \
    CONFIG.Write_Depth_A {65536} \
    CONFIG.Use_Byte_Write_Enable {true} \
    CONFIG.Byte_Size {8} \
    CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
    CONFIG.Register_PortA_Output_of_Memory_Core {false} \
    CONFIG.Operating_Mode_A {WRITE_FIRST} \
] [get_ips blk_mem_gen_0]

if {[info exists env(FPGA_SYN_INIT_COE)] && $env(FPGA_SYN_INIT_COE) ne ""} {
    set_property -dict [list CONFIG.Load_Init_File true CONFIG.Coe_File [file normalize $env(FPGA_SYN_INIT_COE)]] [get_ips blk_mem_gen_0]
}

# Generate the IP
generate_target all [get_ips blk_mem_gen_0]

# Update the IP catalog
update_ip_catalog

# Compile the IP if not already done
synth_ip [get_ips blk_mem_gen_0]


# Add the IP to the project
# add_files -norecurse blk_mem_gen_0/blk_mem_gen_0.xci
# create_ip already adds the XCI to the project.

# add_files -force {.}
set file_handle [open ${FILES_TXT} r]
set file_list [read $file_handle]
close $file_handle

set parent_dir [file dirname ${FILES_TXT}]

set rtl_files {}
# Iterate through each file and analyze it
foreach file [split $file_list "\n"] {
    # Skip empty lines
    if {[string length $file] == 0} {
        continue
    }
    set file [string trim $file]
    if {[file pathtype $file] ne "absolute"} {set file [file join $parent_dir $file]}
    if {[info exists env(FPGA_SYN_BOARD)] && $env(FPGA_SYN_BOARD) eq "arty_a7_100" && [file tail $file] eq "CVA5_top.v"} {
        set adapted [file normalize board_rtl/CVA5_top.v]
        exec python3 [file join $ROOT_PATH fpga_syn boards arty_a7_100 prepare_top.py] $file $adapted
        set file $adapted
    }
    if {[info exists env(FPGA_SYN_BOARD)] && $env(FPGA_SYN_BOARD) eq "arty_a7_100" && [file tail $file] eq "scaiev_unit.sv"} {
        set adapted [file normalize board_rtl/scaiev_unit.sv]
        exec python3 [file join $ROOT_PATH fpga_syn boards arty_a7_100 prepare_scaiev.py] $file $adapted
        set file $adapted
    }
    lappend rtl_files $file
}

# add_files -force {blk_mem_gen_0.xci}
add_files -force $rtl_files
if {[info exists env(FPGA_SYN_BOARD)] && $env(FPGA_SYN_BOARD) eq "arty_a7_100"} {
    # The shell terminates cache AXI because this configuration disables caches.
    set config_file [lsearch -inline -glob $rtl_files */cva5_config.sv]
    set fh [open $config_file r]; set config [read $fh]; close $fh
    foreach option {INCLUDE_ICACHE INCLUDE_DCACHE INCLUDE_IBUS} {
        if {![regexp "${option}\\s*:\\s*0" $config]} {error "Arty shell requires $option disabled"}
    }
    source [file join $ROOT_PATH fpga_syn boards arty_a7_100 setup.tcl]
}
set_property top ${TOPLEVEL} [current_fileset]
update_compile_order -fileset sources_1

# create_clock -period 10.000 -name clk -waveform {0 5} [get_ports clk]
# write_xdc ./constraints.xdc
read_xdc ${CONSTRAINTS_FILE}
synth_design -top ${TOPLEVEL} -part ${PART}
report_utilization -file reports/utilization_synth.rpt
report_utilization -hierarchical -file reports/utilization_hier_synth.rpt
if {[llength [get_cells -quiet -hierarchical -filter {IS_BLACKBOX == 1}]]} {
    error "Unresolved black boxes after synthesis"
}
write_checkpoint -force synthesized.dcp

opt_design

place_design
route_design

report_utilization -file reports/utilization_impl.rpt

report_timing_summary -file reports/timing_summary.rpt
report_timing -file reports/timing_details.rpt

report_power -file reports/power_estimate.rpt

report_utilization -hierarchical -file reports/utilization_hier_impl.rpt

report_drc -file reports/drc_impl.rpt
write_checkpoint -force routed.dcp
if {[info exists env(FPGA_SYN_BOARD)] && $env(FPGA_SYN_BOARD) eq "arty_a7_100"} {
    write_bitstream -force cva5_arty_top.bit
}
close_project
