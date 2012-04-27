`timescale 1ns / 1ps
`define P 20

module test_ram;

	// Inputs
	reg clk;
	reg a_wr;
	reg [6:0] a_addr;
	reg [197:0] a_din;
	reg b_wr;
	reg [6:0] b_addr;
	reg [197:0] b_din;

	// Outputs
	wire [197:0] a_dout;
	wire [197:0] b_dout;

	// Instantiate the Unit Under Test (UUT)
	ram uut (
		.clk(clk), 
		.a_wr(a_wr), 
		.a_addr(a_addr), 
		.a_din(a_din), 
		.a_dout(a_dout), 
		.b_wr(b_wr), 
		.b_addr(b_addr), 
		.b_din(b_din), 
		.b_dout(b_dout)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		a_wr = 0;
		a_addr = 0;
		a_din = 0;
		b_wr = 0;
		b_addr = 0;
		b_din = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        @ (negedge clk);
        a_addr = 1;
        
        #(`P*2);
        $finish;
	end

    initial #100 forever #(`P/2) clk = ~clk;
endmodule

