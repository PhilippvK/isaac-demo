# F4PGA read_xdc subset, Digilent Arty A7-100T Rev D/E.
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk100]
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports reset_button]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS33} [get_ports uart_rx]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports uart_tx]
create_clock -name board_clk -period 10.000 [get_ports clk100]
# Explicitly constrain the fixed 20 MHz buffered core clock.
# Do not rely solely on architecture-specific clock propagation.
create_clock -name core_clk -period 50.000 [get_nets clk20]
