`timescale 1ns / 1ps
`define P 20


module test_rom;

	// Inputs
	reg clk;
	reg [9:0] addr;

	// Outputs
	wire [31:0] out;

	// Instantiate the Unit Under Test (UUT)
	rom uut (
		.clk(clk), 
		.addr(addr), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		addr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        #`P; 
        @ (negedge clk); 
        addr = 2; #`P;
        #`P;
        $finish;
	end
    
    initial #100 forever #(`P/2) clk = ~clk;
endmodule

