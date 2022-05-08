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
    input uart_recv
    );


logic clock1mhz;
clock_divider#(.Divider(50)) clock1mhz_divider(.clock_in(clock), .clock_out(clock1mhz));

cpu8bit main_cpu(.phi2(clock1mhz));

assign power_led = 0;
assign activity_led = 1;

endmodule
