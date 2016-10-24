module rx_logic_2 (
		clk,
		reset,
		fifo_push_req,
		fifo_push_ack,
		fifo_push_data,
		fifo_write,
		fifo_full,
		fifo_data_in,
	);

	input clk, reset;

	input [4:0] fifo_push_req;
	output [4:0] fifo_push_ack;
	input [`SIZE*5-1:0] fifo_push_data;
	output fifo_write;
	input fifo_full;
	output [`SIZE-1:0] fifo_data_in;

	// TODO: expand stub

	assign fifo_write = 0;
	assign fifo_data_in = 0;

endmodule