`timescale 1ns/1ps

`include "generator.v"
`include "router2.v"
`include "source2.v"
`include "sink2.v"
`include "connector.v"

module testbench_multirouterp();

	localparam SIZE = 8; // data bits
	localparam PORT_COUNT = 2; // number of ports
	localparam DESTINATION_BITS = 3; // number of bits to specify port
	localparam DURATION = 50; // duration of simulation (time units)
	localparam DEPTH_LOG2 = 4;

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;
	wire [SIZE-1:0] table_addr [2:0];
	wire [DESTINATION_BITS-1:0] table_data [2:0];
	wire [PORT_COUNT-1:0] tx_req [2:0];
	wire [PORT_COUNT-1:0] tx_ack [2:0];
	wire [PORT_COUNT*SIZE-1:0] tx_data [2:0];
	wire [PORT_COUNT-1:0] rx_req [2:0];
	wire [PORT_COUNT-1:0] rx_ack [2:0];
	wire [PORT_COUNT*SIZE-1:0] rx_data [2:0];
	wire [SIZE-1:0] snk_data;

	generator u1 (clk, reset);

	generate
		genvar i;
		for (i=0; i<3; i=i+1) begin
			router2 #(
				.ID(i),
				.SIZE(SIZE),
				.PORT_COUNT(PORT_COUNT),
				.DESTINATION_BITS(DESTINATION_BITS),
				.DEPTH_LOG2(DEPTH_LOG2)
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

	// sources

	generate
		genvar j;
		for (j=0; j<1; j=j+1) begin
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
			connector #(
				.SIZE(SIZE),
				.TX_PORT_COUNT(1),
				.RX_PORT_COUNT(PORT_COUNT),
				.TX_PORT(0),
				.RX_PORT(j)
			) con1 (
				.tx_req(src_req),
				.tx_ack(src_ack),
				.tx_data(src_data),
				.rx_req(rx_req[0]),
				.rx_ack(rx_ack[0]),
				.rx_data(rx_data[0])
			);
		end
	endgenerate

	// inter-router connectors

	connector #(
		.SIZE(SIZE),
		.TX_PORT_COUNT(PORT_COUNT),
		.RX_PORT_COUNT(PORT_COUNT),
		.TX_PORT(0),
		.RX_PORT(1)
	) con1 (
		.tx_req(tx_req[0]),
		.tx_ack(tx_ack[0]),
		.tx_data(tx_data[0]),
		.rx_req(rx_req[1]),
		.rx_ack(rx_ack[1]),
		.rx_data(rx_data[1])
	);

	connector #(
		.SIZE(SIZE),
		.TX_PORT_COUNT(PORT_COUNT),
		.RX_PORT_COUNT(PORT_COUNT),
		.TX_PORT(0),
		.RX_PORT(1)
	) con2 (
		.tx_req(tx_req[1]),
		.tx_ack(tx_ack[1]),
		.tx_data(tx_data[1]),
		.rx_req(rx_req[2]),
		.rx_ack(rx_ack[2]),
		.rx_data(rx_data[2])
	);

	// sink

	assign snk_data = tx_data[2][SIZE-1:0];
	assign snk_req = tx_req[2][0];
	assign tx_ack[2][0] = snk_ack;

	sink2 #(.ID(2)) snk1 (clk, reset, snk_req, snk_ack, snk_data);

endmodule
