`ifndef _inc_switch_logic_
`define _inc_switch_logic_

// This module implements the router's crossbar switching logic. From each
// input buffer, it receives: (signal: send, bus: dest and signal: isHead) and
// for each output buffer it produces: sel (bus).

module switch_logic (clk, reset, send, dest, isHead, sel);

	parameter ID = 0;
	parameter DESTINATION_BITS = 4;
	parameter PORT_BITS = 4;
	parameter PORT_COUNT = 5;

	input clk, reset;
	input [PORT_COUNT-1:0] send;
	input [PORT_COUNT*DESTINATION_BITS-1:0] dest;
	input [PORT_COUNT-1:0] isHead;
	output [PORT_BITS*PORT_COUNT-1:0] sel;

	reg [PORT_BITS-1:0] selected [PORT_COUNT-1:0];
	reg [255:0] flits [PORT_COUNT:0];

	always @(posedge clk or posedge reset) begin

		if (reset) begin

		end


	end



endmodule
