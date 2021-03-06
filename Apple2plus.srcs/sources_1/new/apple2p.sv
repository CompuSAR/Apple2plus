`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Some Assembly Required
// Engineer: Shachar Shemesh
// 
// Create Date: 05/07/2022 06:40:20 AM
// Design Name: apple2plus
// Module Name: apple2p
// Project Name: compusar
// Target Devices: Spartan-7 15
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module apple2p(
    input clock,
    output power_led,
    output activity_led,
    input reset_switch,
    input reset_output_switch,
    output uart_send,
    input uart_recv,
    output speaker,

    output logic [15:0]debug_addr,
    output logic [7:0]debug_data,
    output logic debug_rw
    );

logic clock16mhz, clock1mhz;
logic clock_stable;
logic [3:0]divided_clocks;
assign clock1mhz = divided_clocks[3]; // Divided by 16
clock_gen1 clock_generator(.clk_in1(clock), .clk_out1(clock16mhz), .locked(clock_stable), .reset(0));
clock_divider#(.NumBits(4)) clock1mhz_divider(.clock_in(clock16mhz), .clocks_out(divided_clocks));

logic [9:0]display_address;
logic [7:0]display_data;
logic display_enable;
logic uart_send_raw;
display display_controller(
    .clock(clock16mhz),

    .address(display_address),
    .data(display_data),
    .enable(display_enable),

    .uart_send(uart_send_raw)
);

assign uart_send = reset_output_switch ? uart_send_raw : 1'b0;

logic [15:0]address_bus;
logic [7:0]read_data, io_read_data;
logic [7:0]write_data;
logic rW;
logic io_enable;
memory_map memory_map(
    .address(address_bus), .clock(!clock1mhz), .write_data(write_data), .write(! rW), .read_data(read_data),
    .display_addr(display_address), .display_enable(display_enable), .display_data(display_data),
    .io_enable(io_enable), .io_read_data(io_read_data)
);

cpu8bit main_cpu(
    .phi2(clock1mhz),
    .data_in(read_data),
    .data_out(write_data),
    .rW( rW ),
    .RES(reset_switch && clock_stable),
    .rdy(1),
    .IRQ(1),
    .NMI(1),
    .SO(1),
    .address(address_bus)
);

SoftSwitches soft_switches(
    .address(address_bus[7:0]),
    .write_data(write_data),
    .read_data(io_read_data),
    .enable(io_enable),
    .write(! rW),
    .system_clock(clock16mhz),
    .cpu_clock(clock1mhz),
    .uart_in(uart_recv),
    .speaker(speaker)
);

assign power_led = 0;
assign activity_led = read_data[0];

assign debug_addr = address_bus;
assign debug_data = rW ? read_data : write_data;
assign debug_clock = clock1mhz;
assign debug_rw = rW;

endmodule
