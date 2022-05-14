`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2022 03:42:58 PM
// Design Name: 
// Module Name: display
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


module display(
    input clock,

    output [9:0] address,
    input [7:0]data,
    output logic enable,

    output uart_send
);

localparam REFRESH_FREQ = 60;
localparam CLOCK_SPEED = 50000000;
localparam CLOCK_REFRESH_DIVIDER = CLOCK_SPEED / REFRESH_FREQ;
localparam DISPLAY_BAUD = 1000000;

logic [$clog2(CLOCK_REFRESH_DIVIDER)-1 : 0]refresh_divider = 0;

localparam string ClearScreenSequence = "\x1b[H\x1b[2J\x1b[3J\x1b[?25l";

logic [$clog2(ClearScreenSequence.len())-1 : 0] cls_counter = 0;

logic[7:0] uart_data_in;
logic uart_data_ready;
logic uart_receive_ready;
uart_send#(.ClockDivider(CLOCK_SPEED/DISPLAY_BAUD))
    uart(
        .clock(clock),
        .data_in(uart_data_in),
        .data_in_ready(uart_data_ready),

        .out_bit(uart_send),
        .receive_ready(uart_receive_ready)
    );

logic[9:0] display_address = 0;
assign address = display_address;

function logic[7:0] translate_data(input logic[7:0] data);
    if( data[5] )
        return data[5:0];
    else
        return {2'b01, data[5:0]};
endfunction

always_comb begin
    if( cls_counter!=ClearScreenSequence.len() ) begin
        enable = 0;
        uart_data_in = ClearScreenSequence[cls_counter];
        uart_data_ready = 1;
    end else if( display_address != 9'h3ff ) begin
        enable = 1;
        uart_data_in = translate_data(data);
        uart_data_ready = 1;
    end else begin
        enable = 0;
        uart_data_in = 0;
        uart_data_ready = 0;
    end
end

always_ff@(posedge clock) begin
    refresh_divider += 1;

    if( refresh_divider==CLOCK_REFRESH_DIVIDER-1 ) begin
        refresh_divider = 1;
        cls_counter = 0;
        display_address = 0;
    end else if( cls_counter!=ClearScreenSequence.len() ) begin
        if( uart_receive_ready )
            cls_counter += 1;
    end else if( display_address != 9'h3ff ) begin
        if( uart_receive_ready )
            display_address += 1;
    end
end

endmodule 
