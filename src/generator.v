module generator (clk, reset);

	output reg clk, reset;

	initial begin
		reset <= 1;
		clk <= 0;
		#1
		reset <= 0;
	end

	always begin
		#1
		clk <= ~clk;
	end

endmodule
