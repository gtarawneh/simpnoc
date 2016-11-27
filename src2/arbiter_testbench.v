`timescale 1ns/1ps

`include "generator.v"
`include "arbiter.v"

module testbench_rx();

	localparam DURATION = 20; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

	reg [4:0] reqs_in;
	reg ack_out;
	wire [4:0] acks_in;
	wire [2:0] selected;

	initial begin
		reqs_in <= 0;
		ack_out <= 0;
		#2
		reqs_in[1] <= 1;
		reqs_in[2] <= 1;
		#2
		ack_out <= 1;
		#2
		reqs_in[1] <= 0;
		#2
		ack_out <= 0;


	end

	always begin
		#1 $display("%g %g, %g %g: %g %g (selected=%g)", reqs_in[1], acks_in[1], reqs_in[2], acks_in[2], req_out, ack_out, selected);
	end

	arbiter a1 (
		clk,
		reset,
		reqs_in,
		acks_in,
		req_out,
		ack_out,
		selected
	);

endmodule
