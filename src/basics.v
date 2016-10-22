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

module generator(clk, reset);

	output clk, reset;

	reg clk, reset;

	initial begin
		clk = 0;
		#0 reset = 1;
		#0.5 reset = 0;
	end

	always	begin
		#1 clk = !clk;
	end

endmodule
