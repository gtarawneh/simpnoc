`timescale 1ns/1ps

`include "generator.v"
`include "rx.v"
`include "tx.v"
`include "packet_source.v"

module testbench_rx();

	localparam DURATION = 180; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

	// channel interface:
	wire [7:0] ch_flit;

	// switch interface
	wire [2:0] sw_chnl;

	// buffer interface
	wire [2:0] buf_addr;
	wire [7:0] buf_data;

	// source

	packet_source #(
		.ID(0),
		.DESTINATION_BITS(1),
		.DESTINATION(1),
		.FLITS(8),
		.SIZE(8),
		.PAYLOAD(-1)
	) s1 (
		clk, reset, ch_req, ch_ack, ch_flit
	);

	rx u2 (
		clk,
		reset,
		ch_req,
		ch_flit,
		ch_ack,
		sw_req,
		sw_chnl,
		sw_gnt,
		buf_addr,
		buf_data
	);

	wire [7:0] ch2_flit;

	tx u3 (
		clk,
		reset,
		ch2_req,
		ch2_flit,
		ch2_ack,
		sw_req,
		sw_chnl,
		sw_gnt,
		buf_addr,
		buf_data
	);

	assign ch2_ack = ch2_req;

endmodule
