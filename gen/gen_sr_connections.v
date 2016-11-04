// source -> router connections

generate
	for (i=0; i<1; i=i+1) begin
		connector #(
			.SIZE(SIZE),
			.TX_PORT_COUNT(1),
			.RX_PORT_COUNT(PORT_COUNT),
			.TX_PORT(0),
			.RX_PORT(i)
		) con1 (
			.tx_req(src_req[i]),
			.tx_ack(src_ack[i]),
			.tx_data(src_data[i]),
			.rx_req(rx_req[0]),
			.rx_ack(rx_ack[0]),
			.rx_data(rx_data[0])
		);
end
endgenerate