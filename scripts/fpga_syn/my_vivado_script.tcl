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
] [get_ips blk_mem_gen_0]

# Generate the IP
generate_target all [get_ips blk_mem_gen_0]

# Update the IP catalog
update_ip_catalog

# Compile the IP if not already done
synth_ip [get_ips blk_mem_gen_0]


# Add the IP to the project
# add_files -norecurse blk_mem_gen_0/blk_mem_gen_0.xci
add_files -norecurse [get_files blk_mem_gen_0.xci]

# add_files -force {.}
set file_handle [open ${FILES_TXT} r]
set file_list [read $file_handle]
close $file_handle

set parent_dir [file dirname ${FILES_TXT}]

# Iterate through each file and analyze it
foreach file [split $file_list "\n"] {
    # Skip empty lines
    if {[string length $file] == 0} {
        continue
    }
    puts "Adding file: $parent_dir/$file"
    add_files -force $parent_dir/$file
}

# add_files -force {blk_mem_gen_0.xci}
set_property top cva5_top [current_fileset]
update_compile_order -fileset sources_1

# create_clock -period 10.000 -name clk -waveform {0 5} [get_ports clk]
# write_xdc ./constraints.xdc
read_xdc ${CONSTRAINTS_FILE}
synth_design -top ${TOPLEVEL} -part ${PART}
report_utilization -file reports/utilization_synth.rpt
report_utilization -hierarchical -file reports/utilization_hier_synth.rpt

opt_design

place_design
route_design

report_utilization -file reports/utilization_impl.rpt

report_timing_summary -file reports/timing_summary.rpt
report_timing -file reports/timing_details.rpt

report_power -file reports/power_estimate.rpt

report_utilization -hierarchical -file reports/utilization_hier_impl.rpt

close_project -delete
