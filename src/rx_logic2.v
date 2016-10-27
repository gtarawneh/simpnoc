`ifndef SIZE
	`define SIZE 8
`endif

// this modules receives incoming data items from 5 senders (using two-phase
// handshakes) and picks one at a time to push into a fifo

module rx_logic_2 (
		clk,
		reset,
		fifo_push_req,
		fifo_push_ack,
		fifo_push_data,
		fifo_write,
		fifo_full,
		fifo_data_in,
	);

	parameter id = -1; // parent router id

	input clk, reset;

	// fifo_push interfaces (with the senders)

	input [4:0] fifo_push_req;

	output reg [4:0] fifo_push_ack;

	input [`SIZE*5-1:0] fifo_push_data;

	wire [`SIZE-1:0] fifo_push_data_arr [4:0];

	genvar k;
	generate
		for (k=0; k<5; k=k+1) begin
			localparam s = 8 * (k-1);
			assign fifo_push_data_arr[k] = fifo_push_data[s+7:s];
		end
	endgenerate

	// fifo interface:

	output reg fifo_write;

	input fifo_full;

	output reg [`SIZE-1:0] fifo_data_in;

	// internal nets:

	wire [2:0] selectedNum;

	reg [4:0] fifo_push_req_old = 0;

	// body

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			fifo_push_ack <= 0;

			fifo_push_req_old <= 0;

			fifo_write <= 0;

		end else begin : BLOCK1

			integer i;

			if (fifo_full) begin

				fifo_write <= 0;

			end else begin

				fifo_write = 0;

				for (i=0; i<5; i=i+1) begin

					if (fifo_push_req[i] ^ fifo_push_req_old[i]) begin

						fifo_write = 1;

						fifo_push_ack[i] = !fifo_push_ack[i];

						fifo_data_in = fifo_push_data_arr[i];

					end

				end

				fifo_push_req_old <= fifo_push_req;

			end

		end

	end

endmodule
