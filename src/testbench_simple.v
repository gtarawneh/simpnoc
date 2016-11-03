`timescale 1ns/1ps

`include "generator.v"
`include "router2.v"
`include "source2.v"
`include "sink2.v"

module testbench_simple();

	initial begin
		// $dumpfile("output/dump.vcd");
		// $dumpvars(0, testbench_simple);
		#20
		$finish;
	end

	localparam SIZE = 8;
	localparam PORT_COUNT = 5; // number of ports
	localparam DESTINATION_BITS = 3; // number of bits to specify port

	wire clk, reset;

	generator u1 (clk, reset);

	wire [SIZE-1:0] table_addr [1:0];

	wire [DESTINATION_BITS-1:0] table_data [1:0];

	// router tx transceiver signals:

	wire [PORT_COUNT-1:0] tx_req [1:0];

	wire [PORT_COUNT-1:0] tx_ack [1:0];

	wire [PORT_COUNT*SIZE-1:0] tx_data [1:0];

	// router rx transceiver signals:

	wire [PORT_COUNT-1:0] rx_req [1:0];

	wire [PORT_COUNT-1:0] rx_ack [1:0];

	wire [PORT_COUNT*SIZE-1:0] rx_data [1:0];

	generate
		genvar i;
		for (i=0; i<1; i=i+1) begin
			router2 #(
				.ID(i),
				.SIZE(SIZE),
				.PORT_COUNT(5),
				.DESTINATION_BITS(3)
			) ri (
				clk,
				reset,
				tx_req[i],
				tx_ack[i],
				tx_data[i],
				rx_req[i],
				rx_ack[i],
				rx_data[i],
				table_addr[i],
				table_data[i]
			);
			assign table_data[i] = 0; // dummy routing table
		end
	endgenerate

	// source

	wire src_req, src_ac;

	wire [SIZE-1:0] src_data;

	source2 #(
		.ID(0),
		.DESTINATION(100),
		.MAX_FLITS(1),
		.SIZE(SIZE),
		.PAYLOAD(4)
	) src1 (
		.clk(clk),
		.reset(reset),
		.req(src_req),
		.ack(src_ack),
		.data(src_data)
	);

	assign rx_req[0][0] = src_req;
	assign src_ack = rx_ack[0][0];
	assign rx_data[0][SIZE-1:0] = src_data;

	assign rx_req[0][1] = 0;
	assign rx_req[0][2] = 0;
	assign rx_req[0][3] = 0;
	assign rx_req[0][4] = 0;
	assign rx_data[0][PORT_COUNT*SIZE-1:SIZE] = 0;

	assign rx_req[1][0] = 0;

	// sink

	wire [SIZE-1:0] snk_data;

	assign snk_data = tx_data[0][SIZE-1:0];
	assign snk_req = tx_req[0][0];
	assign tx_ack[0][0] = snk_ack;

	sink2 snk1 (clk, reset, snk_req, snk_ack, snk_data);

endmodule
