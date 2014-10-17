module ch_rx_logic(item_out, write, full, 
		valid, item_in, item_read
		);

	input full;
	
	input valid;
	
	output item_read;
	
	output write;
	
	input [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_in;
	
	output [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_out;

	assign item_out = item_in;
	
	assign write = !full & valid;
	
	assign item_read = !full & valid;
	
endmodule
