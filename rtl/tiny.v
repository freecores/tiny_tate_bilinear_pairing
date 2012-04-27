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

module tiny(clk, reset, sel, addr, w, data, out, done);
    input clk, reset;
    input sel;
    input [5:0] addr;
    input w;
    input [197:0] data;
    output [197:0] out;
    output done;

    /* for FSM */
    wire [5:0] fsm_addr;
    /* for RAM */
    wire [5:0] ram_a_addr, ram_b_addr;
    wire [197:0] ram_b_data_in;
    wire ram_a_w, ram_b_w;
    wire [197:0] ram_a_data_out, ram_b_data_out;
    /* for const */
    wire [197:0] const0_out, const1_out;
    wire const0_effective, const1_effective;
    /* for mux */
    wire [197:0] mux0_out, mux1_out;
    /* for ROM */
    wire [8:0] rom_addr;
    wire [25:0] rom_q;
    /* for PE */
    wire [10:0] pe_ctrl;
    
    assign out = ram_a_data_out;
    
    select 
        select0 (sel, addr, fsm_addr, w, ram_a_addr, ram_a_w);
    rom
        rom0 (clk, rom_addr, rom_q);
    FSM
        fsm0 (clk, reset, rom_addr, rom_q, fsm_addr, ram_b_addr, ram_b_w, pe_ctrl, done);
    const
        const0 (clk, ram_a_addr, const0_out, const0_effective),
        const1 (clk, ram_b_addr, const1_out, const1_effective);
    ram
        ram0 (clk, ram_a_w, ram_a_addr, data, ram_a_data_out, ram_b_w, ram_b_addr[5:0], ram_b_data_in, ram_b_data_out);
    mux
        mux0 (ram_a_data_out, const0_out, const0_effective, mux0_out),
        mux1 (ram_b_data_out, const1_out, const1_effective, mux1_out);
    PE
        pe0 (clk, reset, pe_ctrl, mux1_out, mux0_out[193:0], mux0_out[193:0], ram_b_data_in[193:0]);
    
    assign ram_b_data_in[197:194] = 0;
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

module mux(from_ram, from_const, const_effective, out);
    input [197:0] from_ram, from_const;
    input const_effective;
    output [197:0] out;
    
    assign out = const_effective ? from_const : from_ram;
endmodule
