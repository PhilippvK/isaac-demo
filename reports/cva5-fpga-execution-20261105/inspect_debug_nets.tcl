open_checkpoint builds/branches-handshake/synthesized.dcp
foreach pattern {*core_RdPC_2_to_scal* *core_RdInstr_2_to_scal* *issue_isStalling* *execute_stall_idcounter_full* *fetch_wrPCValid* *pc_prescaiev* *oldest_pc*} {
 set nets [get_nets -quiet -hierarchical -filter "NAME =~ $pattern"]
 puts "DEBUG_PATTERN=$pattern COUNT=[llength $nets] NAMES=[lrange $nets 0 40]"
}
foreach pattern {cpu/cva5/RdPC_2_o* cpu/cva5/RdInstr_2_o*} {
 set pins [get_pins -quiet -hierarchical -filter "NAME =~ $pattern"]
 puts "DEBUG_PINS=$pattern COUNT=[llength $pins] NAMES=[lrange $pins 0 3]"
}
close_design
