`timescale 1ns/1ps

`include "generator.v"
`include "rx.v"
`include "tx.v"
`include "packet_source.v"
`include "packet_sink.v"
`include "arbiter.v"

`include "debug_tasks.v"

module router();

	localparam SEED = 5;
	localparam CHANNELS = 5;
	localparam CHANNEL_BITS = 8;

	DebugTasks DT();

	localparam DURATION = 500; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

	// rx channel interface:
	wire rx_ch_req [CHANNELS-1:0];
	wire rx_ch_ack [CHANNELS-1:0];
	wire [7:0] rx_ch_flit [CHANNELS-1:0];

	// switch interface:
	wire [CHANNELS-1:0] rx_sw_req;
	reg [CHANNELS-1:0] rx_sw_ack;
	wire [2:0] rx_sw_chnl [CHANNELS-1:0];

	// buffer interface:
	reg [2:0] rx_buf_addr [CHANNELS-1:0];
	wire [7:0] rx_buf_data [CHANNELS-1:0];

	// tx channel interface:
	wire [CHANNELS-1:0] tx_ch_req;
	wire [CHANNELS-1:0] tx_ch_ack;
	wire [7:0] tx_ch_flit [CHANNELS-1:0];

	// arbiters:
	wire [CHANNEL_BITS-1:0] selected [CHANNELS-1:0];
	wire arb_active [CHANNELS-1:0];
	wire [2:0] tx_buf_addr [CHANNELS-1:0];
	reg [7:0] tx_buf_data [CHANNELS-1:0];
	reg [CHANNELS-1:0] arb_reqs_in [CHANNELS-1:0];
	wire [CHANNELS-1:0] arb_acks_in [CHANNELS-1:0];
	wire [CHANNELS-1:0] tx_sw_req;
	wire [CHANNELS-1:0] tx_sw_ack;

	generate

		genvar i;

		for (i=0; i<CHANNELS; i=i+1) begin: BLOCK1

			packet_source #(
				.ID(i),
				.DESTINATION_BITS(1),
				.DESTINATION(1),
				.FLITS(8),
				.SIZE(8),
				.SEED(i + SEED)
			) s1 (
				clk, reset, rx_ch_req[i], rx_ch_ack[i], rx_ch_flit[i]
			);

			rx #(
				.ID(i),
				.DESTINATION(i)
			) u2 (
				clk,
				reset,
				rx_ch_req[i],
				rx_ch_flit[i],
				rx_ch_ack[i],
				rx_sw_req[i],
				rx_sw_chnl[i],
				rx_sw_ack[i],
				rx_buf_addr[i],
				rx_buf_data[i]
			);

			arbiter #(
				.ID(i),
				.CHANNELS(CHANNELS),
				.CHANNEL_BITS(CHANNEL_BITS)
			) a1 (
				.clk(clk),
				.reset(reset),
				.reqs_in(arb_reqs_in[i]),
				.acks_in(arb_acks_in[i]),
				.req_out(tx_sw_req[i]),
				.ack_out(tx_sw_ack[i]),
				.selected(selected[i]),
				.active(arb_active[i])
			);

			tx u3 (
				.clk(clk),
				.reset(reset),
				.ch_req(tx_ch_req[i]),
				.ch_flit(tx_ch_flit[i]),
				.ch_ack(tx_ch_ack[i]),
				.sw_req(tx_sw_req[i]),
				.sw_gnt(tx_sw_ack[i]),
				.buf_addr(tx_buf_addr[i]),
				.buf_data(tx_buf_data[i])
			);

			packet_sink #(
				.ID(i)
			) u4 (
				clk,
				reset,
				tx_ch_req[i],
				tx_ch_flit[i],
				tx_ch_ack[i]
			);

		end

	endgenerate

	// RX/Arbiter/TX connections:

	generate

		// ack from arbiter to rx

		genvar j;

		for (j=0; j<CHANNELS; j=j+1) begin

			reg [2:0] chnl;

			always @(*) begin

				chnl = rx_sw_chnl[j];

				rx_sw_ack[j] = arb_acks_in[chnl][j];

				DT.printPrefix("Router", 0);
				$display("made connection: RX %g <--ack(%g)--- arbiter %g", j, rx_sw_ack[j], chnl);

			end

		end

		// req from rx to arbiter

		for (i=0; i<CHANNELS; i=i+1) begin
		for (j=0; j<CHANNELS; j=j+1) begin

			// arbiter i, input j

			reg [2:0] chnl;

			always @(*) begin

				chnl = rx_sw_chnl[j];

				arb_reqs_in[i][j] = (chnl == i) ? rx_sw_req[j] : 0;

				DT.printPrefix("Router", 0);
				$display("made connection: RX %g ---req(%g)--> arbiter %g", j, arb_reqs_in[i][j], chnl);

			end

		end
		end

		// data from rx to (selected) tx

		for (i=0; i<CHANNELS; i=i+1) begin

			always @(*) begin

				// tx_buf_data[i] = 0;
				// rx_buf_addr[selected[i]] = 0;

				tx_buf_data[i] = rx_buf_data[selected[i]];
				// rx_buf_addr[selected[i]] = tx_buf_addr[i];

				DT.printPrefix("Router", 0);
				$display("made connection: RX %g ---dat(0x%h)--> TX %g", selected[i], tx_buf_data[i], i);

			end

		end

		// address from (selected) tx to rx

		for (i=0; i<CHANNELS; i=i+1) begin // for reach RX instance

			reg found;

			integer k;

			always @(*) begin

				found = 0;

				for (k=0; k<CHANNELS && ~found; k=k+1) begin // loop through arbiters

					if ((selected[k] == i) && arb_active[k]) begin // if instance i is selected by arbiter k:

						rx_buf_addr[i] = tx_buf_addr[k];
						found = 1;
						DT.printPrefix("Router", 0);
						$display("made connection: RX %g <--adr(%g)--- TX %g", i, tx_buf_addr[k], k);

					end

				end

				if (~found) begin
					rx_buf_addr[i] = 0;
				end

			end

		end

	endgenerate

endmodule
