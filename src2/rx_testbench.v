`timescale 1ns/1ps

`include "rx.v"
`include "generator.v"

module testbench_rx();

	localparam DURATION = 50; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

	// channel interface:
	reg ch_req = 0;
	reg [7:0] ch_flit = 0;

	// switch interface
	reg sw_gnt = 0;
	wire [2:0] sw_chnl;

	// buffer interface
	reg [2:0] buf_addr = 0;
	wire [7:0] buf_data;

	rx u2 (
		clk,
		reset,
		ch_req,
		ch_flit,
		ch_ack,
		sw_req,
		sw_chnl,
		sw_gnt,
		buf_addr,
		buf_data
	);

endmodule
