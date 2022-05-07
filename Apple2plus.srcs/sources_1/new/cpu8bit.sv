`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2022 01:01:11 PM
// Design Name: 
// Module Name: cpu8bit
// Project Name: 
// Target Devices: 
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


module cpu8bit(
    input phi2,
    input [7:0] data_in,
    input RES,
    input rdy,
    input IRQ,
    input NMI,
    input SO,
    output [15:0] address,
    output [7:0] data_out,
    output rW,
    output VP,
    output ML,
    output sync
    );

sar6502#(.CPU_VARIANT(0))
    cpu(
        .phi2(phi2),
        .data_in(data_in),
        .RES(RES),
        .rdy(rdy),
        .IRQ(IRQ),
        .NMI(NMI),
        .SO(SO),
        .address(address),
        .data_out(data_out),
        .rW(rW),
        .VP(VP),
        .ML(ML),
        .sync(sync),
        .incompatible()
    );

endmodule
