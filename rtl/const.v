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
 * the module of constants
 *
 * addr  out  effective
 *    1   0     1
 *    2   1     1
 *    4   +     1
 *    8   -     1
 *   16 cubic   1
 * other  0     0
 */
module const (clk, addr, out, effective);
    input clk;
    input [5:0] addr;
    output reg [197:0] out;
    output reg effective; // active high if out is effective
    
    always @ (posedge clk)
      begin
         effective <= 1;
         case (addr)
            1:  out <= 0;
            2:  out <= 1;
            4:  out <= {6'b000101, 192'd0};
            8:  out <= {6'b001001, 192'd0};
            16: out <= {6'b010101, 192'd0};
            default: 
               begin out <= 0; effective <= 0; end
         endcase
      end
endmodule
