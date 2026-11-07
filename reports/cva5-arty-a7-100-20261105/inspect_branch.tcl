open_checkpoint builds/branches-fixed/synthesized.dcp
set nets [get_nets -hierarchical -filter {NAME =~ *core_WrPC*}]
puts "ISAAC_BRANCH_NET_COUNT=[llength $nets]"
foreach net $nets {
    set pins [get_pins -leaf -of_objects [get_nets -segments $net]]
    set drivers [filter $pins {DIRECTION == OUT}]
    set cells [get_cells -of_objects $drivers]
    set loads [filter $pins {DIRECTION == IN}]
    puts "ISAAC_BRANCH_NET=$net DRIVERS=$cells REFS=[get_property REF_NAME $cells] LOADS=[llength $loads]"
}
close_design
