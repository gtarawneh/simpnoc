// inter-router connectors

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORT_COUNT),
	.RX_PORT_COUNT(PORT_COUNT),
	.TX_PORT(0),
	.RX_PORT(1)
) con1 (
	.tx_req(tx_req[0]),
	.tx_ack(tx_ack[0]),
	.tx_data(tx_data[0]),
	.rx_req(rx_req[1]),
	.rx_ack(rx_ack[1]),
	.rx_data(rx_data[1])
);

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORT_COUNT),
	.RX_PORT_COUNT(PORT_COUNT),
	.TX_PORT(0),
	.RX_PORT(1)
) con2 (
	.tx_req(tx_req[1]),
	.tx_ack(tx_ack[1]),
	.tx_data(tx_data[1]),
	.rx_req(rx_req[2]),
	.rx_ack(rx_ack[2]),
	.rx_data(rx_data[2])
);
