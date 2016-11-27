`ifndef _inc_random_consumer_
`define _inc_random_consumer_

`include "debug_tasks.v"

module random_consumer (clk, reset, req, ack, data);

	parameter ID = 0;
	parameter SIZE = 8;

	input clk, reset, req;

	input [SIZE-1:0] data;

	output reg ack;

	reg req_old;

	DebugTasks DT();

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			ack <= 0;
			req_old <= 0;

		end else begin

			req_old <= req;

			ack <= req;

			if (req & !req_old) begin

				DT.printPrefix("Consumer", ID);

				$display("received <%g>", data);

			end

		end
	end

endmodule

`endif
