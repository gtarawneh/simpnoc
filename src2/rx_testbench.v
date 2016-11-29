`timescale 1ns/1ps

`include "generator.v"
`include "rx.v"
`include "tx.v"
`include "packet_source.v"
`include "packet_sink.v"
`include "arbiter.v"

module testbench_rx();

	localparam DURATION = 1000; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

	localparam CHANNELS = 5;

	// switch interface
	wire [CHANNELS-1:0] sw_req;
	wire [CHANNELS-1:0] sw_ack;
	wire [2:0] sw_chnl [CHANNELS-1:0];
	// buffer interface
	wire [2:0] buf_addr [CHANNELS-1:0];
	wire [7:0] buf_data [CHANNELS-1:0];

	// source

	generate
		genvar i;
		for (i=0; i<CHANNELS; i=i+1) begin: Block1

			wire [7:0] ch_flit;

			packet_source #(
				.ID(i),
				.DESTINATION_BITS(1),
				.DESTINATION(1),
				.FLITS(8),
				.SIZE(8)
			) s1 (
				clk, reset, ch_req, ch_ack, ch_flit
			);

			rx #(
				.ID(i)
			) u2 (
				clk,
				reset,
				ch_req,
				ch_flit,
				ch_ack,
				sw_req[i],
				sw_chnl[i],
				sw_ack[i],
				buf_addr[i],
				buf_data[i]
			);

			// assign buf_addr[i] = arb_buf_addr;

		end
	endgenerate

	wire [2:0] selected;

	arbiter a1 (
		.clk(clk),
		.reset(reset),
		.reqs_in(sw_req),
		.acks_in(sw_ack),
		.req_out(arb_req),
		.ack_out(arb_gnt),
		.selected(selected)
	);

	wire [7:0] ch2_flit;

	wire [2:0] arb_buf_addr;

	assign buf_addr[0] = arb_buf_addr;
	assign buf_addr[1] = arb_buf_addr;
	assign buf_addr[2] = arb_buf_addr;
	assign buf_addr[3] = arb_buf_addr;
	assign buf_addr[4] = arb_buf_addr;

	wire [7:0] arb_buf_data = buf_data[selected];

	tx u3 (
		.clk(clk),
		.reset(reset),
		.ch_req(ch2_req),
		.ch_flit(ch2_flit),
		.ch_ack(ch2_ack),
		.sw_req(arb_req),
		.sw_chnl(sw_chnl[selected]),
		.sw_gnt(arb_gnt),
		.buf_addr(arb_buf_addr),
		.buf_data(arb_buf_data)
	);

	packet_sink u4 (
		clk,
		reset,
		ch2_req,
		ch2_flit,
		ch2_ack
	);

endmodule
