`ifndef _inc_router_
`define _inc_router_

`include "rx_logic.v"
`include "fifo.v"
`include "tx_logic.v"
`include "transceiver_dummy.v"

module router (
		clk,
		reset,
		tx_req,
		tx_ack,
		tx_data,
		rx_req,
		rx_ack,
		rx_data,
		table_addr,
		table_data
	);

	// parameters

	parameter ID = -1; // router id
	parameter SIZE = 8; // data bits
	parameter PORT_COUNT = 5; // number of ports
	parameter PORT_NAMES = {"North", "South", "East", "West", "Local"};
	parameter DESTINATION_BITS = 3; // number of bits to specify port
	parameter DEPTH_LOG2 = 4;

	// module port declarations

	input clk, reset;
	input [DESTINATION_BITS-1:0] table_data;
	input [PORT_COUNT-1:0] tx_ack;
	input [PORT_COUNT-1:0] rx_req;
	input [PORT_COUNT*SIZE-1:0] rx_data;
	output [SIZE-1:0] table_addr;
	output [PORT_COUNT-1:0] tx_req;
	output [PORT_COUNT*SIZE-1:0] tx_data;
	output [PORT_COUNT-1:0] rx_ack;

	// internet nets

	wire [SIZE-1:0] fifo_item_in;
	wire [SIZE-1:0] fifo_item_out;
	wire [PORT_COUNT-1:0] fifo_pop_req;
	wire [PORT_COUNT-1:0] fifo_pop_ack;
	wire [PORT_COUNT*SIZE-1:0] fifo_pop_data;
	wire fifo_read;
	wire fifo_empty;
	wire [PORT_COUNT-1:0] fifo_push_req;
	wire [PORT_COUNT-1:0] fifo_push_ack;
	wire [PORT_COUNT*SIZE-1:0] fifo_push_data;

	// rx transceivers

	generate
		genvar i;
		for (i=0; i<PORT_COUNT; i=i+1) begin : RX_BLOCK
			wire [SIZE-1:0] org_rx_data_item;
			wire [SIZE-1:0] fifo_push_data_item;
			localparam MSB = SIZE * (i+1) - 1;
			localparam LSB = SIZE * i;
			assign org_rx_data_item = rx_data[MSB:LSB];
			assign fifo_push_data[MSB:LSB] = fifo_push_data_item;
			transceiver_dummy #(
				.ID(ID),
				.SIZE(SIZE),
				.PORT(PORT_NAMES[i])
			) rx (
				.clk(clk),
				.reset(reset),
				.req1(rx_req[i]),
				.ack1(rx_ack[i]),
				.data1(org_rx_data_item),
				.req2(fifo_push_req[i]),
				.ack2(fifo_push_ack[i]),
				.data2(fifo_push_data_item)
			);
		end
	endgenerate

	// rx logic

	rx_logic #(
		.ID(ID),
		.SIZE(SIZE),
		.PORT_COUNT(PORT_COUNT)
	) rl (
		.clk(clk),
		.reset(reset),
		.fifo_push_req(fifo_push_req),
		.fifo_push_ack(fifo_push_ack),
		.fifo_push_data(fifo_push_data),
		.fifo_write(fifo_write),
		.fifo_full(fifo_full),
		.fifo_item_in(fifo_item_in)
	);

	// fifo

	fifo #(
		.ID(ID),
		.SIZE(SIZE),
		.DEPTH_LOG2(DEPTH_LOG2)
	) myfifo1 (
		.clk(clk),
		.reset(reset),
		.full(fifo_full),
		.empty(fifo_empty),
		.item_in(fifo_item_in),
		.item_out(fifo_item_out),
		.write (fifo_write),
		.read(fifo_read)
	);

	// tx logic

	tx_logic #(
		.ID(ID),
		.SIZE(SIZE),
		.PORT_COUNT(PORT_COUNT)
	) tl (
		.clk(clk),
		.reset(reset),
		.fifo_read(fifo_read),
		.fifo_empty(fifo_empty),
		.fifo_item_out(fifo_item_out),
		.fifo_pop_req(fifo_pop_req),
		.fifo_pop_ack(fifo_pop_ack),
		.fifo_pop_data(fifo_pop_data),
		.table_addr(table_addr),
		.table_data(table_data)
	);

	// tx transceivers

	generate
		genvar j;
		for (j=0; j<PORT_COUNT; j=j+1) begin : TX_BLOCK
			wire [SIZE-1:0] fifo_pop_data_item;
			wire [SIZE-1:0] tx_data_item;
			localparam MSB = SIZE * (j+1) - 1;
			localparam LSB = SIZE * j;
			assign fifo_pop_data_item = fifo_pop_data[MSB:LSB];
			assign tx_data[MSB:LSB] = tx_data_item;
			transceiver_dummy #(
				.ID(ID),
				.SIZE(SIZE),
				.PORT(PORT_NAMES[j])
			) tx (
				.clk(clk),
				.reset(reset),
				.req1(fifo_pop_req[j]),
				.ack1(fifo_pop_ack[j]),
				.data1(fifo_pop_data_item),
				.req2(tx_req[j]),
				.ack2(tx_ack[j]),
				.data2(tx_data_item)
			);
		end
	endgenerate

endmodule

`endif
