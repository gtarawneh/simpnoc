connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORT_COUNT),
	.RX_PORT_COUNT(1),
	.TX_PORT(0),
	.RX_PORT(0)
) con3 (
	.tx_req(tx_req[2]),
	.tx_ack(tx_ack[2]),
	.tx_data(tx_data[2]),
	.rx_req(snk_req[0]),
	.rx_ack(snk_ack[0]),
	.rx_data(snk_data[0])
);
