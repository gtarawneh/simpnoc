module source2 (clk, reset, req, ack, data);

	parameter destination = 0;

	parameter id = 0;

	parameter max_flits = 2;

	input clk, reset, ack;

	output reg req;

	output reg [`SIZE-1:0] data;

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

			if (!busy && flits<max_flits) begin

				data <= destination;

				req <= ~req;

				flits <= (flits<128) ? flits + 1 : flits;

				busy <= 1;

				$display ("[%g] source %g: sent %g to destination %g", $time, id, flits, destination);

			end else if (busy & ack_received) begin

				busy <= 0;

			end

		end

	end

endmodule
