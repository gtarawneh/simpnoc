`ifndef _inc_constants_
	`define _inc_constants_
	`include "constants_2D.v"
`endif

`ifndef _inc_rx_logic_
	`define _inc_rx_logic_
	`include "rx_logic.v"
`endif

`ifndef _inc_fifo_
	`define _inc_fifo_
	`include "fifo.v"
`endif

`ifndef _inc_tx_logic_
	`define _inc_tx_logic_
	`include "tx_logic.v"
`endif

module router2 (clk, reset, tx_req, tx_ack, tx_data, rx_req, rx_ack, rx_data, table_addr, table_data)

	parameter id = -1; // router id

	// Ports:
	// -----------------------------------------------------------------

	input clk, reset;

	output [`SIZE-1:0] table_addr;

	input [`BITS_DIR-1:0] table_data;

	// the follow are all bitfield ports with the following format
	// bit 0 : north
	// bit 1 : south
	// bit 2 : east
	// bit 3 : west
	// bit 4 : local

	// tx transceiver signals:

	output [4:0] tx_req;
	input [4:0] tx_ack;
	output [4:0] tx_data [`SIZE-1:0];

	// rx transceiver signals:

	input [4:0] rx_req;
	output [4:0] rx_ack;
	input [4:0] rx_data [`SIZE-1:0];

	// Interface and internal nets:
	// -----------------------------------------------------------------

	wire [`SIZE-1:0] fifo_item_in;

	wire [`SIZE-1:0] fifo_item_out;

	// RX :
	// -----------------------------------------------------------------

	generate
		genvar i;
		for (i=0; i<5; i=i+1) begin : RX_BLOCK
			transceiver #(.id(id)) rx
			(
				.clk(clk),
				.reset(reset),
				.req1(rx_req[0]),
				.ack1(rx_ack[0]),
				.data1(rx_data[0]),
				.req2(fifo_push_req[0]),
				.ack2(fifo_push_ack[0]),
				.data2(fifo_push_data[0])
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

	rx_logic_2 rl
	(
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

	fifo #(routerid) myfifo1
	(
		.clk(clk), .reset(reset),
		.full(full), .empty(empty),
		.item_in(fifo_item_in), .item_out(fifo_item_out),
		.write (write), .read(read)
	);

	always @(posedge clk) begin
		if (write) begin
			$display("[%g] router %g: pushed %d to fifo", $time, routerid, fifo_item_in);
		end
		if (read) begin
			$display("[%g] router %g: popped %d from fifo", $time, routerid, fifo_item_out);
		end
	end

	// TX :
	// -----------------------------------------------------------------

	tx_logic_2 tl
	(
		.clk(clk),
		.reset(reset),
		.fifo_pop_req(fifo_pop_req),
		.fifo_pop_ack(fifo_pop_ack),
		.fifo_pop_data(fifo_pop_data),
		.fifo_read(fifo_read),
		.fifo_empty(fifo_empty),
		.fifo_data_out(fifo_data_out)
	);

	generate
		genvar j;
		for (j=0; j<5; j=j+1) begin : TX_BLOCK
			transceiver #(.id(id)) tx
			(
				.clk(clk),
				.reset(reset),
				.req1(fifo_pop_req[j]),
				.ack1(fifo_pop_ack[j]),
				.data1(fifo_pop_data[j]),
				.req2(rx_req[j]),
				.ack2(rx_ack[j]),
				.data2(rx_data[j])
			);
		end
	endgenerate

	defparam TX_BLOCK[0].tx.port = "North";
	defparam TX_BLOCK[1].tx.port = "South";
	defparam TX_BLOCK[2].tx.port = "East";
	defparam TX_BLOCK[3].tx.port = "West";
	defparam TX_BLOCK[4].tx.port = "Local";

endmodule
