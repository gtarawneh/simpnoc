`ifndef _inc_rx_logic_
`define _inc_rx_logic_

// This modules receives incoming data items from several senders (using two-
// phase handshakes) and picks one at a time to push into a fifo. It has two
// interfaces:
//
// `rx` : interface with rx transceivers consisting of PORT_COUNT x (req + ack
// `+ data signals)
//
// `fifo` : interface with fifo consisting of write, full and item_in signals

module rx_logic (
		clk,
		reset,
		fifo_push_req,
		fifo_push_ack,
		fifo_push_data,
		fifo_write,
		fifo_full,
		fifo_item_in,
	);

	// parameters

	parameter ID = -1;
	parameter SIZE = 8;
	parameter PORT_COUNT = 5;
	parameter DESTINATION_BITS = 4; // number of bits to specify destination
	parameter PORT_BITS = 4; // number of bits to specify port

	// module port declarations

	input clk, reset;
	input [PORT_COUNT-1:0] fifo_push_req;
	input [SIZE*PORT_COUNT-1:0] fifo_push_data;
	input fifo_full;
	output reg [PORT_COUNT-1:0] fifo_push_ack;
	output reg fifo_write;
	output reg [SIZE-1:0] fifo_item_in;

	// internal nets

	wire [SIZE-1:0] fifo_push_data_arr [PORT_COUNT-1:0];
	reg [PORT_COUNT-1:0] fifo_push_req_old;

	// unpack arrays

	genvar k;
	generate
		for (k=0; k<PORT_COUNT; k=k+1) begin
			localparam LSB = SIZE * k;
			localparam MSB = SIZE * (k+1) - 1;
			assign fifo_push_data_arr[k] = fifo_push_data[MSB:LSB];
		end
	endgenerate

	// body

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			fifo_push_ack <= 0;
			fifo_push_req_old <= 0;
			fifo_write <= 0;
			fifo_item_in <= 0;

		end else begin : BLOCK1

			integer i, port;

			localparam NO_PORT = -1;

			if (fifo_full) begin

				fifo_write <= 0;

			end else begin

				fifo_write = 0;
				fifo_item_in = 0;
				port = NO_PORT;

				for (i=0; i<PORT_COUNT; i=i+1)
					if (fifo_push_req[i] ^ fifo_push_req_old[i])
						port = i;

				if (port != NO_PORT) begin
					fifo_write = 1;
					fifo_push_ack[port] = ~fifo_push_ack[port];
					fifo_item_in = fifo_push_data_arr[port];
					fifo_push_req_old[port] <= fifo_push_req[port];
					$display(
						{
							"#%3d, %10s [%1d] : ",
							"received <%g:%g> from port <%g>, ",
							"acknowledging, ",
							"pushing to fifo"
						},
						$time, "RX_LOGIC", ID,
						fifo_item_in[SIZE - 1:DESTINATION_BITS],
						fifo_item_in[DESTINATION_BITS-1:0],
						port
					);
				end


			end

		end

	end

endmodule

`endif
