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
    output uart_send,
    input uart_recv,

    output logic [15:0]debug_addr,
    output logic [7:0]debug_data,
    output logic debug_clock
    );

logic clock1mhz;
clock_divider#(.Divider(50)) clock1mhz_divider(.clock_in(clock), .clock_out(clock1mhz));

logic [15:0]address_bus;
logic [7:0]read_data;
logic [7:0]write_data;
logic rW;
memory_map memory_map(.address(address_bus), .clock(!clock1mhz), .write_data(write_data), .write(! rW), .read_data(read_data));

cpu8bit main_cpu(
    .phi2(clock1mhz),
    .data_in(read_data),
    .data_out(write_data),
    .rW( rW ),
    .RES(reset_switch),
    .rdy(1),
    .IRQ(1),
    .NMI(1),
    .SO(1),
    .address(address_bus)
);

assign power_led = 0;
assign activity_led = read_data[0];

assign debug_addr = address_bus;
assign debug_data = rW ? read_data : write_data;
assign debug_clock = clock1mhz;

endmodule
