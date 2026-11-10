if {$PART ne "xc7a100tcsg324-1"} {error "Arty A7-100 requires xc7a100tcsg324-1"}
if {abs(double($env(CLOCK_PERIOD)) - 50.0) > 0.001} {
    error "Arty shell currently generates a fixed 20 MHz core clock (50 ns)"
}
if {$env(FPGA_SYN_CORE) eq "VEX_5S"} {
    add_files -norecurse [file join $ROOT_PATH fpga_syn boards arty_a7_100 vex_arty_top.sv]
} else {
add_files -norecurse [file join $ROOT_PATH fpga_syn boards arty_a7_100 cva5_arty_top.sv]
create_ip -name axi_uartlite -vendor xilinx.com -library ip -version 2.0 -module_name isaac_uart
set_property -dict [list CONFIG.C_BAUDRATE {115200} CONFIG.C_DATA_BITS {8} \
    CONFIG.C_S_AXI_ACLK_FREQ_HZ_d {20}] [get_ips isaac_uart]
generate_target all [get_ips isaac_uart]

synth_ip [get_ips isaac_uart]

}
