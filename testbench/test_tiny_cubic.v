`timescale 1ns / 1ps
`define P 20 // clock period

module test_tiny_cubic;

	// Inputs
	reg clk;
	reg reset;
	reg sel;
	reg [6:0] addr;
	reg w;
	reg [197:0] data;

	// Outputs
	wire [197:0] out;
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
        
        write(0, {6'b010101, 192'd0}); // cmd for cubic
        write(1, {6'b000101, 192'd0}); // cmd for addition
        write(2, {6'b001001, 192'd0}); // cmd for subtraction
        write(3, 0); // the data of zero
        write(4, 1); // the data of one
        
        read(0);
        read(1);
        read(2);
        read(3);
        read(4);
        
        $finish;
	end
    
    initial #100 forever #(`P/2) clk = ~clk;
    
    task write;
        input [6:0] adr;
        input [197:0] dat;
        begin
            sel = 1; 
            w = 1;
            addr = adr;
            data = dat;
            #(`P);
        end
    endtask

    task read;
        input [6:0] adr;
        begin
            sel = 1; 
            w = 0;
            addr = adr;
            #(`P);
        end
    endtask;
endmodule

