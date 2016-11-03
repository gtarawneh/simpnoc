`timescale 1ns/1ps

`include "generator.v"
`include "router2.v"
`include "source2.v"
`include "sink2.v"

module testbench_multiport();

	localparam SIZE = 8; // data bits
	localparam PORT_COUNT = 3; // number of ports
	localparam DESTINATION_BITS = 3; // number of bits to specify port
	localparam DURATION = 50; // duration of simulation (time units)
	localparam DEPTH_LOG2 = 4;

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;
	wire [SIZE-1:0] table_addr;
	wire [DESTINATION_BITS-1:0] table_data;
	wire [PORT_COUNT-1:0] tx_req;
	wire [PORT_COUNT-1:0] tx_ack;
	wire [PORT_COUNT*SIZE-1:0] tx_data;
	wire [PORT_COUNT-1:0] rx_req;
	wire [PORT_COUNT-1:0] rx_ack;
	wire [PORT_COUNT*SIZE-1:0] rx_data;
	wire [SIZE-1:0] snk_data;

	generator u1 (clk, reset);

	router2 #(
		.ID(0),
		.SIZE(SIZE),
		.PORT_COUNT(PORT_COUNT),
		.DESTINATION_BITS(DESTINATION_BITS),
		.DEPTH_LOG2(DEPTH_LOG2)
	) ri (
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

	assign table_data = 0; // dummy routing table

	// sources

	generate
		genvar j;
		for (j=0; j<PORT_COUNT; j=j+1) begin
			wire src_req, src_ac;
			wire [SIZE-1:0] src_data;
			source2 #(
				.ID(j),
				.DESTINATION(100 + j),
				.MAX_FLITS(1),
				.SIZE(SIZE),
				.PAYLOAD(10+j)
			) src1 (
				.clk(clk),
				.reset(reset),
				.req(src_req),
				.ack(src_ack),
				.data(src_data)
			);
			assign rx_req[j] = src_req;
			assign src_ack = rx_ack[j];
			localparam LSB = j * SIZE;
			localparam MSB = (j+1) * SIZE - 1;
			assign rx_data[MSB:LSB] = src_data;
		end
	endgenerate

	// sink

	assign snk_data = tx_data[SIZE-1:0];
	assign snk_req = tx_req[0];
	assign tx_ack[0] = snk_ack;

	sink2 snk1 (clk, reset, snk_req, snk_ack, snk_data);

endmodule
