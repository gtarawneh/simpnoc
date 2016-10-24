module tx_logic_2 (
		clk,
		reset,
		fifo_pop_req,
		fifo_pop_ack,
		fifo_pop_data,
		fifo_read,
		fifo_empty,
		fifo_data_out,
	);

	input clk, reset;

	output [4:0] fifo_pop_req;
	output [4:0] fifo_pop_ack;
	output [5*`SIZE-1:0] fifo_pop_data;

	output fifo_read;
	input fifo_empty;
	input [`SIZE-1:0] fifo_data_out;

endmodule