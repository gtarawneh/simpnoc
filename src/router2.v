`ifndef _inc_rx_logic2_
	`define _inc_rx_logic2_
	`include "rx_logic2.v"
`endif

`ifndef _inc_fifo_
	`define _inc_fifo_
	`include "fifo.v"
`endif

`ifndef _inc_tx_logic2_
	`define _inc_tx_logic2_
	`include "tx_logic2.v"
`endif

`ifndef _inc_transceiver_dummy
	`define _inc_transceiver_dummy
	`include "transceiver_dummy.v"
`endif

module router2 (
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

	parameter ID = -1; // router id
	parameter SIZE = 8; // data bits
	parameter PORT_COUNT = 5; // number of ports
	parameter PORT_NAMES = {"North", "South", "East", "West", "Local"};

	input clk, reset;

	output [SIZE-1:0] table_addr;

	input [`BITS_DIR-1:0] table_data;

	// tx transceiver signals:

	output [PORT_COUNT-1:0] tx_req;

	input [PORT_COUNT-1:0] tx_ack;

	output [PORT_COUNT*SIZE-1:0] tx_data;

	// rx transceiver signals:

	input [PORT_COUNT-1:0] rx_req;

	output [PORT_COUNT-1:0] rx_ack;

	input [PORT_COUNT*SIZE-1:0] rx_data;

	// Interface and internal nets:
	// -----------------------------------------------------------------

	wire [SIZE-1:0] fifo_item_in;

	wire [SIZE-1:0] fifo_item_out;

	// tx nets:

	wire [PORT_COUNT-1:0] fifo_pop_req;
	wire [PORT_COUNT-1:0] fifo_pop_ack;
	wire [PORT_COUNT*SIZE-1:0] fifo_pop_data;
	wire fifo_read;
	wire fifo_empty;

	// RX :
	// -----------------------------------------------------------------

	wire [PORT_COUNT-1:0] fifo_push_req;

	wire [PORT_COUNT-1:0] fifo_push_ack;

	wire [PORT_COUNT*SIZE-1:0] fifo_push_data;

	generate
		genvar i;
		for (i=0; i<5; i=i+1) begin : RX_BLOCK
			wire [SIZE-1:0] rx_data_item;
			wire [SIZE-1:0] fifo_push_data_item;
			localparam MSB = SIZE * (i+1) - 1;
			localparam LSB = SIZE * i;
			assign rx_data_item = rx_data[MSB:LSB];
			assign fifo_push_data[MSB:LSB] = fifo_push_data_item;
			transceiver_dummy #(
				.ID(ID),
				.SIZE(SIZE)
			) rx (
				.clk(clk),
				.reset(reset),
				.req1(rx_req[i]),
				.ack1(rx_ack[i]),
				.data1(rx_data_item),
				.req2(fifo_push_req[i]),
				.ack2(fifo_push_ack[i]),
				.data2(fifo_push_data_item)
			);
		end
	endgenerate

	defparam RX_BLOCK[0].rx.PORT = "North";
	defparam RX_BLOCK[1].rx.PORT = "South";
	defparam RX_BLOCK[2].rx.PORT = "East";
	defparam RX_BLOCK[3].rx.PORT = "West";
	defparam RX_BLOCK[4].rx.PORT = "Local";

	// see this for referring to modules in generate blocks:
	// https://stackoverflow.com/questions/36711849/defparam-inside-generate-block-in-veilog

	rx_logic_2 #(
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

	// -----------------------------------------------------------------

	fifo #(
		.ID(ID),
		.SIZE(SIZE),
		.DEPTH_LOG2(4)
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

	// TX :
	// -----------------------------------------------------------------

	tx_logic_2 #(
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
