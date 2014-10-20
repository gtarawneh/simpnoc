
module random_number(clk, reset, rand);

	parameter BITS = 32;
	
	input clk, reset;
	
	output [BITS-1:0] rand;
	
	reg [BITS-1:0] rand;
	
	always @(posedge clk or posedge reset) rand <= $random;

endmodule

module counter(clk, reset, ena, count);

	parameter BITS = 8;

	input clk, reset, ena;
	
	output [BITS-1:0] count;
	
	reg [BITS-1:0] count;
	
	always @(posedge clk or posedge reset) begin
	
		if (reset) begin
			count <= 0;
		end else begin
			if (ena) count <= count + 1;
		end
	
	end

endmodule 


module generator(clk, reset, send);
	parameter SIM_CYLES = 10000;
	parameter COOLDOWN_CYCLES = 5000;

	output clk, reset, send;
	
	reg clk, reset, send;

	initial 
	begin 
		clk = 0;
		#0 reset = 1; 
		#2 reset = 0;
	end 
	
	always 
	begin
		#1 clk = !clk;
	end
	
	initial $display("Start of simulation ...");
	
	  initial
         begin
            $dumpfile("dump1.vcd");
            $dumpvars(0,testbench);
         end

	
	initial     begin
		$display("Sending data ...");
		send=1;
		#(SIM_CYLES)
		$display("Cooling down ...");
		send=0;
		#(COOLDOWN_CYCLES)
		$display("End of simulation.");
		$finish;
	end


endmodule


