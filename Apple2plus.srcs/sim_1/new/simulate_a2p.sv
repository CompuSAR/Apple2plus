`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2022 05:21:42 PM
// Design Name: 
// Module Name: simulate_a2p
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


module simulate_a2p(
    );

logic board_clock = 0;
logic reset;

initial begin
    forever begin
        #10 board_clock = 1;
        #10 board_clock = 0;
    end
end

initial begin
    reset = 0;
    #7000 reset = 1;
    #20000 reset = 0;
    #4000 reset = 1;
end

apple2p apple(.clock(board_clock), .reset_switch(reset));

endmodule
