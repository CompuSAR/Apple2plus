`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2022 03:59:36 AM
// Design Name: 
// Module Name: memory_map
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


module memory_map(
    input [15:0]address,
    input clock,
    input [7:0]write_data,
    input write,

    output logic[7:0] read_data,

    input [9:0]display_addr,
    input display_enable,
    output logic[7:0] display_data,

    // IO ports
    output io_enable,
    input [7:0]io_read_data
);

interface memory_read_i;
    logic enable;
    logic [7:0]data;
endinterface

memory_read_i cpu_memory_segments_read['h3f:0]();

/*
// Dual port RAM - $0000 - $0800
segment_ram_dp ram00(
    .addra (address[10 : 0]),
    .clka  (clock),
    .dina  (write_data),
    .douta (cpu_memory_segments_read['h00].data),
    .ena   (cpu_memory_segments_read['h00].enable),
    .wea   (write),

    .addrb(10'h000),
    .clkb(clock),
    .dinb(8'h00),
    .doutb(),
    .enb(0),
    .web(0)
);
*/

generate
    genvar i;

    for( i='h00; i<='h10; ++i ) begin
        if( i!=1 )
            ram_segment_sp ram_segment(
                .address    (address[9 : 0]),
                .clock      (clock),
                .write_data (write_data),
                .read_data  (cpu_memory_segments_read[i].data),
                .enable     (cpu_memory_segments_read[i].enable),
                .write      (write)
            );
        else
            ram_segment_dp ram_segment(
                .address    (address[9 : 0]),
                .clock      (clock),
                .write_data (write_data),
                .read_data  (cpu_memory_segments_read[i].data),
                .enable     (cpu_memory_segments_read[i].enable),
                .write      (write),

                .enable_b   (display_enable),
                .address_b  (display_addr),
                .read_data_b(display_data)
            );
    end

endgenerate

// Memory IO region $c000 - $cfff
assign io_enable = address[15:8]==8'hC0;
assign cpu_memory_segments_read['h30].data = io_enable ? io_read_data : 8'h00;
assign cpu_memory_segments_read['h31].data = 8'h00;
assign cpu_memory_segments_read['h32].data = 8'h00;
assign cpu_memory_segments_read['h33].data = 8'h00;

rom_segment#("rom-D0.mem") romD0(
    .address (address[10:0]),
    .enable  (cpu_memory_segments_read['h34].enable || cpu_memory_segments_read['h35].enable),
    .data    (cpu_memory_segments_read['h34].data)
);
assign cpu_memory_segments_read['h35].data = cpu_memory_segments_read['h34].data;

rom_segment#("rom-D8.mem") romD8(
    .address (address[10:0]),
    .enable  (cpu_memory_segments_read['h36].enable || cpu_memory_segments_read['h37].enable),
    .data    (cpu_memory_segments_read['h36].data)
);
assign cpu_memory_segments_read['h37].data = cpu_memory_segments_read['h36].data;

rom_segment#("rom-E0.mem") romE0(
    .address (address[10:0]),
    .enable  (cpu_memory_segments_read['h38].enable || cpu_memory_segments_read['h39].enable),
    .data    (cpu_memory_segments_read['h38].data)
);
assign cpu_memory_segments_read['h39].data = cpu_memory_segments_read['h38].data;

rom_segment#("rom-E8.mem") romE8(
    .address (address[10:0]),
    .enable  (cpu_memory_segments_read['h3a].enable || cpu_memory_segments_read['h3b].enable),
    .data    (cpu_memory_segments_read['h3a].data)
);
assign cpu_memory_segments_read['h3b].data = cpu_memory_segments_read['h3a].data;

rom_segment#("rom-F0.mem") romF0(
    .address (address[10:0]),
    .enable  (cpu_memory_segments_read['h3c].enable || cpu_memory_segments_read['h3d].enable),
    .data    (cpu_memory_segments_read['h3c].data)
);
assign cpu_memory_segments_read['h3d].data = cpu_memory_segments_read['h3c].data;

rom_segment#("rom-F8.mem") romF8(
    .address (address[10:0]),
    .enable  (cpu_memory_segments_read['h3e].enable || cpu_memory_segments_read['h3f].enable),
    .data    (cpu_memory_segments_read['h3e].data)
);
assign cpu_memory_segments_read['h3f].data = cpu_memory_segments_read['h3e].data;

generate
    for( i=0; i<'h40; ++i ) begin
        assign cpu_memory_segments_read[i].enable = address[15:10]==i;
    end
endgenerate

always_comb begin
    case( address[15:10] )
    'h00: read_data = cpu_memory_segments_read['h00].data;
    'h01: read_data = cpu_memory_segments_read['h01].data;
    'h02: read_data = cpu_memory_segments_read['h02].data;
    'h03: read_data = cpu_memory_segments_read['h03].data;
    'h04: read_data = cpu_memory_segments_read['h04].data;
    'h05: read_data = cpu_memory_segments_read['h05].data;
    'h06: read_data = cpu_memory_segments_read['h06].data;
    'h07: read_data = cpu_memory_segments_read['h07].data;
    'h08: read_data = cpu_memory_segments_read['h08].data;
    'h09: read_data = cpu_memory_segments_read['h09].data;
    'h0a: read_data = cpu_memory_segments_read['h0a].data;
    'h0b: read_data = cpu_memory_segments_read['h0b].data;
    'h0c: read_data = cpu_memory_segments_read['h0c].data;
    'h0d: read_data = cpu_memory_segments_read['h0d].data;
    'h0e: read_data = cpu_memory_segments_read['h0e].data;
    'h0f: read_data = cpu_memory_segments_read['h0f].data;
    'h10: read_data = cpu_memory_segments_read['h10].data;
    'h11: read_data = cpu_memory_segments_read['h11].data;
    'h12: read_data = cpu_memory_segments_read['h12].data;
    'h13: read_data = cpu_memory_segments_read['h13].data;
    'h14: read_data = cpu_memory_segments_read['h14].data;
    'h15: read_data = cpu_memory_segments_read['h15].data;
    'h16: read_data = cpu_memory_segments_read['h16].data;
    'h17: read_data = cpu_memory_segments_read['h17].data;
    'h18: read_data = cpu_memory_segments_read['h18].data;
    'h19: read_data = cpu_memory_segments_read['h19].data;
    'h1a: read_data = cpu_memory_segments_read['h1a].data;
    'h1b: read_data = cpu_memory_segments_read['h1b].data;
    'h1c: read_data = cpu_memory_segments_read['h1c].data;
    'h1d: read_data = cpu_memory_segments_read['h1d].data;
    'h1e: read_data = cpu_memory_segments_read['h1e].data;
    'h1f: read_data = cpu_memory_segments_read['h1f].data;
    'h20: read_data = cpu_memory_segments_read['h20].data;
    'h21: read_data = cpu_memory_segments_read['h21].data;
    'h22: read_data = cpu_memory_segments_read['h22].data;
    'h23: read_data = cpu_memory_segments_read['h23].data;
    'h24: read_data = cpu_memory_segments_read['h24].data;
    'h25: read_data = cpu_memory_segments_read['h25].data;
    'h26: read_data = cpu_memory_segments_read['h26].data;
    'h27: read_data = cpu_memory_segments_read['h27].data;
    'h28: read_data = cpu_memory_segments_read['h28].data;
    'h29: read_data = cpu_memory_segments_read['h29].data;
    'h2a: read_data = cpu_memory_segments_read['h2a].data;
    'h2b: read_data = cpu_memory_segments_read['h2b].data;
    'h2c: read_data = cpu_memory_segments_read['h2c].data;
    'h2d: read_data = cpu_memory_segments_read['h2d].data;
    'h2e: read_data = cpu_memory_segments_read['h2e].data;
    'h2f: read_data = cpu_memory_segments_read['h2f].data;
    'h30: read_data = cpu_memory_segments_read['h30].data;
    'h31: read_data = cpu_memory_segments_read['h31].data;
    'h32: read_data = cpu_memory_segments_read['h32].data;
    'h33: read_data = cpu_memory_segments_read['h33].data;
    'h34: read_data = cpu_memory_segments_read['h34].data;
    'h35: read_data = cpu_memory_segments_read['h35].data;
    'h36: read_data = cpu_memory_segments_read['h36].data;
    'h37: read_data = cpu_memory_segments_read['h37].data;
    'h38: read_data = cpu_memory_segments_read['h38].data;
    'h39: read_data = cpu_memory_segments_read['h39].data;
    'h3a: read_data = cpu_memory_segments_read['h3a].data;
    'h3b: read_data = cpu_memory_segments_read['h3b].data;
    'h3c: read_data = cpu_memory_segments_read['h3c].data;
    'h3d: read_data = cpu_memory_segments_read['h3d].data;
    'h3e: read_data = cpu_memory_segments_read['h3e].data;
    'h3f: read_data = cpu_memory_segments_read['h3f].data;
    endcase
end
endmodule
