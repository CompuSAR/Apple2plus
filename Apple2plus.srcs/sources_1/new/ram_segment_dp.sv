`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2022 08:12:36 PM
// Design Name: 
// Module Name: ram_segment_sp
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


module ram_segment_dp(
    input [9:0] address,
    input clock,
    input enable,
    output [7:0] read_data,
    input [7:0] write_data,
    input write,

    input enable_b,
    input [9:0] address_b,
    output [7:0] read_data_b
);

logic [7:0]memory[0 : 1023];

assign read_data = enable ? memory[address] : 8'b0;
assign read_data_b = enable_b ? memory[address] : 8'b0;

always_ff@(posedge clock) begin
    if( write && enable ) begin
        memory[address] <= write_data;
    end
end

endmodule
