# Time: ns. Load and driver capacitance use the selected library's units.
create_clock -name clk -period $env(CLOCK_PERIOD) [get_ports $env(ASIP_CLOCK_PORT)]
set_clock_uncertainty 0.25 [get_clocks clk]
set_clock_transition 0.15 [get_clocks clk]
set data_inputs [remove_from_collection [all_inputs] [get_ports $env(ASIP_CLOCK_PORT)]]
set_input_delay [expr {$env(CLOCK_PERIOD) * 0.2}] -clock clk $data_inputs
set_output_delay [expr {$env(CLOCK_PERIOD) * 0.2}] -clock clk [all_outputs]
set_driving_cell -lib_cell $env(ASIP_DRIVING_CELL) -pin $env(ASIP_DRIVING_PIN) $data_inputs
set_load $env(ASIP_OUTPUT_LOAD) [all_outputs]
set_max_transition 0.75 [current_design]
set_max_fanout 10 [current_design]
