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

module pairing(clk, reset, sel, addr, w, update, ready, i, o, done);
   input clk;
   input reset; // for the arithmethic core
   input sel;
   input [5:0] addr;
   input w;
   input update; // update reg_in & reg_out
   input ready;  // shift reg_in & reg_out
   input i;
   output o;
   output done;
   
   reg [197:0] reg_in, reg_out;
   wire [197:0] out;
   
   assign o = reg_out[0];
   
   tiny
      tiny0 (clk, reset, sel, addr, w, reg_in, out, done);
   
   always @ (posedge clk) // write LSB firstly
      if (update) reg_in <= 0;
      else if (ready) reg_in <= {i,reg_in[197:1]};
   
   always @ (posedge clk) // read LSB firstly
      if (update) reg_out <= out;
      else if (ready) reg_out <= reg_out>>1;
endmodule
