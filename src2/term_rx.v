`ifndef _inc_term_rx_
`define _inc_term_rx_

`include "debug_tasks.v"

module term_rx (
		clk,
		reset,
		ch_req,
		ch_flit,
		ch_ack
	);

	parameter SIZE = 8; // flit size (bits)

	input ch_req;
	input [SIZE-1:0] ch_flit;
	output ch_ack = 0;

endmodule

`endif
