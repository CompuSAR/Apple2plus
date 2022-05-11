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

    output logic[7:0] read_data
);

interface memory_read_i;
    logic enable;
    logic [7:0]data;
endinterface

memory_read_i cpu_memory_segments_read['h1f:0]();

// Dual port RAM - $0000 - $0800
segment_ram_dp ram00(
    .addra (address[10 : 0]),
    .clka  (clock),
    .dina  (write_data),
    .douta (cpu_memory_segments_read['h00].data),
    .ena   (cpu_memory_segments_read['h00].enable),
    .wea   (write),

    .addrb(16'h0000),
    .clkb(clock),
    .dinb(8'h00),
    .doutb(),
    .enb(0),
    .web(0)
);

generate
    genvar i;

    for( i='h01; i<='h11; ++i ) begin
        segment_ram_sp ram_segment(
            .addra (address[10 : 0]),
            .clka  (clock),
            .dina  (write_data),
            .douta (cpu_memory_segments_read[i].data),
            .ena   (cpu_memory_segments_read[i].enable),
            .wea   (write)
        );
    end

endgenerate

// Memory IO region $c000 - $cfff
assign cpu_memory_segments_read['h18].data = 8'h00;
assign cpu_memory_segments_read['h19].data = 8'h00;

rom_segment#("rom-D0.mem") romD0(
    .address (address[10 : 0]),
    .enable  (cpu_memory_segments_read['h1a].enable),
    .data    (cpu_memory_segments_read['h1a].data)
);
rom_segment#("rom-D8.mem") romD8(
    .address (address[10 : 0]),
    .enable  (cpu_memory_segments_read['h1b].enable),
    .data    (cpu_memory_segments_read['h1b].data)
);
rom_segment#("rom-E0.mem") romE0(
    .address (address[10 : 0]),
    .enable  (cpu_memory_segments_read['h1c].enable),
    .data    (cpu_memory_segments_read['h1c].data)
);
rom_segment#("rom-E8.mem") romE8(
    .address (address[10 : 0]),
    .enable  (cpu_memory_segments_read['h1d].enable),
    .data    (cpu_memory_segments_read['h1d].data)
);
rom_segment#("rom-F0.mem") romF0(
    .address (address[10 : 0]),
    .enable  (cpu_memory_segments_read['h1e].enable),
    .data    (cpu_memory_segments_read['h1e].data)
);
rom_segment#("rom-F8.mem") romF8(
    .address (address[10 : 0]),
    .enable  (cpu_memory_segments_read['h1f].enable),
    .data    (cpu_memory_segments_read['h1f].data)
);


generate
    for( i=0; i<'h20; ++i ) begin
        assign cpu_memory_segments_read[i].enable = address[15:11]==i;
    end
endgenerate

always_comb begin
    case( address[15:11] )
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
    endcase
end
endmodule
