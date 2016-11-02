// this modules picks items from a fifo, one at a time, and sends them to one
// of several tx transceivers that use 2-phase handshakes

module tx_logic_2 (
		clk,
		reset,
		fifo_read,
		fifo_empty,
		fifo_item_out,
		fifo_pop_req,
		fifo_pop_ack,
		fifo_pop_data,
		table_addr,
		table_data
	);

	parameter ID = -1; // module id
	parameter SIZE = 8; // data bits
	parameter PORT_COUNT = 5; // number of ports
	parameter STATE_BITS = 2; // number of state bits
	parameter DESTINATION_BITS = 3; // number of bits to specify port

	input clk, reset;

	// fifo interface:

	output reg fifo_read;
	input fifo_empty;
	input [SIZE-1:0] fifo_item_out;

	// fifo_pop interface:

	output reg [PORT_COUNT-1:0] fifo_pop_req;
	input [PORT_COUNT-1:0] fifo_pop_ack;
	output [PORT_COUNT*SIZE-1:0] fifo_pop_data;

	// routing table

	output reg [SIZE-1:0] table_addr;
	input [DESTINATION_BITS-1:0] table_data;

	// internal nets

	reg [STATE_BITS-1:0] state;

	reg [SIZE-1:0] fifo_pop_data_arr [PORT_COUNT-1:0];

	reg [PORT_COUNT-1:0] tbusy; // tx transceiver busy

	reg [PORT_COUNT-1:0] fifo_pop_ack_old;

	wire [DESTINATION_BITS-1:0] destination;

	wire [PORT_COUNT-1:0] ack_received;

	assign ack_received = (fifo_pop_ack ^ fifo_pop_ack_old);

	assign destination = table_data;

	// pack fifo_pop_data_arr into fifo_pop_data

	genvar k;
	generate
		for (k=0; k<PORT_COUNT; k=k+1) begin
			localparam LSB = SIZE * k;
			localparam MSB = LSB + SIZE - 1;
			assign fifo_pop_data[MSB:LSB] = fifo_pop_data_arr[k];
		end
	endgenerate

	// local definitions

	localparam STATE_IDLE = 0;
	localparam STATE_GETTING_ADDR = 1;
	localparam STATE_WAIT_ACK = 2;

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			fifo_read <= 0;

			fifo_pop_req <= 0;

			fifo_pop_ack_old <= 0;

			tbusy <= 0;

			state <= STATE_IDLE;

		end else begin : BLOCK1

			// First, check if any tx transeivers received an ack and
			// clear the respective bits in tbusy:

			integer i;

			fifo_pop_ack_old <= fifo_pop_ack;

			tbusy <= tbusy & ~ack_received;

			for (i=0; i<PORT_COUNT; i=i+1) if (ack_received[i])
				$display("#%3d, %10s [%1d] : received ack from port <%g>", $time, "TX_LOGIC", ID, i);

			// Next, attempt to send the current fifo item:

			if (state == STATE_IDLE) begin

				// need to fetch destination port data

				// (address is the same as fifo item content for now)

				if (~fifo_empty) begin

					$display("#%3d, %10s [%1d] : found item <%g> in fifo, fetching routing address", $time, "TX_LOGIC", ID, fifo_item_out);

					table_addr <= fifo_item_out;

					state <= STATE_GETTING_ADDR;

				end

			end else if (state == STATE_GETTING_ADDR) begin : BLOCK2

				// got destination port data, send to transceiver (if not busy)

				if (tbusy[destination] == 0) begin

					$display("#%3d, %10s [%1d] : found destination port is <%g>, sending", $time, "TX_LOGIC", ID, destination);

					fifo_pop_data_arr[destination] <= fifo_item_out; // set data bits

					fifo_pop_req[destination] <= ~fifo_pop_req[destination]; // initiate request

					tbusy[destination] <= 1; // mark this transceiver as busy

					state <= STATE_WAIT_ACK;

					fifo_read <= 1;

				end

			end else if (state == STATE_WAIT_ACK) begin

				fifo_read <= 0;

				if (~tbusy[destination])
					state <= STATE_IDLE;

			end

		end

	end

endmodule
