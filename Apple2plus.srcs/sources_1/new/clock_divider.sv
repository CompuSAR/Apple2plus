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


module clock_divider#(parameter int Divider=100)
(
    input clock_in,
    output logic clock_out = 0
);

logic [$clog2(Divider)-1 : 0]divider = 0;

always_ff@(posedge clock_in)
begin
    divider <= divider+1;

    if( divider == (Divider-1)/2  )
        clock_out <= 1;
    else if( divider==Divider-1 ) begin
        clock_out <= 0;
        divider <= 0;
    end
end

endmodule
