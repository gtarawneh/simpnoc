`define SIZE 8

`include "sink2.v"
`include "source2.v"
`include "generator.v"

module testbench_source_sink();

	initial begin
		$display("start of stimulation");
		// $dumpfile("output/dump.vcd");
		// $dumpvars(0, testbench_simple);
		#250
		$display("end of stimulation");
		$finish;
	end

	reg clk, reset;

	initial begin
		reset <= 1;
		clk <= 0;
		#1
		reset <= 0;
	end

	always begin
		#1
		clk <= ~clk;
	end

	wire req, ack;

	wire [`SIZE-1:0] data;

	source2 #(.max_flits(5)) src1 (clk, reset, req, ack, data);

	sink2 snk1 (clk, reset, req, ack, data);

endmodule
