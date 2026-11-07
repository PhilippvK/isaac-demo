set_param general.maxThreads 4
set PART xc7a100tcsg324-1
set TOPLEVEL cva5_arty_top
set env(FPGA_SYN_BOARD) arty_a7_100
open_project vivado/CVA5IP/CVA5IP.xpr
set old [get_files -all *scaiev_glue.sv]
if {[llength $old] != 1} {error "Expected one glue source: $old"}
remove_files $old
add_files -norecurse [file normalize board_rtl/scaiev_glue.sv]
update_compile_order -fileset sources_1
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
