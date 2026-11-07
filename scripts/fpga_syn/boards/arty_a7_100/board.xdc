# Digilent Arty-A7-100-Master.xdc (Rev. D/E):
# https://github.com/Digilent/digilent-xdc/blob/master/Arty-A7-100-Master.xdc
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk100]
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports reset_button]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS33} [get_ports uart_rx]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports uart_tx]
create_clock -name board_clk -period 10.000 [get_ports clk100]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
# Button/reset and UART RX are asynchronous inputs. UART Lite synchronizes RX;
# reset deassertion is synchronized in the board shell.
set_false_path -from [get_ports {reset_button uart_rx}]
# TX is asynchronous to the external receiver; constrain its output path
# conservatively against the board clock with zero external delay.
set_output_delay -clock board_clk -max 0.0 [get_ports uart_tx]
set_output_delay -clock board_clk -min 0.0 [get_ports uart_tx]
