set serial [lindex $argv 0]
set bitstream [file normalize [lindex $argv 1]]
set probes [file join [file dirname $bitstream] debug.ltx]
open_hw_manager
connect_hw_server
set matches [get_hw_targets *${serial}*]
if {[llength $matches] != 1} {error "Expected one target for $serial"}
current_hw_target [lindex $matches 0]
set_property PARAM.FREQUENCY 3000000 [current_hw_target]
open_hw_target
set device [lindex [get_hw_devices] 0]
if {[get_property PART $device] ne "xc7a100t"} {error "Unexpected FPGA"}
current_hw_device $device
set_property PROGRAM.FILE $bitstream $device
set_property PROBES.FILE $probes $device
set_property FULL_PROBES.FILE $probes $device
program_hw_devices $device
puts "ISAAC_PROGRAMMED=$device FILE=$bitstream"
refresh_hw_device $device
set ilas [get_hw_ilas -of_objects $device]
if {[llength $ilas] != 1} {error "Expected one ILA; found $ilas"}
puts "ISAAC_ILA=$ilas"
set probe [get_hw_probes -of_objects $ilas -filter {NAME =~ *oldest_pc*}]
if {[llength $probe] != 1} {error "Expected oldest-PC probe: $probe"}
set_property TRIGGER_COMPARE_VALUE {eq30'h20000013} $probe
set_property CONTROL.TRIGGER_POSITION 512 $ilas
run_hw_ila $ilas
wait_on_hw_ila -timeout 60 $ilas
set data [upload_hw_ila_data $ilas]
write_hw_ila_data -force -csv_file capture.csv $data
puts "ISAAC_CAPTURE_COMPLETE=capture.csv"
close_hw_target
disconnect_hw_server
close_hw_manager
