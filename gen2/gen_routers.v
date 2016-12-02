
// router 0

router #(
	.ID(0),
	.PORTS(PORTS),
	.PORT_BITS(PORT_BITS),
	.SIZE(SIZE)
) r0 (
	reset,
	clk,
	rx_req[0],
	rx_ack[0],
	rx_data[0],
	tx_req[0],
	tx_ack[0],
	tx_data[0],
	table_addr[0],
	table_data[0],
	ready[0]
);

// router 1

router #(
	.ID(1),
	.PORTS(PORTS),
	.PORT_BITS(PORT_BITS),
	.SIZE(SIZE)
) r1 (
	reset,
	clk,
	rx_req[1],
	rx_ack[1],
	rx_data[1],
	tx_req[1],
	tx_ack[1],
	tx_data[1],
	table_addr[1],
	table_data[1],
	ready[1]
);

// router 2

router #(
	.ID(2),
	.PORTS(PORTS),
	.PORT_BITS(PORT_BITS),
	.SIZE(SIZE)
) r2 (
	reset,
	clk,
	rx_req[2],
	rx_ack[2],
	rx_data[2],
	tx_req[2],
	tx_ack[2],
	tx_data[2],
	table_addr[2],
	table_data[2],
	ready[2]
);

// router 3

router #(
	.ID(3),
	.PORTS(PORTS),
	.PORT_BITS(PORT_BITS),
	.SIZE(SIZE)
) r3 (
	reset,
	clk,
	rx_req[3],
	rx_ack[3],
	rx_data[3],
	tx_req[3],
	tx_ack[3],
	tx_data[3],
	table_addr[3],
	table_data[3],
	ready[3]
);
