`timescale 1ns/1ps

`include "rx.v"
`include "generator.v"

module testbench_rx();

	localparam DURATION = 250; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);
		integer i;

	initial begin
		ch_req <= 0;
		ch_flit <= 0;
		sw_gnt <= 0;
		#10
		ch_flit <= 8'b10000000;
		ch_req <= ~ch_req;
		for (i=0; i<8; i=i+1) begin
			#10
			ch_flit <= 8'b00000000;
			ch_req <= ~ch_req;
		end
		#10
		sw_gnt <= 1;
		#10
		sw_gnt <= 0;
	end

	// channel interface:
	reg ch_req;
	reg [7:0] ch_flit;

	// switch interface
	reg sw_gnt;
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
