`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2022 03:31:26 AM
// Design Name: 
// Module Name: rom_segment
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


module rom_segment#(parameter string mem_file)
(
    input [10:0] address,
    input enable,
    output [7:0] data
);

bit [7:0]memory[2047 : 0];

assign data = enable ? memory[address] : 8'b0;

initial begin
    $readmemh(mem_file, memory);
end

endmodule
