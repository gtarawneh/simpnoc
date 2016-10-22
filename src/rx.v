`ifndef SIZE
	`define SIZE 8
`endif

module rx (clk, reset, valid, channel_busy, item_read, serial_in, parallel_out);

	parameter routerid=-1;
	parameter port="unknown";

	input clk, reset, item_read, serial_in;

	output valid, channel_busy;

	output [`SIZE-1:0] parallel_out;

	reg [1:0] state; // 0 = idle, 1 = receiving, 2 = delivering item

	reg [`SIZE:0] item;

	assign parallel_out = item;

	assign valid = (state == 2);

	assign channel_busy = (state != 0);

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			item <= 0;

			state <= 0;

		end else begin

			if (state == 0 & serial_in) begin

				// transition from 'idle' to 'receiving' on arrival of flit head (high bit)

				state <= 1;

			end

			if (state != 2) begin

				// continue receiving and shifting

				item[`SIZE-1:0] <= item [`SIZE:1];

				item[`SIZE] <= serial_in;

				if (item[0]) begin

					state <= 2; // item received when LSB is 1

					if (routerid > -1) begin
						$display("[%g] router %2d: (%s) received : %d", $time, routerid, port, item>>1);
					end

				end

			end

			if (state == 2 & item_read) begin

				// item transferred, switch back to 'idle'

				state <= 0;

				item <= 0;

			end

		end

	end

endmodule
