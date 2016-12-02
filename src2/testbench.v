`timescale 1ns/1ps

`include "noc.v"

module testbench();

	localparam PAD_DELAY = 0; // cycles to simulate after all packets sent

	always @(done) if (done) #PAD_DELAY $finish;

	wire clk, reset, done;

	generator u1 (clk, reset);

	noc n1 (clk, reset, done);

endmodule
