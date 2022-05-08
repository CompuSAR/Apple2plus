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
