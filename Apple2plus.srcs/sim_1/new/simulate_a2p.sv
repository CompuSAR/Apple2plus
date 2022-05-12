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

/*

logic [7:0]write_data;
logic [7:0]read_data;
logic mem_enable;
logic write;
segment_ram_dp test_ram_dp(
    .addra (10'h103),
    .clka  (clock),
    .dina  (write_data),
    .douta (read_data),
    .ena   (mem_enable),
    .wea   (write),

    .addrb(10'h000),
    .clkb (clock),
    .dinb (8'h00),
    .doutb(),
    .enb  (1'b0),
    .web  (1'b0)
);

initial begin
    write_data = 8'hf3;
    mem_enable = 0;
    write = 0;

    #5000 mem_enable = 1;
    #5000 write = 1;
    #5000 write = 0;
end
*/

endmodule
