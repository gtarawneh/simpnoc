module sink2 (clk, reset, req, ack, data);

	parameter id = 0;

	input clk, reset, req;

	input [`SIZE-1:0] data;

	output reg ack;

	reg req_old;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			req_old <= 0;

			ack <= 0;

		end else begin

			req_old <= req;

			if (req ^ req_old) begin

				$display("#%3d, %10s [%1d] : received <%g>, acknowledging", $time, "Sink", id, data);

				ack <= ~ack;

			end

		end
	end

endmodule
