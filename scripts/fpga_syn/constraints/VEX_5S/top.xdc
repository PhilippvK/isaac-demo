set ::env(CLOCK_PERIOD) $env(CLOCK_PERIOD)

create_clock -name clk -period $::env(CLOCK_PERIOD) [get_ports {clk}]
