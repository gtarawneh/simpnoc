`timescale 1ns/1ps

`include "generator.v"
`include "arbiter.v"
`include "random_emitter.v"
`include "random_consumer.v"

module testbench_rx();

	localparam DURATION = 500; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

	wire [4:0] reqs_in;
	wire [4:0] acks_in;
	wire [2:0] selected;

	wire [7:0] datas_in [4:0];

	localparam P = 5;

	random_emitter #(.PERC_ACTIVE(P), .ID(0)) s1 (clk, reset, reqs_in[0], acks_in[0], datas_in[0]);
	random_emitter #(.PERC_ACTIVE(P), .ID(1)) s2 (clk, reset, reqs_in[1], acks_in[1], datas_in[1]);
	random_emitter #(.PERC_ACTIVE(P), .ID(2)) s3 (clk, reset, reqs_in[2], acks_in[2], datas_in[2]);
	random_emitter #(.PERC_ACTIVE(P), .ID(3)) s4 (clk, reset, reqs_in[3], acks_in[3], datas_in[3]);
	random_emitter #(.PERC_ACTIVE(P), .ID(4)) s5 (clk, reset, reqs_in[4], acks_in[4], datas_in[4]);

	random_consumer c1 (clk, reset, req_out, ack_out, datas_in[selected]);

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
