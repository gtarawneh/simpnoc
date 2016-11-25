`timescale 1ns/1ps

`include "generator.v"
`include "rx.v"
`include "tx.v"

module testbench_rx();

	localparam DURATION = 180; // duration of simulation (time units)

	initial begin
		#DURATION $finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);
		integer i;

	initial begin
		ch_req <= 0;
		ch_flit <= 0;
		#10
		ch_flit <= 8'b10000000;
		ch_req <= ~ch_req;
		for (i=0; i<8; i=i+1) begin
			#10
			ch_flit <= 8'b00000000;
			ch_req <= ~ch_req;
		end
	end

	// channel interface:
	reg ch_req;
	reg [7:0] ch_flit;

	// switch interface
	wire [2:0] sw_chnl;

	// buffer interface
	wire [2:0] buf_addr;
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

	wire [7:0] ch2_flit;

	tx u3 (
		clk,
		reset,
		ch2_req,
		ch2_flit,
		ch2_ack,
		sw_req,
		sw_chnl,
		sw_gnt,
		buf_addr,
		buf_data
	);

	assign ch2_ack = ch2_req;

endmodule
