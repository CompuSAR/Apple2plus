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

localparam REFRESH_FREQ = 30;
localparam CLOCK_SPEED = 50000000;
localparam CLOCK_REFRESH_DIVIDER = CLOCK_SPEED / REFRESH_FREQ;
localparam DISPLAY_BAUD = 1000000;

logic [$clog2(CLOCK_REFRESH_DIVIDER)-1 : 0]refresh_divider = 0;

localparam string ClearScreenSequence = "\x1b[H\x1b[2J\x1b[3J\x1b[?25l";
localparam string NewLineSequence = "\x0d\x0a";

logic [$clog2(ClearScreenSequence.len()+1)-1 : 0] cls_counter = 0;
logic [$clog2(NewLineSequence.len()+1)-1 : 0] nl_counter = NewLineSequence.len();

localparam MaxBytesInTransition = 32;
localparam NumStates = 2;

localparam string NormalModeCmd = "\x1b[0m";
localparam string InverseModeCmd = "\x1b[7m";

typedef enum { NormalMode, InverseMode } CharMode;
CharMode active_state;
function max(input a, input b);
    return (a > b) ? a : b;
endfunction

logic[$clog2( max(NormalModeCmd.len(), InverseModeCmd.len()) + 1)-1 : 0] transition_index;

logic [3:0] frame_counter = 0;

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

enum {
    StateIdle,
    StateCls,
    StateNl,
    StateSwitchMode,
    StateDumpScreen
} uart_state = StateCls;

function CharMode get_desired_state();
    if( uart_state!=StateDumpScreen )
        return active_state;

    if( data[7] == 1 )
        return NormalMode;
    if( data[6] == 0 )
        return InverseMode;

    // Flashing text
    if( frame_counter<8 )
        return InverseMode;
    else
        return NormalMode;
endfunction

assign uart_data_ready = uart_state != StateIdle;
assign enable = uart_state != StateIdle;

always_comb begin
    case(uart_state)
        StateIdle:              uart_data_in = 0;
        StateCls:               uart_data_in = ClearScreenSequence[cls_counter];
        StateNl:                uart_data_in = NewLineSequence[nl_counter];
        StateSwitchMode:        uart_data_in = active_state==NormalMode ? NormalModeCmd[transition_index] : InverseModeCmd[transition_index];
        StateDumpScreen:        uart_data_in = translate_data(data);
    endcase
end

always_ff@(posedge clock) begin
    refresh_divider <= refresh_divider + 1;

    if( refresh_divider==CLOCK_REFRESH_DIVIDER-1 ) begin
        refresh_divider <= 1;
        cls_counter <= 0;
        nl_counter <= NewLineSequence.len();
        display_address <= 0;
        uart_state <= StateCls;
        frame_counter <= frame_counter + 1;
    end else if( uart_receive_ready ) begin
        case( uart_state )
            StateIdle: begin end
            StateCls: begin
                cls_counter <= cls_counter + 1;
                if( cls_counter==ClearScreenSequence.len()-1 )
                    uart_state <= StateDumpScreen;
            end
            StateNl: begin
                nl_counter <= nl_counter + 1;
                if( nl_counter==NewLineSequence.len()-1 )
                    uart_state <= StateDumpScreen;
            end
            StateSwitchMode: begin
                transition_index <= transition_index + 1;

                case( active_state )
                    NormalMode:
                        if( transition_index==NormalModeCmd.len()-1 )
                            uart_state <= StateDumpScreen;
                    InverseMode:
                        if( transition_index==InverseModeCmd.len()-1 )
                            uart_state <= StateDumpScreen;
                endcase
            end
            StateDumpScreen: begin
                advance_display_address();
            end
        endcase
    end

    if( get_desired_state()!=active_state ) begin
        active_state <= get_desired_state();
        transition_index<=0;
        uart_state <= StateSwitchMode;
    end
end

task advance_display_address();
    /* The Apple text screen is divided to three thirds, each 8 lines long.
    * Each line has 40 bytes. Continuing in memory past those 40 bytes gets
    * you to the same line in the next third. Once the last third is done, we
    * round up to multiple of 128 and go to the next line in the first third.
    */
    if( display_address==10'h3f7 ) begin
        // End of last line of last third
        uart_state <= StateIdle;
    end else if( display_address[6:0]==39 ) begin
        // End of line in first third
        nl_counter <= 0;
        uart_state <= StateNl;

        if( display_address==10'h3a7 )
            // End of first third
            display_address <= 40;
        else
            // Move a line down
            display_address <= display_address + 128 - 39;
    end else if( display_address[6:0]==39+40 ) begin
        // End of line in second third
        nl_counter <= 0;
        uart_state <= StateNl;

        if( display_address==10'h3cf )
            // End of second third
            display_address <= 80;
        else
            // Move a line down
            display_address <= display_address + 128 - 39;
    end else if( display_address[6:0]==39+80 ) begin
        // End of line in third third
        nl_counter <= 0;
        uart_state <= StateNl;

        display_address <= display_address + 128 - 39;
    end else begin
        display_address <= display_address + 1;
    end
endtask

endmodule 
