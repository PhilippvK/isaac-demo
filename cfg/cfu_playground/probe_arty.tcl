# Read-only JTAG discovery. No bitstream is programmed by this script.
open_hw_manager
connect_hw_server
set board_serial [lindex $argv 0]
set matches [get_hw_targets *$board_serial*]
if {[llength $matches] != 1} {
    error "Expected one JTAG target for board serial $board_serial; found $matches"
}
current_hw_target [lindex $matches 0]
open_hw_target
foreach device [get_hw_devices] {
    puts "ISAAC_HW_DEVICE=$device PART=[get_property PART $device]"
}
close_hw_target
disconnect_hw_server
close_hw_manager
