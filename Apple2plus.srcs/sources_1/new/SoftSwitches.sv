`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2022 08:10:51 PM
// Design Name: 
// Module Name: SoftSwitches
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


module SoftSwitches(
    input [7:0] address,
    input [7:0] write_data,
    output logic[7:0] read_data,
    input enable,
    input write,
    input system_clock,
    input cpu_clock,

    // IO ports
    input uart_in,

    // Debug ports
    output [7:0] debug_data,
    output debug_signal1,
    output debug_signal2
);

localparam CLOCK_SPEED = 50000000;
localparam DISPLAY_BAUD = 1000000;

logic[7:0] uart_data;
logic uart_data_ready;
uart_recv#(.ClockDivider(CLOCK_SPEED/DISPLAY_BAUD))
    uart(
        .clock(system_clock),
        .input_bit(uart_in),

        .data_out(uart_data),
        .data_ready(uart_data_ready),
        .break_received(),
        .error()
    );

logic[7:0] last_key_pressed = 0;
logic clear_last_key = 0, already_cleared = 0;
assign debug_data = last_key_pressed;
assign debug_signal1 = clear_last_key;
assign debug_signal2 = already_cleared;

always_ff@(posedge system_clock)
begin
    if( clear_last_key && !already_cleared ) begin
        last_key_pressed[7] <= 1'b0;
        already_cleared <= 1;
    end else if( !clear_last_key )
        already_cleared <= 0;

    if( uart_data_ready )
        last_key_pressed <= { 1'b1, uart_data[6:0] };
end

// Soft switches read handling is divided to state changing and non-state
// changing. The former is done in on falling edge of the CPU clock, the
// later via asynchronous logic.
always_comb begin
    if( enable && !write ) begin
        if( address[7:4]==4'h0 || address[7:4]==4'h1 ) begin
            // Read/clear last key
            read_data = last_key_pressed;
        end else
            read_data = 8'h00;
    end else
        read_data = 8'h00;
end

always_ff@(negedge cpu_clock)
begin
    clear_last_key <= 0;

    if( enable ) begin
        if( !write ) begin
            if( address[7:4]==4'h1 ) begin
                clear_last_key <= 1;
            end
        end
    end
end

endmodule
