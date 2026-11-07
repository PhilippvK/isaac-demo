set_param general.maxThreads 4
open_checkpoint synthesized.dcp
opt_design
place_design
route_design
report_utilization -file reports/utilization_impl.rpt
report_utilization -hierarchical -file reports/utilization_hier_impl.rpt
report_timing_summary -file reports/timing_impl.rpt
report_timing -max_paths 10 -file reports/timing_paths_impl.rpt
report_drc -file reports/drc_impl.rpt
write_checkpoint -force routed.dcp
