# Volatile FPGA configuration only. No SPI flash operations.
set serial [lindex $argv 0]
set bitstream [file normalize [lindex $argv 1]]
if {$serial eq "" || ![file isfile $bitstream]} {error "Usage: program_arty.tcl SERIAL BITSTREAM"}
open_hw_manager
connect_hw_server
set matches [get_hw_targets *${serial}*]
if {[llength $matches] != 1} {error "Expected one target for $serial; found $matches"}
current_hw_target [lindex $matches 0]
open_hw_target
set devices [get_hw_devices]
if {[llength $devices] != 1} {error "Expected one FPGA; found $devices"}
set device [lindex $devices 0]
if {[get_property PART $device] ne "xc7a100t"} {error "Unexpected FPGA [get_property PART $device]"}
current_hw_device $device
set_property PROGRAM.FILE $bitstream $device
program_hw_devices $device
puts "ISAAC_PROGRAMMED=$device FILE=$bitstream"
close_hw_target
disconnect_hw_server
close_hw_manager
