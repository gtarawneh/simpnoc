`ifndef _inc_arbiter_
`define _inc_arbiter_

// round robin arbiter

`include "debug_tasks.v"

module arbiter (
		clk,
		reset,
		reqs_in,
		acks_in,
		req_out,
		ack_out,
		selected,
		active
	);

	DebugTasks DT();

	parameter ID = 0;
	parameter SUBID = 0;
	parameter PORTS = 5; // number of clients (255 max)
	parameter PORT_BITS = 3;

	// inputs:

	input clk, reset;

	input [PORTS-1:0] reqs_in;
	output reg [PORTS-1:0] acks_in;

	output reg req_out;
	input ack_out;

	output reg [PORT_BITS-1:0] selected;

	output reg active; // 1 when handshake in progress, 0 otheriwse

	// body

	wire sel_req = reqs_in[selected];
	wire sel_ack = acks_in[selected];

	integer i;
	integer j;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			selected <= 0;
			acks_in <= 0;
			req_out <= 0;
			active <= 0;

		end else begin

			if (~active) begin : BLOCK1

				for (i=0; i<PORTS && !active; i=i+1) begin

					j = (i + selected) % PORTS;

					if (reqs_in[j] == 1) begin
						DT.printPrefixSub("Arbiter", SUBID, ID);
						$display("start handshake (port %g)", j);
						selected = j;
						req_out = 1;
						active = 1;
					end

				end

			end else begin

				req_out = reqs_in[selected];
				acks_in[selected] = ack_out;

				// DT.printPrefixSub("Arbiter", SUBID, ID);
				// $display("req_out = %g, ack_out = %g", req_out, ack_out);

				if (~req_out && ~ack_out) begin
					DT.printPrefixSub("Arbiter", SUBID, ID);
					$display("finished handshake");
					active = 0;
				end

			end

		end

	end

endmodule

`endif
