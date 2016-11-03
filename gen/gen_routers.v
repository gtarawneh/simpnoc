generate
	for (i=0; i<ROUTER_COUNT; i=i+1) begin
		router2 #(
			.ID(i),
			.SIZE(SIZE),
			.PORT_COUNT(PORT_COUNT),
			.DESTINATION_BITS(DESTINATION_BITS),
			.DEPTH_LOG2(DEPTH_LOG2)
		) ri (
			clk,
			reset,
			tx_req[i],
			tx_ack[i],
			tx_data[i],
			rx_req[i],
			rx_ack[i],
			rx_data[i],
			table_addr[i],
			table_data[i]
		);
		assign table_data[i] = 0; // dummy routing table
	end
endgenerate
