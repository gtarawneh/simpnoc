`ifndef _inc_constants_
	`define _inc_constants_
	`include "constants_2D.v"
`endif

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

`ifndef _inc_transceiver
	`define _inc_transceiver
	`include "transceiver.v"
`endif

// bit 0 : north
// bit 1 : south
// bit 2 : east
// bit 3 : west
// bit 4 : local

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

	parameter id = -1; // router id

	input clk, reset;

	output [`SIZE-1:0] table_addr;

	input [`BITS_DIR-1:0] table_data;

	// tx transceiver signals:

	output [4:0] tx_req;

	input [4:0] tx_ack;

	output [5*`SIZE-1:0] tx_data;

	// rx transceiver signals:

	input [4:0] rx_req;

	output [4:0] rx_ack;

	input [5*`SIZE-1:0] rx_data;

	// Interface and internal nets:
	// -----------------------------------------------------------------

	wire [`SIZE-1:0] fifo_item_in;

	wire [`SIZE-1:0] fifo_item_out;

	// RX :
	// -----------------------------------------------------------------

	wire [4:0] fifo_push_req;

	wire [4:0] fifo_push_ack;

	wire [5*`SIZE-1:0] fifo_push_data;

	generate
		genvar i;
		for (i=0; i<5; i=i+1) begin : RX_BLOCK
			wire [`SIZE-1:0] rx_data_item;
			wire [`SIZE-1:0] fifo_push_data_item;
			localparam BH = `SIZE * i + (`SIZE-1);
			localparam BL = `SIZE * i;
			assign rx_data_item = rx_data[BH:BL];
			assign fifo_push_data_item = fifo_push_data[BH:BL];
			transceiver #(.id(id)) rx (
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

	defparam RX_BLOCK[0].rx.port = "North";
	defparam RX_BLOCK[1].rx.port = "South";
	defparam RX_BLOCK[2].rx.port = "East";
	defparam RX_BLOCK[3].rx.port = "West";
	defparam RX_BLOCK[4].rx.port = "Local";

	// see this for referring to modules in generate blocks:
	// https://stackoverflow.com/questions/36711849/defparam-inside-generate-block-in-veilog

	wire [`SIZE-1:0] fifo_data_in;

	rx_logic_2 rl (
		.clk(clk),
		.reset(reset),
		.fifo_push_req(fifo_push_req),
		.fifo_push_ack(fifo_push_ack),
		.fifo_push_data(fifo_push_data),
		.fifo_write(fifo_write),
		.fifo_full(fifo_full),
		.fifo_data_in(fifo_data_in)
	);

	// -----------------------------------------------------------------

	fifo #(id) myfifo1 (
		.clk(clk),
		.reset(reset),
		.full(full),
		.empty(empty),
		.item_in(fifo_item_in),
		.item_out(fifo_item_out),
		.write (write),
		.read(read)
	);

	always @(posedge clk) begin
		if (write) begin
			$display("[%g] router %g: pushed %d to fifo", $time, id, fifo_item_in);
		end
		if (read) begin
			$display("[%g] router %g: popped %d from fifo", $time, id, fifo_item_out);
		end
	end

	// TX :
	// -----------------------------------------------------------------

	wire [4:0] fifo_pop_req;
	wire [4:0] fifo_pop_ack;
	wire [5*`SIZE-1:0] fifo_pop_data;
	wire fifo_read;
	wire fifo_empty;
	wire [`SIZE-1:0] fifo_data_out;

	tx_logic_2 tl (
	// .clk(clk),
	// .reset(reset),
	// .fifo_pop_req(fifo_pop_req),
	// .fifo_pop_ack(fifo_pop_ack),
	// .fifo_pop_data(fifo_pop_data),
	// .fifo_read(fifo_read),
	// .fifo_empty(fifo_empty),
	// .fifo_data_out(fifo_data_out),
	// .table_addr(table_addr),
	// .table_data(table_data)
		.clk(clk),
		.reset(reset),
		.fifo_read(fifo_read),
		.fifo_empty(fifo_empty),
		.fifo_data_out(fifo_data_out),
		.fifo_pop_req(fifo_pop_req),
		.fifo_pop_ack(fifo_pop_ack),
		.fifo_pop_data(fifo_pop_data)
	);

	generate
		genvar j;
		for (j=0; j<5; j=j+1) begin : TX_BLOCK
			wire [`SIZE-1:0] fifo_pop_data_item;
			wire [`SIZE-1:0] tx_data_item;
			localparam BH = `SIZE * j + (`SIZE-1);
			localparam BL = `SIZE * j;
			assign fifo_pop_data_item = fifo_pop_data[BH:BL];
			assign tx_data_item = tx_data[BH:BL];
			transceiver #(.id(id)) tx
			(
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

	defparam TX_BLOCK[0].tx.port = "North";
	defparam TX_BLOCK[1].tx.port = "South";
	defparam TX_BLOCK[2].tx.port = "East";
	defparam TX_BLOCK[3].tx.port = "West";
	defparam TX_BLOCK[4].tx.port = "Local";

endmodule
