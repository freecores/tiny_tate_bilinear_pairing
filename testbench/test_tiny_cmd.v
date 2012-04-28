`timescale 1ns / 1ps
`define P 20 // clock period 

module test_tiny_cmd;

	// Inputs
	reg clk;
	reg reset;
	reg sel;
	reg [5:0] addr;
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
        reset = 1; // keep FSM silent
        // init x, y
        // addr[3] = x
        sel = 1; w = 1;
        addr = 3;
        data = 194'h288162298554054820552a05426081a1842886a58916a6249;
        #(`P);
        // addr[6] = x
        addr = 6; 
        #(`P);
        // addr[5] = y
        data = 194'h2895955069089214054596a189a4420556589054140941695;
        addr = 5; 
        #(`P);
        // addr[7] = y
        addr = 7; 
        #(`P);
        
        sel = 1; w = 0; /*read back*/
        addr = 3; #(`P);
        $display("xp = %h", out);
        addr = 5; #(`P);
        $display("yp = %h", out);
        addr = 6; #(`P);
        $display("xq = %h", out);
        addr = 7; #(`P);
        $display("yq = %h", out);

        reset = 0;
        $finish;
        
        sel = 0; w = 0;
        @(posedge done);
        @(negedge clk);
        sel = 1; w = 0;
        addr = 3; #(`P);
        $display("xp = %h", out);
        addr = 5; #(`P);
        $display("yp = %h", out);
        addr = 6; #(`P);
        $display("xq = %h", out);
        addr = 7; #(`P);
        $display("yq = %h", out);
        addr = 9; #(`P);
        $display("t0 = %h", out);
        addr = 10; #(`P);
        $display("t1 = %h", out);
        addr = 11; #(`P);
        $display("t2 = %h", out);
        addr = 12; #(`P);
        $display("t3 = %h", out);
        addr = 13; #(`P);
        $display("t4 = %h", out);
        addr = 14; #(`P);
        $display("t5 = %h", out);
        addr = 15; #(`P);
        $display("R0 = %h", out);
        addr = 17; #(`P);
        $display("R1 = %h", out);
        addr = 18; #(`P);
        $display("R2 = %h", out);
        addr = 19; #(`P);
        $display("R3 = %h", out);
        addr = 20; #(`P);
        $display("R4 = %h", out);
        addr = 21; #(`P);
        $display("R5 = %h", out);
        
        $finish;
	end

    initial #100 forever #(`P/2) clk = ~clk;
endmodule

