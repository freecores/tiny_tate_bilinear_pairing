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

/*
 * the $ctrl$ field in the first cmd is the running number of the second command.
 *  0: rom_q <= {6'd1, 1'd0, 7'd0, 7'd0, 11'd0}; // repeat 1 time
 *  1: rom_q <= {6'd2, 1'd1, 7'd2, 7'd3, 11'd4}; // repeat 1 times
 *  2: rom_q <= {6'd3, 1'd0, 7'd5, 7'd6, 11'd7}; // repeat 2 times
 *  3: rom_q <= {6'd1, 1'd1, 7'd8, 7'd9, 11'ha}; // repeat 3 time
 * the number one command runs two times. don't put valid command there :)
 */
module rom (clk, addr, out);
   input clk;
   input [9:0] addr;
   output reg [31:0] out;
   
   always @(posedge clk)
     case (addr) // test addr[3] = addr[2] + addr[2]
        0: out <= {6'd1, 1'd0, 7'd0, 7'd0, 11'd0}; // blank
        1: out <= {6'd1, 1'd0, 7'd0, 7'd2, 11'b0}; // read addr[2]
        2: out <= {6'd2, 1'd0, 7'd4, 7'd2, 11'b11000000000}; // load d1, read addr[2], command_add
        3: out <= {6'd1, 1'd1, 7'd3, 7'd0, 11'b00111010001}; // load d0, d2, d3
        default: out <= 0;
     endcase
endmodule
