`ifndef _inc_packet_sink_
`define _inc_packet_sink_

`include "debug_tasks.v"

module packet_sink (
		clk,
		reset,
		ch_req,
		ch_flit,
		ch_ack
	);

	// parameters:

	parameter ID = 0;
	parameter SIZE = 8; // flit size (bits)
	parameter BUFF_BITS = 3; // buffer address bits
	parameter SINK_RATE = 1024; // max 1024
	parameter SEED = 1; // for random sinking
	parameter VERBOSE_DEBUG = 1;

	localparam PORT_BITS = 3; // don't care
	localparam DEST_BITS = 8; // don't care
	localparam FLIT_COUNT = 2 ** BUFF_BITS;

	// inputs:

	input clk, reset;

	// channel interface:

	input ch_req;
	input [SIZE-1:0] ch_flit;
	output ch_ack;

	// switch interface:

	wire sw_req;
	wire [PORT_BITS-1:0] sw_chnl;
	wire sw_gnt = 0;

	// buffer interface:

	wire [BUFF_BITS-1:0] buf_addr;
	wire [SIZE-1:0] buf_data = 0;

	// routing table interface:

	wire [DEST_BITS-1:0] table_addr;
	wire [PORT_BITS-1:0] table_data = 0;

	// RX instance

	rx #(
		.SIZE(SIZE),
		.BUFF_BITS(BUFF_BITS),
		.PORT_BITS(PORT_BITS),
		.DEST_BITS(DEST_BITS),
		.MOD_NAME("Packet Sink"),
		.ID(ID),
		.SINK_PACKETS(1),
		.SEED(SEED),
		.SINK_RATE(SINK_RATE),
		.VERBOSE_DEBUG(VERBOSE_DEBUG)
	) u2 (
		clk,
		reset,
		ch_req,
		ch_flit,
		ch_ack,
		sw_req,
		sw_chnl,
		sw_gnt,
		buf_addr,
		buf_data,
		table_addr,
		table_data
	);

endmodule

`endif
