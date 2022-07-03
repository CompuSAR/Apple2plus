`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2022 04:59:31 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider#(parameter int NumBits=4)
(
    input clock_in,
    output logic [NumBits-1:0]clocks_out = 0
);

always_ff@(posedge clock_in)
begin
    clocks_out <= clocks_out+1;
end

endmodule
