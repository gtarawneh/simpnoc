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
		selected
	);

	DebugTasks DT();

	parameter COUNT = 5; // number of clients
	parameter COUNT_BITS = 3;

	// inputs:

	input clk, reset;

	input [COUNT-1:0] reqs_in;
	output reg [COUNT-1:0] acks_in;

	output reg req_out;
	input ack_out;

	output reg [COUNT_BITS-1:0] selected;

	reg handshake_active; // state register

	// body

	wire sel_req = reqs_in[selected];
	wire sel_ack = acks_in[selected];

	integer i;
	integer j;
	integer selected_next;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			selected <= 0;
			acks_in <= 0;
			req_out <= 0;
			handshake_active <= 0;

		end else begin

			// if (~sel_req & ~sel_ack) begin
			if (~handshake_active) begin

				selected_next = selected;

				for (i=0; i<COUNT && (selected_next == selected); i=i+1) begin

					j = (i + selected) % COUNT;

					if (reqs_in[j] == 1) begin
						DT.printPrefix("Arbiter", 0);
						$display("start handshake (channel %g)", j);
						selected_next = j;
						req_out = 1;
						handshake_active = 1;
					end

				end

				selected = selected_next;

			end else begin

				req_out = reqs_in[selected];
				acks_in[selected] = ack_out;

				if (~req_out && ~ack_out) begin
					DT.printPrefix("Arbiter", 0);
					$display("finished handshake (channel %g)", selected);
					handshake_active = 0;
				end

			end

		end

	end

endmodule

`endif
