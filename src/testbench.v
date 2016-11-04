`timescale 1ns/1ps

`include "noc.v"

module testbench();

	localparam DURATION = 50; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

	noc n1 (clk, reset);

endmodule
