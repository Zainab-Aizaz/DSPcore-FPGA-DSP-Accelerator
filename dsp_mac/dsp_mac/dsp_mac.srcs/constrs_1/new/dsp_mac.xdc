create_clock -name clk -period 10.000 [get_ports clk]

# PROHIBIT constraint
set_property PROHIBIT 1 [get_sites -of [get_package_pins AD6]]
set_property PROHIBIT 1 [get_sites -of [get_package_pins W9]] 
set_property PROHIBIT 1 [get_sites -of [get_package_pins G4]] 
