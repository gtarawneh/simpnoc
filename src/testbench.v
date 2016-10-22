`timescale 1ns/1ns

`include "constants_2D.v"
`include "basics.v"
`include "source.v"
`include "source_from_memory.v"
`include "router.v"
`include "sink.v"
`include "moody_sink.v"
`include "routing_table.v"

module testbench();

	initial begin
		$display("start of stimulation");
		$dumpfile("output/dump.vcd");
		$dumpvars(0, testbench);
		#50
		$display("end of stimulation");
		$finish;
	end

	wire clk, reset;

	generator g1 (clk, reset);

	// routers:

	wire [4:0] rx_busy [`NUM_NODES-1:0];
	wire [4:0] rx_data [`NUM_NODES-1:0];
	wire [4:0] tx_busy [`NUM_NODES-1:0];
	wire [4:0] tx_data [`NUM_NODES-1:0];
	wire [2:0] activity_level [`NUM_NODES-1:0];

	wire [`SIZE-1:0] table_addr [`NUM_NODES-1:0];
	wire [`BITS_DIR-1:0] table_data [`NUM_NODES-1:0];

	generate
		genvar i;
		for (i=0; i<`NUM_NODES; i=i+1) begin
			router #(i) ri (clk, reset, rx_busy[i], rx_data[i], tx_busy[i], tx_data[i], table_addr[i], table_data[i], activity_level[i]);
			routing_table #(i) rtabi (reset, table_addr[i], table_data[i]);
		end
	endgenerate

	// sources:

	wire source_data [`NUM_NODES-1:0];
	wire source_busy [`NUM_NODES-1:0];

	serial_source #(.destination(4), .id(0), .max_flits(1)) source1 (clk, reset, source_data[1], source_busy[1]);

	// sinks:

	wire sink_data [`NUM_NODES-1:0];
	wire sink_busy [`NUM_NODES-1:0];

	wire [25:0] througput [`NUM_NODES-1:0];

	generate
		genvar j;
		for (j=0; j<`NUM_NODES; j=j+1) begin
			serial_sink #(j) sj (clk, reset, sink_busy[j], sink_data[j], througput[j]);
		end
	endgenerate

	// connections:

	`include "connections.v"

endmodule
