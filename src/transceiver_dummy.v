// This module is an intermediate for two entities communicating through a two
// phase handshake. Signals with postfix 1 belong to the channel with the
// sending entity (i.e. req1 asks the module to transmit data1) and those with
// postfix 2 belong to the channel with the receiving entity (i.e. req2
// initiates a handshake with the item in data2).

module transceiver_dummy (clk, reset, req1, ack1, data1, req2, ack2, data2);

	parameter ID = -1; // parent router id
	parameter PORT = "unknown";
	parameter SIZE = 8;

	input clk, reset;

	// router-side port:

	input req1;

	input [SIZE-1:0] data1;

	output ack1;

	// remote rx port:

	output req2;

	output [SIZE-1:0] data2;

	input ack2;

	assign req2 = req1;

	assign ack1 = ack2;

	assign data2 = data1;

endmodule
