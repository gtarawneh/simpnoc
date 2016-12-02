`timescale 1ns/1ps

`include "router.v"
`include "generator.v"

module testbench_simple();

	// parameters

	localparam SEED = 5;
	localparam PORTS = 5;
	localparam PORT_BITS = 8;
	localparam SIZE = 8; // flit bits
	localparam SRC_PACKETS = 1; // packets per source
	localparam DEST_BITS = SIZE - 1; // bits to designate requested destination
	localparam DESTS = 2 ** DEST_BITS;

	// simulation control

	localparam PAD_DELAY = 0; // cycles to simulate after all packets sent

	always @(rx_done) if (&rx_done) #PAD_DELAY $finish;

	wire clk, reset;

	generator u1 (clk, reset);

	// internal nets

	wire [PORTS-1:0] rx_req;
	wire [PORTS-1:0] rx_ack;
	wire [SIZE*PORTS-1:0] rx_data;
	wire [PORTS-1:0] rx_done;

	wire [PORTS-1:0] tx_req;
	wire [PORTS-1:0] tx_ack;
	wire [SIZE*PORTS-1:0] tx_data;

	// routing table:

	wire [DEST_BITS-1:0] table_addr;
	reg [PORT_BITS-1:0] table_data;

	always @(*) case (table_addr)
		0          : table_data = 0;
		1          : table_data = 2;
		2          : table_data = 1;
		3          : table_data = 2;
		default    : table_data = 4;
	endcase

	// variables

	genvar i;

	// router

	router #(
		.PORTS(PORTS),
		.PORT_BITS(PORT_BITS),
		.SIZE(SIZE)
	) r1 (
		reset,
		clk,
		rx_req,
		rx_ack,
		rx_data,
		tx_req,
		tx_ack,
		tx_data,
		table_addr,
		table_data,
		ready
	);

	// sources

	generate

		for (i=0; i<PORTS; i=i+1) begin

			wire [SIZE-1:0] rx_flit;

			localparam MSB = SIZE * (i+1) - 1;
			localparam LSB = SIZE * i;

			assign rx_data[MSB:LSB] = rx_flit;

			packet_source #(
				.ID(i),
				.FLITS(8),
				.SIZE(SIZE),
				.SEED(i + SEED),
				.PACKETS(SRC_PACKETS)
			) s1 (
				clk,
				reset | ~ready,
				rx_req[i],
				rx_ack[i],
				rx_flit,
				rx_done[i]
			);

		end

	endgenerate

	// sinks

	generate

		for (i=0; i<PORTS; i=i+1) begin

			wire [SIZE-1:0] tx_flit;

			localparam MSB = SIZE * (i+1) - 1;
			localparam LSB = SIZE * i;

			packet_sink #(
				.ID(i)
			) u4 (
				clk,
				reset,
				tx_req[i],
				tx_data[MSB:LSB],
				tx_ack[i]
			);

		end

	endgenerate

endmodule
