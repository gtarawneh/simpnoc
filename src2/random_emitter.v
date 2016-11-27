`ifndef _inc_random_emitter_
`define _inc_random_emitter_

`include "debug_tasks.v"

module random_emitter (clk, reset, req, ack, data);

	parameter ID = 0;
	parameter SIZE = 8;
	parameter PERC_ACTIVE = 100;
	parameter MAX_FLITS = 8;

	input clk, reset, ack;
	output reg req;
	output reg [SIZE-1:0] data;

	reg [7:0] flits;

	integer seed = ID;

	reg [SIZE-1:0] payload;

	reg [7:0] random_activity;

	DebugTasks DT();

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			data <= 0;
			req <= 0;
			flits <= 0;
			payload = $urandom(seed);

		end else begin

			random_activity = $urandom(seed) % 100;

			if (!req && !ack && (flits < MAX_FLITS) && (random_activity < PERC_ACTIVE)) begin

				payload = $urandom(seed);
				data <= payload;
				req <= 1;
				flits <= (flits<128) ? flits + 1 : flits;
				DT.printPrefix("Emitter", ID);
				$display("requesting <%g>", payload);

			end else if (req & ack) begin

				DT.printPrefix("Emitter", ID);
				$display("received ack");
				req <= 0;

			end

		end

	end

endmodule

`endif
