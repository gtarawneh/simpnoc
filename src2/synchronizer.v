`ifndef _inc_synchronizer_
`define _inc_synchronizer_

`include "debug_tasks.v"

module synchronizer (
		input clk,
		input reset,
		input in,
		output out
	);

	parameter STAGES = 0;

	assign out = (STAGES>0) ? flops[STAGES-1] : in;

	reg [STAGES-1:0] flops;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			flops <= 0;

		end else begin

			if (STAGES>0)
				flops[0] <= in;

			if (STAGES>1)
				flops[STAGES-1:1] <= flops[STAGES-2:0];

		end

	end

endmodule

`endif
