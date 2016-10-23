`ifndef _inc_constants_
	`define _inc_constants_
	`include "constants_2D.v"
`endif

`ifndef _inc_tx_
	`define _inc_tx_
	`include "tx.v"
`endif

module serial_source (clk, reset, serial_out, busy);

 	parameter destination = `NUM_NODES-1;

	parameter id = 0;

	parameter max_flits = -1;

	input clk, reset, busy;

	output serial_out;

	wire [`SIZE-1:0] data;

	source #(.destination(destination), .id(id), .max_flits(max_flits)) s1 (clk, reset, data, req, tx_busy);

	tx tx1 (clk, reset, req, tx_busy, busy, data, serial_out, active);

endmodule

module source (clk, reset, data, req, busy);

	parameter destination = `NUM_NODES-1;

	parameter id = 0;

	parameter max_flits = -1;

	input clk, reset, busy;

	output req;

	output [`SIZE-1:0] data;

	reg [`SIZE-1:0] data;

	reg [7:0] flits;

	reg req;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			data <= 0;
			req <= 0;
			flits <= 0;

		end else begin

			if (!busy && flits<max_flits) begin

				data <= destination;
				req <= 1;
				flits <= (flits<128) ? flits + 1 : flits;

				$display ("[%g] source %g: sent %g to destination %g", $time, id, flits, destination);

			end else begin

				req <= 0;

			end

		end

	end

endmodule
