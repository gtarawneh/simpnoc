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
		// $display("%d : start of simulation", $time);
		$display("start of stimulation");
		$dumpfile("output/dump.vcd");
		$dumpvars(0, testbench);
		#1000
		$display("end of stimulation");
		$finish;
	end

	wire clk, reset;

	generator g1 (clk, reset);

	// routers and routing tables:
	// -----------------------------------------------------------------

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
	// -----------------------------------------------------------------

	wire source_data [`NUM_NODES-1:0];
	wire source_busy [`NUM_NODES-1:0];

	//serial_source_from_memory #(0, 16, "traffic/0) source0 (clk, reset, source_data[0], source_busy[0]);

	serial_source #(4, 1) source1 (clk, reset, source_data[1], source_busy[1], 8'd25);

	serial_source #(8, 2) source2 (clk, reset, source_data[2], source_busy[2], 8'd25);

	serial_source #(12, 3) source3 (clk, reset, source_data[3], source_busy[3], 8'd25 );
	/*
	serial_source_from_memory #(1, 16, "traffic/0) source1 (clk, reset, source_data[1], source_busy[1]);
	serial_source_from_memory #(2, 16, "traffic/0) source2 (clk, reset, source_data[2], source_busy[2]);
	serial_source_from_memory #(3, 16, "traffic/0) source3 (clk, reset, source_data[3], source_busy[3]);
	serial_source_from_memory #(4, 16, "traffic/0) source4 (clk, reset, source_data[4], source_busy[4]);
	serial_source_from_memory #(5, 16, "traffic/0) source5 (clk, reset, source_data[5], source_busy[5]);
	serial_source_from_memory #(6, 16, "traffic/0) source6 (clk, reset, source_data[6], source_busy[6]);
	serial_source_from_memory #(7, 16, "traffic/0) source7 (clk, reset, source_data[7], source_busy[7]);
	serial_source_from_memory #(8, 16, "traffic/0) source8 (clk, reset, source_data[8], source_busy[8]);
	serial_source_from_memory #(9, 16, "traffic/0) source9 (clk, reset, source_data[9], source_busy[9]);
	serial_source_from_memory #(10, 16, "traffic/0) source10 (clk, reset, source_data[10], source_busy[10]);
	serial_source_from_memory #(11, 16, "traffic/0) source11 (clk, reset, source_data[11], source_busy[11]);
	serial_source_from_memory #(12, 16, "traffic/0) source12 (clk, reset, source_data[12], source_busy[12]);
	serial_source_from_memory #(13, 16, "traffic/0) source13 (clk, reset, source_data[13], source_busy[13]);
	serial_source_from_memory #(14, 16, "traffic/0) source14 (clk, reset, source_data[14], source_busy[14]);
	serial_source_from_memory #(15, 16, "traffic/0) source15 (clk, reset, source_data[15], source_busy[15]);
*/
	// sinks:
	// -----------------------------------------------------------------

	wire sink_data [`NUM_NODES-1:0];
	wire sink_busy [`NUM_NODES-1:0];
/*
	serial_moody_sink #(0, 255) sink0 (clk, reset, sink_busy[0], sink_data[0]);
	serial_moody_sink #(1, 255) sink1 (clk, reset, sink_busy[1], sink_data[1]);
	serial_moody_sink #(2, 255) sink2 (clk, reset, sink_busy[2], sink_data[2]);
	serial_moody_sink #(3, 255) sink3 (clk, reset, sink_busy[3], sink_data[3]);
	serial_moody_sink #(4, 255) sink4 (clk, reset, sink_busy[4], sink_data[4]);
	serial_moody_sink #(5, 255) sink5 (clk, reset, sink_busy[5], sink_data[5]);
	serial_moody_sink #(6, 255) sink6 (clk, reset, sink_busy[6], sink_data[6]);
	serial_moody_sink #(7, 255) sink7 (clk, reset, sink_busy[7], sink_data[7]);
	serial_moody_sink #(8, 255) sink8 (clk, reset, sink_busy[8], sink_data[8]);
	serial_moody_sink #(9, 255) sink9 (clk, reset, sink_busy[9], sink_data[9]);
	serial_moody_sink #(10, 255) sink10 (clk, reset, sink_busy[10], sink_data[10]);
	serial_moody_sink #(11, 255) sink11 (clk, reset, sink_busy[11], sink_data[11]);
	serial_moody_sink #(12, 255) sink12 (clk, reset, sink_busy[12], sink_data[12]);
	serial_moody_sink #(13, 255) sink13 (clk, reset, sink_busy[13], sink_data[13]);
	serial_moody_sink #(14, 255) sink14 (clk, reset, sink_busy[14], sink_data[14]);
	serial_moody_sink #(15, 255) sink15 (clk, reset, sink_busy[15], sink_data[15]);
*/
	wire [25:0] througput [`NUM_NODES-1:0];

	serial_sink sink0 (clk, reset, sink_busy[0], sink_data[0], througput[0]);
	serial_sink sink1 (clk, reset, sink_busy[1], sink_data[1], througput[1]);
	serial_sink sink2 (clk, reset, sink_busy[2], sink_data[2], througput[2]);
	serial_sink sink3 (clk, reset, sink_busy[3], sink_data[3], througput[3]);
	serial_sink sink4 (clk, reset, sink_busy[4], sink_data[4], througput[4]);
	serial_sink sink5 (clk, reset, sink_busy[5], sink_data[5], througput[5]);
	serial_sink sink6 (clk, reset, sink_busy[6], sink_data[6], througput[6]);
	serial_sink sink7 (clk, reset, sink_busy[7], sink_data[7], througput[7]);
	serial_sink sink8 (clk, reset, sink_busy[8], sink_data[8], througput[8]);
	serial_sink sink9 (clk, reset, sink_busy[9], sink_data[9], througput[9]);
	serial_sink sink10 (clk, reset, sink_busy[10], sink_data[10], througput[10]);
	serial_sink sink11 (clk, reset, sink_busy[11], sink_data[11], througput[11]);
	serial_sink sink12 (clk, reset, sink_busy[12], sink_data[12], througput[12]);
	serial_sink sink13 (clk, reset, sink_busy[13], sink_data[13], througput[13]);
	serial_sink sink14 (clk, reset, sink_busy[14], sink_data[14], througput[14]);
	serial_sink sink15 (clk, reset, sink_busy[15], sink_data[15], througput[15]);

	// connections:
	// -----------------------------------------------------------------

	`include "connections.v"

endmodule
