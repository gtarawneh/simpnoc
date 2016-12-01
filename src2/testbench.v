`timescale 1ns/1ps

`include "router.v"
`include "generator.v"

module testbench();

	// parameters

	parameter SEED = 5;
	parameter PORTS = 5;
	parameter PORT_BITS = 8;
	parameter SIZE = 8;

	localparam DEST_BITS = SIZE - 1; // bits to designate requested destination
	localparam DESTS = 2 ** DEST_BITS;

	// simulation control

	localparam DURATION = 5000; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

	// internal nets

	wire [PORTS-1:0] rx_ch_req;
	wire [PORTS-1:0] rx_ch_ack;
	wire [SIZE*PORTS-1:0] rx_ch_data;

	wire [PORTS-1:0] tx_ch_req;
	wire [PORTS-1:0] tx_ch_ack;
	wire [SIZE*PORTS-1:0] tx_ch_data;

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
		.SEED(SEED),
		.PORTS(PORTS),
		.PORT_BITS(PORT_BITS),
		.SIZE(SIZE)
	) r1 (
		reset,
		clk,
		table_addr,
		table_data,
		rx_ch_req,
		rx_ch_ack,
		rx_ch_data,
		tx_ch_req,
		tx_ch_ack,
		tx_ch_data,
		ready
	);

	// sources

	generate

		for (i=0; i<PORTS; i=i+1) begin

			wire [SIZE-1:0] rx_ch_flit;

			localparam MSB = SIZE * (i+1) - 1;
			localparam LSB = SIZE * i;

			assign rx_ch_data[MSB:LSB] = rx_ch_flit;

			packet_source #(
				.ID(i),
				.FLITS(8),
				.SIZE(SIZE),
				.SEED(i + SEED)
			) s1 (
				clk,
				reset | ~ready,
				rx_ch_req[i],
				rx_ch_ack[i],
				rx_ch_flit
			);

		end

	endgenerate

	// sinks

	generate

		for (i=0; i<PORTS; i=i+1) begin

			wire [SIZE-1:0] tx_ch_flit;

			localparam MSB = SIZE * (i+1) - 1;
			localparam LSB = SIZE * i;

			packet_sink #(
				.ID(i),
				.PORT_BITS(PORT_BITS)
			) u4 (
				clk,
				reset,
				tx_ch_req[i],
				tx_ch_data[MSB:LSB],
				tx_ch_ack[i]
			);

		end

	endgenerate

endmodule
