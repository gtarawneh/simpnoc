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

	wire [`SIZE-1:0] data_to_send;

	assign data_to_send = 4;

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

				// data <= destination;
				data <= data_to_send;

				req <= ~req;

				flits <= (flits<128) ? flits + 1 : flits;

				busy <= 1;

				$display ("#%3d, %10s [%1d] : sending <%g> to destination <%g>", $time, "Source", id, data_to_send, destination);

			end else if (busy & ack_received) begin

				$display ("#%3d, %10s [%1d] : received ack", $time, "Source", id);

				busy <= 0;

			end

		end

	end

endmodule
