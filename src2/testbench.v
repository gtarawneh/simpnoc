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

	localparam DURATION = 500; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

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
		table_data
	);



endmodule
