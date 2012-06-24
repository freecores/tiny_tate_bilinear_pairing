`timescale 1ns / 1ps
`define P 20 // clock period 

module test_tiny;

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
            write(3, 194'h21181940120548aa020568aa65a5989609251595a89a44598);
            write(5, 194'h0a905590506a8a845592a09644a2095291422910a968a5048);
            write(6, 194'h21181940120548aa020568aa65a5989609251595a89a44598);
            write(7, 194'h0a905590506a8a845592a09644a2095291422910a968a5048);
            /* read back. uncomment me if error happens */
            /* read(3);
            $display("xp = %h", out);
            read(5);
            $display("yp = %h", out);
            read(6);
            $display("xq = %h", out);
            read(7);
            $display("yq = %h", out);*/
        reset = 0;
        sel = 0; w = 0;
        @(posedge done);
        @(negedge clk);
            read(3);
            check(194'h21181940120548aa020568aa65a5989609251595a89a44599);
            read(5);
            check(194'h0560aa60a0954548aa615069885106a16281162056945a084);
            read(6);
            check(194'h21181940120548aa020568aa65a5989609251595a89a44598);
            read(7);
            check(194'h0a905590506a8a845592a09644a2095291422910a968a5048);
            read(9);
            check(194'h09a49266428495042842965645266a2164a1268408a669866);
            read(10);
            check(194'h204446152452400968480544296829199a169a2562a908520);
            read(11);
            check(194'h1699142918666651a156954a80544689590a5094624610281);
            read(12);
            check(194'h2461998924145511611291626a4a295888569280285884661);
            read(13);
            check(194'h1040525045a404150a1881aa91a99156660a1658a090a1091);
            read(14);
            check(194'h2400a94249694808254880924a06494816081900811198925);
            $display("Good");
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
    endtask

    task check;
        input [197:0] wish;
        begin
            if (out !== wish) 
                begin $display("Error!"); $finish; end
        end
    endtask    
endmodule

