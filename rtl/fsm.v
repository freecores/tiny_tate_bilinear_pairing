/*
    Copyright 2011,2012 City University of Hong Kong
    Homer Hsing is the author.
    
    This file is part of Tate Bilinear Pairing Core.

    Tate Bilinear Pairing Core is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Tate Bilinear Pairing Core is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Tate Bilinear Pairing Core.  If not, see http://www.gnu.org/licenses/lgpl.txt
*/

/* FSM: finite state machine 
 * halt if $ctrl == 0$
 */
module FSM(clk, reset, rom_addr, rom_q, ram_a_addr, ram_b_addr, ram_b_w, pe_ctrl, done);
    input clk;
    input reset;
    output [9:0] rom_addr; /* command id */
    input [31:0] rom_q; /* command value */
    output done;
    output [6:0] ram_a_addr; /* a field of $rom_q$ */
    output [6:0] ram_b_addr; /* a field of $rom_q$ */
    output ram_b_w; /* a field of $rom_q$ */
    output [10:0] pe_ctrl; /* a field of $rom_q$ */
    
    reg [9:0] rom_addr;
    reg [5:0] ctrl; /* in fact a counter */
    reg done;

    /* I had attempted to avoid finite state machine for a whole day, but I conceded. :) */
    parameter S0 = 3'b001, S1 = 3'b010, S2 = 3'b100;
    reg [2:0] state;
    
    assign {ram_b_w, ram_b_addr, ram_a_addr, pe_ctrl} = rom_q[25:0];

    always @ (posedge clk)
        if (reset)
          begin
            state <= S0; rom_addr <= 0; 
            ctrl <= 0; done <= 0;
          end
        else
          begin
            done <= 0; 
            case (state)
              S0: 
                begin 
                  case (rom_q[31:26])
                    0: begin state <= S2; done <= 1; end
                    1: rom_addr <= rom_addr + 1;
                    default: begin state <= S1; ctrl <= rom_q[31:26]-1; end
                  endcase
                end
              S1:
                begin
                  if (ctrl == 1)
                    begin
                      rom_addr <= rom_addr + 1;
                      state <= S0;
                    end
                  else
                    ctrl <= ctrl - 1;
                end
            endcase
          end
endmodule
