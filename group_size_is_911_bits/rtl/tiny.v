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

module tiny(clk, reset, sel, addr, w, data, out, done);
    input clk, reset;
    input sel;
    input [5:0] addr;
    input w;
    input [`WIDTH_D0:0] data;
    output [`WIDTH_D0:0] out;
    output done;

    /* for FSM */
    wire [5:0] fsm_addr;
    /* for RAM */
    wire [5:0] ram_a_addr, ram_b_addr;
    wire [`WIDTH_D0:0] ram_b_data_in;
    wire ram_a_w, ram_b_w;
    wire [`WIDTH_D0:0] ram_a_data_out, ram_b_data_out;
    /* for const */
    wire [`WIDTH_D0:0] const0_out, const1_out;
    wire const0_effective, const1_effective;
    /* for muxer */
    wire [`WIDTH_D0:0] muxer0_out, muxer1_out;
    /* for ROM */
    wire [8:0] rom_addr;
    wire [28:0] rom_q;
    /* for PE */
    wire [10:0] pe_ctrl;
    
    assign out = ram_a_data_out;
    
    select 
        select0 (sel, addr, fsm_addr, w, ram_a_addr, ram_a_w);
    rom
        rom0 (clk, rom_addr, rom_q);
    FSM
        fsm0 (clk, reset, rom_addr, rom_q, fsm_addr, ram_b_addr, ram_b_w, pe_ctrl, done);
    const_
        const0 (clk, ram_a_addr, const0_out, const0_effective),
        const1 (clk, ram_b_addr, const1_out, const1_effective);
    ram
        ram0 (clk, ram_a_w, ram_a_addr, data, ram_a_data_out, ram_b_w, ram_b_addr[5:0], ram_b_data_in, ram_b_data_out);
    muxer
        muxer0 (ram_a_data_out, const0_out, const0_effective, muxer0_out),
        muxer1 (ram_b_data_out, const1_out, const1_effective, muxer1_out);
    PE
        pe0 (clk, reset, pe_ctrl, muxer1_out, muxer0_out[`WIDTH:0], muxer0_out[`WIDTH:0], ram_b_data_in[`WIDTH:0]);
    
    assign ram_b_data_in[`WIDTH_D0:`WIDTH+1] = 0;
endmodule

module select(sel, addr_in, addr_fsm_in, w_in, addr_out, w_out);
    input sel;
    input [5:0] addr_in;
    input [5:0] addr_fsm_in;
    input w_in;
    output [5:0] addr_out;
    output w_out;
    
    assign addr_out = sel ? addr_in : addr_fsm_in;
    assign w_out = sel & w_in;
endmodule

module muxer(from_ram, from_const, const_effective, out);
    input [`WIDTH_D0:0] from_ram, from_const;
    input const_effective;
    output [`WIDTH_D0:0] out;
    
    assign out = const_effective ? from_const : from_ram;
endmodule
