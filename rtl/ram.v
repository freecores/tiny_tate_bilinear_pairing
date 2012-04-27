/*
    Copyright 2012 Homer Hsing
    
    This file is part of Tiny Tate Bilinear Pairing Core.

    Tiny Tate Bilinear Pairing Core is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Tiny Tate Bilinear Pairing Core is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Tiny Tate Bilinear Pairing Core.  If not, see http://www.gnu.org/licenses/lgpl.txt
*/

module ram #(
    parameter DATA = 198,
    parameter ADDR = 6
) (
    input                       clk,

    // Port A
    input   wire                a_wr,
    input   wire    [ADDR-1:0]  a_addr,
    input   wire    [DATA-1:0]  a_din,
    output  reg     [DATA-1:0]  a_dout,
    
    // Port B
    input   wire                b_wr,
    input   wire    [ADDR-1:0]  b_addr,
    input   wire    [DATA-1:0]  b_din,
    output  reg     [DATA-1:0]  b_dout
);

    // Shared memory
    reg [DATA-1:0] mem [(2**ADDR)-1:0];

    initial begin : init
        integer i;
        for(i = 0; i < (2**ADDR); i = i + 1)
            mem[i] = 0;
    end

    // Port A
    always @(posedge clk) begin
        if(a_wr) begin
            mem[a_addr] <= a_din;
        end
        a_dout      <= mem[a_addr];
    end

    // Port B
    always @(posedge clk) begin
        if(b_wr) begin
            mem[b_addr] <= b_din;
        end
        b_dout      <= mem[b_addr];
    end

endmodule
