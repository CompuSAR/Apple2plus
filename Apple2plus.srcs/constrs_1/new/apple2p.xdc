# Clock
create_clock -period 20.000 -name clock -waveform {0.000 10.000} [get_ports clock]
set_input_jitter [get_clocks -of_objects [get_ports clock]] 0.200

set_property PACKAGE_PIN H13 [get_ports clock]
set_property IOSTANDARD LVCMOS33 [get_ports clock]

# UART
set_property PACKAGE_PIN P10 [get_ports uart_recv]
set_property IOSTANDARD LVCMOS33 [get_ports uart_recv]
set_property PACKAGE_PIN N10 [get_ports uart_send]
set_property IOSTANDARD LVCMOS33 [get_ports uart_send]

# Switches
set_property PACKAGE_PIN F4 [get_ports reset_switch]
set_property IOSTANDARD LVCMOS15 [get_ports reset_switch]

# LEDs
set_property PACKAGE_PIN M10 [get_ports activity_led]
set_property IOSTANDARD LVCMOS33 [get_ports activity_led]
set_property PACKAGE_PIN E11 [get_ports power_led]
set_property IOSTANDARD LVCMOS33 [get_ports power_led]

# SPI load speed
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]

# Debug ports
set_property PACKAGE_PIN A10 [get_ports debug_addr[0]]
set_property PACKAGE_PIN A13 [get_ports debug_addr[1]]
set_property PACKAGE_PIN B14 [get_ports debug_addr[2]]
set_property PACKAGE_PIN C14 [get_ports debug_addr[3]]
set_property PACKAGE_PIN D13 [get_ports debug_addr[4]]
set_property PACKAGE_PIN E12 [get_ports debug_addr[5]]
set_property PACKAGE_PIN E13 [get_ports debug_addr[6]]
set_property PACKAGE_PIN F14 [get_ports debug_addr[7]]
set_property PACKAGE_PIN F11 [get_ports debug_addr[8]]
set_property PACKAGE_PIN J14 [get_ports debug_addr[9]]
set_property PACKAGE_PIN K12 [get_ports debug_addr[10]]
set_property PACKAGE_PIN L13 [get_ports debug_addr[11]]
set_property PACKAGE_PIN L14 [get_ports debug_addr[12]]
set_property PACKAGE_PIN M13 [get_ports debug_addr[13]]
set_property PACKAGE_PIN L12 [get_ports debug_addr[14]]
set_property PACKAGE_PIN K11 [get_ports debug_addr[15]]
set_property PACKAGE_PIN J13 [get_ports debug_data[0]]
set_property PACKAGE_PIN G11 [get_ports debug_data[1]]
set_property PACKAGE_PIN G14 [get_ports debug_data[2]]
set_property PACKAGE_PIN F13 [get_ports debug_data[3]]
set_property PACKAGE_PIN F12 [get_ports debug_data[4]]
set_property PACKAGE_PIN D12 [get_ports debug_data[5]]
set_property PACKAGE_PIN D14 [get_ports debug_data[6]]
set_property PACKAGE_PIN B13 [get_ports debug_data[7]]
set_property PACKAGE_PIN B10 [get_ports debug_clock]
set_property PACKAGE_PIN A12 [get_ports debug_rw]
set_property IOSTANDARD LVCMOS33 [get_ports debug*]
