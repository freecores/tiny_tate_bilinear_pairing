`timescale 1ns / 1ps

`define P 20 // clock period

`define M     593         // M is the degree of the irreducible polynomial
`define WIDTH (2*`M-1)    // width for a GF(3^M) element
`define WIDTH_D0 1187

module test_ram;

	// Inputs
	reg clk;
	reg reset;
	reg sel;
	reg [5:0] addr;
	reg w;
	reg [`WIDTH_D0:0] data;

	// Outputs
	wire [`WIDTH_D0:0] out;
	wire done;

	// Instantiate the Unit Under Test (UUT)
	tiny uut (
		.clk(clk), 
		.reset(reset), 
		.sel(sel), 
		.addr(addr), 
		.w(w), 
		.data(data), 
		.out(out), 
		.done(done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		sel = 0;
		addr = 0;
		w = 0;
		data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        @ (negedge clk);
        
        // write
        sel = 1; w = 1;
        data = 198'h115a25886512165251569195908560596a6695612620504191;
        addr = 0;
        #(`P);
        data = 198'h1559546442405a181195655549614540592955a15a26984015;
        addr = 3;
        #(`P);
        // not write
        w = 0;
        data = 198'h12222222222222222222222222222222222222222222222222;
        addr = 3;
        #(`P);
        
        // read
        sel = 1; w = 0;
        addr = 0;
        #(`P);
        if (out !== 198'h115a25886512165251569195908560596a6695612620504191) begin
            $display("E"); $finish;
        end

        addr = 3;
        #(`P);
        if (out !== 198'h1559546442405a181195655549614540592955a15a26984015) begin
            $display("E"); $finish;
        end

        #(`P);
        
        $display("Good");
        $finish;
	end
    
    initial #100 forever #(`P/2) clk = ~clk;
endmodule

