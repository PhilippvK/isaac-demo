# Core-only standard-cell synthesis; no board shell or external RAM.
if {[catch {
    define_design_lib WORK -path ./work
    set_app_var target_library [list $env(ASIP_DB)]
    set_app_var synthetic_library dw_foundation.sldb
    set_app_var link_library [concat "*" $target_library $synthetic_library]
    set_app_var search_path [concat [file dirname $env(ASIP_DB)] $search_path]
    set handle [open $env(ASIP_SOURCES) r]
    set sources [split [read $handle] "\n"]
    close $handle
    foreach source $sources {
        if {$source ne "" && ![analyze -format sverilog -library WORK $source]} {
            error "Analysis failed: $source"
        }
    }
    if {![elaborate $env(TOPLEVEL) -library WORK]} {error "Elaboration failed"}
    current_design $env(TOPLEVEL)
    if {![link]} {error "Unresolved RTL/library references"}
    uniquify
    if {![check_design]} {error "Pre-synthesis design check failed"}
    redirect -file log/units.rpt {report_units}
    source $env(ASIP_CONSTRAINTS)
    if {[info exists env(ASIP_DONT_USE)] && $env(ASIP_DONT_USE) ne ""} {
        foreach pattern [split $env(ASIP_DONT_USE)] {
            set cells [get_lib_cells -quiet $pattern]
            if {[sizeof_collection $cells]} {set_dont_use $cells}
        }
    }
    set_host_options -max_cores $env(ASIP_JOBS)
    set_cost_priority -delay
    compile_ultra -timing_high_effort_script
    compile_ultra -incremental
    if {![check_design]} {error "Post-synthesis design check failed"}
    write -hierarchy -format ddc -output out/mapped.ddc
    redirect -file log/check_timing.rpt {check_timing}
    redirect -file log/report_timing.log {report_timing -significant_digits 10 -max_paths 10}
    redirect -file log/report_area_hier.log {report_area -hierarchy}
    redirect -file log/qor.rpt {report_qor}
    redirect -file log/constraints.rpt {report_constraint -all_violators}
    redirect -file log/references.rpt {report_reference -hierarchy}
    redirect -file log/power.rpt {report_power}
    set paths [get_timing_paths -delay_type max -max_paths 1]
    if {![sizeof_collection $paths]} {error "No constrained timing paths"}
    set slack [get_attribute $paths slack]
    set area [get_attribute [current_design] area]
    set handle [open metrics.json w]
    puts $handle "{\"cell_area\": $area, \"clock_period_ns\": $env(CLOCK_PERIOD), \"setup_slack_ns\": $slack}"
    close $handle
    change_names -hierarchy -rules verilog
    write -hierarchy -format verilog -output out/$env(TOPLEVEL).v
    write -hierarchy -format ddc -output out/$env(TOPLEVEL).ddc
    write_sdf -version 3.0 out/$env(TOPLEVEL).sdf
    write_sdc out/$env(TOPLEVEL).sdc
} message]} {
    puts stderr "ASIP_SYNTHESIS_FAILED: $message"
    exit 1
}
puts "ASIP_SYNTHESIS_COMPLETE"
exit 0
