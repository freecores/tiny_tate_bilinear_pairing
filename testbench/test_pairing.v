`timescale 1ns / 1ps
`define P 20 // clock period 

module test_pairing;

	// Inputs
	reg clk;
	reg reset;
	reg sel;
	reg [5:0] addr;
	reg w;
    reg update;
    reg ready;
    reg i;

	// Outputs
	wire done;
    wire o;

    // Buffers
	reg [197:0] out;

	// Instantiate the Unit Under Test (UUT)
	pairing uut (
        .clk(clk), 
        .reset(reset), 
        .sel(sel), 
        .addr(addr), 
        .w(w), 
        .update(update),
        .ready(ready),
        .i(i),
        .o(o),
        .done(done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		sel = 0;
		addr = 0;
		w = 0;
        update = 0;
        ready = 0;
        i = 0;
        out = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        /* keep FSM silent */
        reset = 1;
            /* init xp, yp, xq, yq */
            write(3, 194'h288162298554054820552a05426081a1842886a58916a6249);
            write(5, 194'h2895955069089214054596a189a4420556589054140941695);
            write(6, 194'h288162298554054820552a05426081a1842886a58916a6249);
            write(7, 194'h2895955069089214054596a189a4420556589054140941695);
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
            check(194'h288162298554054820552a05426081a1842886a58916a624a);
            read(5);
            check(194'h146a6aa0960461280a8a69524658810aa9a460a828068296a);
            read(6);
            check(194'h288162298554054820552a05426081a1842886a58916a6249);
            read(7);
            check(194'h2895955069089214054596a189a4420556589054140941695);
            read(9);
            check(194'h0580908654985206a92415296589411858a9211984160a180);
            read(10);
            check(194'h0501a2129024a92511058540424059509a55982a065252924);
            read(11);
            check(194'h06624689a2149059841a814409946196a92a06595029a2994);
            read(12);
            check(194'h2a10a642a56aa9a26458a801285221820aa98226402100889);
            read(13);
            check(194'h06a99a1556a662900898a49026640509924a1210121809886);
            read(14);
            check(194'h2a88582860a80605825150584a8a8099491029242961a5685);
            $display("Good");
        $finish;
	end

    initial #100 forever #(`P/2) clk = ~clk;

    task write;
        input [5:0] adr;
        input [197:0] dat;
        integer j;
        begin
            sel = 1; 
            w = 0;
            addr = adr;
            update = 1;
            #`P;
            update = 0;
            ready = 1;
            for(j=0;j<198;j=j+1)
               begin
               i = dat[j];
               #`P;
               end
            ready = 0;
            w = 1; #`P; w = 0;
        end
    endtask

    task read;
        input [5:0] adr;
        integer j;
        begin
            sel = 1;
            w = 0;
            addr = adr;
            #`P;
            update = 1;
            #`P;
            update = 0;
            out = 0;
            ready = 1;
            for(j=0;j<198;j=j+1)
               begin
               out = {o, out[197:1]};
               #`P;
               end
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

