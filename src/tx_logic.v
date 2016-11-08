`ifndef _inc_tx_logic_
`define _inc_tx_logic_

// this modules picks items from a fifo, one at a time, and sends them to one
// of several tx transceivers that use 2-phase handshakes

module tx_logic (
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
	parameter DESTINATION_BITS = 4; // number of bits to specify destination
	parameter PORT_BITS = 4; // number of bits to specify port

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

	output wire [DESTINATION_BITS-1:0] table_addr;
	input [PORT_BITS-1:0] table_data;

	// internal nets

	reg [SIZE-1:0] fifo_pop_data_arr [PORT_COUNT-1:0];
	reg [PORT_COUNT-1:0] tbusy; // tx transceiver busy
	reg [PORT_COUNT-1:0] fifo_pop_ack_old;
	wire [PORT_BITS-1:0] port = table_data;
	wire [PORT_COUNT-1:0] ack_received = fifo_pop_ack ^ fifo_pop_ack_old;

	// destination address is in the lower part of the flit
	assign table_addr = fifo_item_out[DESTINATION_BITS-1:0];

	// pack fifo_pop_data_arr into fifo_pop_data

	genvar k;
	generate
		for (k=0; k<PORT_COUNT; k=k+1) begin
			localparam LSB = SIZE * k;
			localparam MSB = SIZE * (k+1) - 1;
			assign fifo_pop_data[MSB:LSB] = fifo_pop_data_arr[k];
		end
	endgenerate

	// body

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			fifo_read <= 0;
			fifo_pop_req <= 0;
			fifo_pop_ack_old <= 0;
			tbusy <= 0;

		end else begin : BLOCK1

			integer i;

			fifo_pop_ack_old <= fifo_pop_ack;

			tbusy <= tbusy & ~ack_received;

			for (i=0; i<PORT_COUNT; i=i+1) if (ack_received[i])
				$display("#%3d, %10s [%1d] : received ack from port <%g>", $time, "TX_LOGIC", ID, i);

			if (~fifo_empty && ~tbusy[port]) begin

				$display("#%3d, %10s [%1d] : found item <%g> in fifo, destination is <%g>, sending through port <%g>", $time, "TX_LOGIC", ID, fifo_item_out, table_addr, port);
				fifo_pop_data_arr[port] <= fifo_item_out; // set data bits
				fifo_pop_req[port] <= ~fifo_pop_req[port]; // initiate request
				tbusy[port] <= 1; // mark this transceiver as busy
				fifo_read <= 1;

			end else begin

				fifo_read <= 0;

			end

		end

	end

endmodule

`endif
