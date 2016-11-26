`ifndef _inc_packet_source_
`define _inc_packet_source_

`include "debug_tasks.v"

module packet_source (clk, reset, req, ack, data);

	parameter ID = 0;
	parameter DESTINATION = 0;
	parameter FLITS = 8;
	parameter SIZE = 8;
	parameter PAYLOAD = 4;
	parameter DESTINATION_BITS = 4;

	localparam PAYLOAD_BITS = SIZE - DESTINATION_BITS;

	input clk, reset, ack;
	output reg req;
	output reg [SIZE-1:0] data;

	reg [SIZE-1:0] MEM_BUF [FLITS-1:0];

	integer seed = ID;

	wire [DESTINATION_BITS-1:0] destination = DESTINATION;

	reg [PAYLOAD_BITS-1:0] payload;

	reg [7:0] flit_counter;
	reg ack_old;
	reg busy;
	wire ack_received = ack ^ ack_old;

	DebugTasks DT();

	integer i;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			data <= 0;
			req <= 0;
			flit_counter <= 0;
			ack_old <= 0;
			busy <= 0;
			for (i=0; i<FLITS; i=i+1)
				MEM_BUF[i] <= $urandom(seed);

		end else begin

			ack_old <= ack;

			if (!busy && flit_counter<FLITS) begin

				if (flit_counter == 0) begin
					DT.printPrefix("Source", ID);
					$display("beginning packet <0x%h>", {
						MEM_BUF[7],
						MEM_BUF[6],
						MEM_BUF[5],
						MEM_BUF[4],
						MEM_BUF[3],
						MEM_BUF[2],
						MEM_BUF[1],
						MEM_BUF[0]
					});
				end

				payload = (PAYLOAD == -1) ? $urandom(seed) : PAYLOAD;
				data <= MEM_BUF[flit_counter];
				req <= ~req;
				flit_counter <= flit_counter + 1;
				busy <= 1;
				DT.printPrefix("Source", ID);
				$display("sending <%g>", {payload, destination});

			end else if (busy & ack_received) begin

				DT.printPrefix("Source", ID);
				$display("received ack");
				busy <= 0;

			end

		end

	end

endmodule

`endif
