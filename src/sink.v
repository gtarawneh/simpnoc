`ifndef _inc_sink_
`define _inc_sink_

`include "debug_tasks.v"

module sink (clk, reset, req, ack, data);

	parameter ID = 0;
	parameter SIZE = 8;
	parameter DESTINATION_BITS = 4; // number of bits to specify destination
	parameter PORT_BITS = 4; // number of bits to specify port

	input clk, reset, req;

	input [SIZE-1:0] data;

	output reg ack;

	reg req_old;

	DebugTasks DT();

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			req_old <= 0;

			ack <= 0;

		end else begin

			req_old <= req;

			if (req ^ req_old) begin

				DT.printPrefix("Sink", ID);

				// $display("hello");

				$display("received <%g:%g>, acknowledging", data[SIZE-1:DESTINATION_BITS], data[DESTINATION_BITS-1:0]);

				ack <= ~ack;

			end

		end
	end

endmodule

`endif
