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

`define M     593         // M is the degree of the irreducible polynomial
`define WIDTH (2*`M-1)    // width for a GF(3^M) element
`define WIDTH_D0 1187

module ram #(
    parameter DATA = 1188,
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
        a_dout      <= mem[a_addr];
        if(a_wr) begin
            a_dout      <= a_din;
            mem[a_addr] <= a_din;
        end
    end

    // Port B
    always @(posedge clk) begin
        b_dout      <= mem[b_addr];
        if(b_wr) begin
            b_dout      <= b_din;
            mem[b_addr] <= b_din;
        end
    end

endmodule
