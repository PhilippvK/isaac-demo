set_param general.maxThreads 4
open_checkpoint ../branches-packed/synthesized.dcp
set clk [get_nets -quiet clk20]
if {[llength $clk] != 1} {error "Missing core clock: $clk"}
set probe_pc {}; set probe_oldest {}
for {set bit 2} {$bit < 32} {incr bit} {
 foreach {signal variable} {core_RdPC_2_to_scal probe_pc oldest_pc probe_oldest} {
  set name [format {cpu/cva5/cva5_wrapper/cva5/%s[%d]} $signal $bit]
  set net [get_nets -quiet -hierarchical -filter [format {NAME == "%s"} $name]]
  if {[llength $net] != 1} {error "Expected one net for $name: $net"}
  lappend $variable [lindex $net 0]
 }
}
set p0 [get_nets -quiet -hierarchical -filter {NAME =~ *core_WrPC_validReq_2_from_scal}]
set p1 [get_nets -quiet -hierarchical -filter {NAME =~ *fetch_wrPCValid}]
if {![llength $p0] || ![llength $p1]} {error "Missing redirect flags: $p0 / $p1"}
set probe_flags [list [lindex $p0 0] [lindex $p1 0]]
create_debug_core isaac_ila ila
set_property C_DATA_DEPTH 1024 [get_debug_cores isaac_ila]
set_property port_width 30 [get_debug_ports isaac_ila/probe0]
connect_debug_port isaac_ila/clk $clk
connect_debug_port isaac_ila/probe0 $probe_pc
create_debug_port isaac_ila probe
set_property port_width 30 [get_debug_ports isaac_ila/probe1]
connect_debug_port isaac_ila/probe1 $probe_oldest
create_debug_port isaac_ila probe
set_property port_width 2 [get_debug_ports isaac_ila/probe2]
connect_debug_port isaac_ila/probe2 $probe_flags
set hub [get_debug_cores -quiet dbg_hub]
if {[llength $hub]} {
 set_property C_CLK_INPUT_FREQ_HZ 100000000 $hub
 connect_debug_port dbg_hub/clk [get_nets clk_feedback_buf]
}
opt_design
place_design
route_design
report_utilization -file utilization.rpt
report_timing_summary -file timing.rpt
report_drc -file drc.rpt
write_checkpoint -force routed.dcp
write_debug_probes -force debug.ltx
write_bitstream -force debug.bit
