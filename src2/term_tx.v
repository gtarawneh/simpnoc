`ifndef _inc_term_tx_
`define _inc_term_tx_

`include "debug_tasks.v"

module term_tx (
		clk,
		reset,
		ch_req,
		ch_flit,
		ch_ack
	);

	parameter SIZE = 8; // flit size (bits)

	output ch_req = 0;
	output [SIZE-1:0] ch_flit = 0;
	input ch_ack;

endmodule

`endif
