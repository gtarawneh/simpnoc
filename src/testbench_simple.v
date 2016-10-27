`timescale 1ns/1ps

`ifndef _inc_constants_
	`define _inc_constants_
	`include "constants_2D.v"
`endif

`include "generator.v"
`include "router2.v"
`include "source2.v"
`include "sink2.v"

module testbench_simple();

	initial begin
		// $dumpfile("output/dump.vcd");
		// $dumpvars(0, testbench_simple);
		#10
		$finish;
	end

	wire clk, reset;

	generator u1 (clk, reset);

	wire [`SIZE-1:0] table_addr [1:0];

	wire [`BITS_DIR-1:0] table_data [1:0];

	// router tx transceiver signals:

	wire [4:0] tx_req [1:0];

	wire [4:0] tx_ack [1:0];

	wire [5*`SIZE-1:0] tx_data [1:0];

	// router rx transceiver signals:

	wire [4:0] rx_req [1:0];

	wire [4:0] rx_ack [1:0];

	wire [5*`SIZE-1:0] rx_data [1:0];

	generate
		genvar i;
		for (i=0; i<1; i=i+1) begin
			router2 #(i) ri (
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

	wire [`SIZE-1:0] src_data;

	source2 #(.max_flits(2)) src1 (clk, reset, src_req, src_ack, src_data);

	assign rx_req[0][0] = src_req;
	assign rx_ack[0][0] = src_ack;
	assign rx_data[0][`SIZE-1:0] = src_data;
	assign rx_data[0][5*`SIZE-1:`SIZE] = 0;

	// always @(posedge clk) begin
	// 	$display("rx_data = %d", rx_data[0]);
	// end

	assign rx_req[1][0] = 0;

	// sink

	// sink2 snk1 (clk, reset, src_req, src_ack, src_data);

endmodule
