`ifndef _inc_generator_
`define _inc_generator_

module generator (clk, reset);

	output reg clk, reset;

	initial begin
		reset <= 1;
		clk <= 0;
		#0.5 reset <= 0;
	end

	always begin
		#0.5 clk <= ~clk;
	end

endmodule

`endif
