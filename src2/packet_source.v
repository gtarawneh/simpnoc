`ifndef _inc_packet_source_
`define _inc_packet_source_

`include "debug_tasks.v"

module packet_source (clk, reset, req, ack, data, done);

	// parameters

	parameter ID = 0;
	parameter FLITS = 8; // max 255
	parameter SIZE = 8;
	parameter SEED = 1;
	parameter PACKETS = 2; // max 255
	parameter VERBOSE_DEBUG = 1;
	parameter SOURCE_RATE = 1024; // max 1024

	// debugging modules

	DebugTasks DT();

	// inputs and output

	input clk, reset, ack;
	output reg req;
	output reg [SIZE-1:0] data;
	output reg done;

	reg [SIZE-1:0] MEM_BUF [FLITS-1:0];
	reg [7:0] flit_counter;
	reg [7:0] packet_counter;
	reg [15:0] ranNum;
	reg ack_old;
	reg busy;
	reg available; // randomized
	wire ack_received = ack ^ ack_old;
	wire more_flits = flit_counter < FLITS;
	wire more_packets = packet_counter < PACKETS;

	integer seed = SEED;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			data <= 0;
			req <= 0;
			flit_counter <= 0;
			packet_counter <= 0;
			ack_old <= 0;
			busy <= 0;
			done <= (PACKETS == 0);
			ranNum <= $urandom(seed);
			available <= 0;

		end else begin

			ranNum = $urandom(seed);
			available = ranNum < SOURCE_RATE;

			if (!busy && more_flits && more_packets) begin : BLOCK0

				if ((flit_counter>0) | available) begin

					if (flit_counter == 0) begin : BLOCK1

						// create packet

						integer i;

						for (i=0; i<FLITS; i=i+1) begin

							MEM_BUF[i] = $urandom(seed);

							MEM_BUF[i][SIZE-1] = 0; // mark flit as body

						end

						MEM_BUF[0][SIZE-1] = 1; // mark first flit as head

						DT.printPrefix("Packet Source", ID);
						$display("initiated packet <0x%h>", {
							MEM_BUF[7], MEM_BUF[6],
							MEM_BUF[5], MEM_BUF[4],
							MEM_BUF[3], MEM_BUF[2],
							MEM_BUF[1], MEM_BUF[0]
						});

					end

					// initialize handshake

					data <= MEM_BUF[flit_counter];
					req <= ~req;
					busy <= 1;
					flit_counter <= flit_counter + 1;

					if (VERBOSE_DEBUG) begin
						DT.printPrefix("Packet Source", ID);
						$display("sending <0x%h>", MEM_BUF[flit_counter]);
					end

				end

			end else if (busy & ack_received) begin

				busy <= 0;

				if (VERBOSE_DEBUG) begin
					DT.printPrefix("Packet Source", ID);
					$display("received ack");
				end

				if (~more_flits) begin

					flit_counter = 0;
					packet_counter = packet_counter + 1;

					if (more_packets) begin

						if (VERBOSE_DEBUG) begin
							DT.printPrefix("Packet Source", ID);
							$display("sending new packet");
						end

					end else begin

						done <= 1;

						if (VERBOSE_DEBUG) begin
							DT.printPrefix("Packet Source", ID);
							$display("finished sending all packets");
						end

					end

				end

			end

			// house keeping:

			ack_old <= ack;

		end

	end

endmodule

`endif
