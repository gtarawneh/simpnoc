`timescale 1ns/1ps

`include "generator.v"
`include "router2.v"
`include "source2.v"
`include "sink2.v"
`include "connector.v"

module noc();

	localparam SIZE = 8; // data bits
	localparam PORT_COUNT = 2; // number of ports
	localparam DESTINATION_BITS = 3; // number of bits to specify port
	localparam DURATION = 50; // duration of simulation (time units)
	localparam DEPTH_LOG2 = 4;
	localparam ROUTER_COUNT = 16;
	localparam SINK_COUNT = 16;
	localparam SOURCE_COUNT = 16;

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;
	wire [SIZE-1:0] table_addr [ROUTER_COUNT-1:0];
	wire [DESTINATION_BITS-1:0] table_data [ROUTER_COUNT-1:0];
	wire [PORT_COUNT-1:0] tx_req [ROUTER_COUNT-1:0];
	wire [PORT_COUNT-1:0] tx_ack [ROUTER_COUNT-1:0];
	wire [PORT_COUNT*SIZE-1:0] tx_data [ROUTER_COUNT-1:0];
	wire [PORT_COUNT-1:0] rx_req [ROUTER_COUNT-1:0];
	wire [PORT_COUNT-1:0] rx_ack [ROUTER_COUNT-1:0];
	wire [PORT_COUNT*SIZE-1:0] rx_data [ROUTER_COUNT-1:0];
	wire snk_req [SINK_COUNT-1:0];
	wire snk_ack [SINK_COUNT-1:0];
	wire [SIZE-1:0] snk_data [SINK_COUNT-1:0];
	wire src_req [SOURCE_COUNT-1:0];
	wire src_ack [SOURCE_COUNT-1:0];
	wire [SIZE-1:0] src_data [SOURCE_COUNT-1:0];

	generator u1 (clk, reset);

	genvar i;

	`include "gen/gen_routers.v"
	`include "gen/gen_sources.v"
	`include "gen/gen_sinks.v"
	`include "gen/gen_rr_connections.v"
	`include "gen/gen_rs_connections.v"
	`include "gen/gen_sr_connections.v"

endmodule
