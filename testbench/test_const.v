`timescale 1ns / 1ps
`define P 20 // clock period

module test_const;

	// Inputs
    reg clk;
	reg [5:0] addr;

	// Outputs
	wire [197:0] out;
	wire effective;
    reg [197:0] w_out;
    reg w_effective;
    
	// Instantiate the Unit Under Test (UUT)
	const uut (
        .clk(clk),
		.addr(addr), 
		.out(out), 
		.effective(effective)
	);

	initial begin
		// Initialize Inputs
		addr = 0; clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        @ (negedge clk);
        addr = 1; w_out = 0; w_effective = 1;
        #(`P); check;
        addr = 2; w_out = 1;
        #(`P); check;
        addr = 4; w_out = {6'b000101, 192'd0};
        #(`P); check;
        addr = 8; w_out = {6'b001001, 192'd0};
        #(`P); check;
        addr = 16; w_out = {6'b010101, 192'd0};
        #(`P); check;
        addr = 0; w_out = 0; w_effective = 0;
        #(`P); check;
        $display("Good");
        $finish;
	end

    initial #100 forever #(`P/2) clk = ~clk;

    task check;
      begin
        if (out !== w_out || effective !== w_effective)
            $display("E %d %h %h", addr, out, w_out);
      end
    endtask
endmodule

