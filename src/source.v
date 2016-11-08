`ifndef _inc_source_
`define _inc_source_

module source (clk, reset, req, ack, data);

	parameter ID = 0;
	parameter DESTINATION = 0;
	parameter MAX_FLITS = 2;
	parameter SIZE = 8;
	parameter PAYLOAD = 4;
	parameter DESTINATION_BITS = 4;

	localparam PAYLOAD_BITS = SIZE - DESTINATION_BITS;

	input clk, reset, ack;
	output reg req;
	output reg [SIZE-1:0] data;

	wire [DESTINATION_BITS-1:0] destination = DESTINATION;
	wire [PAYLOAD_BITS-1:0] payload = PAYLOAD;

	reg [7:0] flits;
	reg ack_old;
	reg busy;
	wire ack_received = ack ^ ack_old;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			data <= 0;
			req <= 0;
			flits <= 0;
			ack_old <= 0;
			busy <= 0;

		end else begin

			ack_old <= ack;

			if (!busy && flits<MAX_FLITS) begin

				data <= {payload, destination};
				req <= ~req;
				flits <= (flits<128) ? flits + 1 : flits;
				busy <= 1;
				$display ("#%3d, %10s [%1d] : sending <%g> to destination <%g>", $time, "Source", ID, PAYLOAD, DESTINATION);

			end else if (busy & ack_received) begin

				$display ("#%3d, %10s [%1d] : received ack", $time, "Source", ID);
				busy <= 0;

			end

		end

	end

endmodule

`endif
