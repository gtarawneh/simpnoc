module generator (clk, reset);

	output reg clk, reset;

	initial begin
		reset <= 1;
		clk <= 0;
		#1
		reset <= 0;
	end

	always begin
		#0.5
		clk <= ~clk;
	end

endmodule
