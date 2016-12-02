
// connection: router 0 (port 1) -> router 2 (port 3)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(1),
	.RX_PORT(3)
) con_0 (
	.tx_req(tx_req[0]),
	.tx_ack(tx_ack[0]),
	.tx_data(tx_data[0]),
	.rx_req(rx_req[2]),
	.rx_ack(rx_ack[2]),
	.rx_data(rx_data[2])
);

// connection: router 0 (port 4) -> sink 6

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(4),
	.RX_PORT(0)
) con_1 (
	.tx_req(tx_req[0]),
	.tx_ack(tx_ack[0]),
	.tx_data(tx_data[0]),
	.rx_req(snk_req[6]),
	.rx_ack(snk_ack[6]),
	.rx_data(snk_data[6])
);

// connection: router 0 (port 0) -> sink 0

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(0),
	.RX_PORT(0)
) con_2 (
	.tx_req(tx_req[0]),
	.tx_ack(tx_ack[0]),
	.tx_data(tx_data[0]),
	.rx_req(snk_req[0]),
	.rx_ack(snk_ack[0]),
	.rx_data(snk_data[0])
);

// connection: router 0 (port 2) -> router 1 (port 4)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(2),
	.RX_PORT(4)
) con_3 (
	.tx_req(tx_req[0]),
	.tx_ack(tx_ack[0]),
	.tx_data(tx_data[0]),
	.rx_req(rx_req[1]),
	.rx_ack(rx_ack[1]),
	.rx_data(rx_data[1])
);

// connection: router 0 (port 3) -> sink 4

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(3),
	.RX_PORT(0)
) con_4 (
	.tx_req(tx_req[0]),
	.tx_ack(tx_ack[0]),
	.tx_data(tx_data[0]),
	.rx_req(snk_req[4]),
	.rx_ack(snk_ack[4]),
	.rx_data(snk_data[4])
);

// connection: router 1 (port 1) -> router 3 (port 3)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(1),
	.RX_PORT(3)
) con_5 (
	.tx_req(tx_req[1]),
	.tx_ack(tx_ack[1]),
	.tx_data(tx_data[1]),
	.rx_req(rx_req[3]),
	.rx_ack(rx_ack[3]),
	.rx_data(rx_data[3])
);

// connection: router 1 (port 4) -> router 0 (port 2)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(4),
	.RX_PORT(2)
) con_6 (
	.tx_req(tx_req[1]),
	.tx_ack(tx_ack[1]),
	.tx_data(tx_data[1]),
	.rx_req(rx_req[0]),
	.rx_ack(rx_ack[0]),
	.rx_data(rx_data[0])
);

// connection: router 1 (port 0) -> sink 1

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(0),
	.RX_PORT(0)
) con_7 (
	.tx_req(tx_req[1]),
	.tx_ack(tx_ack[1]),
	.tx_data(tx_data[1]),
	.rx_req(snk_req[1]),
	.rx_ack(snk_ack[1]),
	.rx_data(snk_data[1])
);

// connection: router 1 (port 2) -> sink 8

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(2),
	.RX_PORT(0)
) con_8 (
	.tx_req(tx_req[1]),
	.tx_ack(tx_ack[1]),
	.tx_data(tx_data[1]),
	.rx_req(snk_req[8]),
	.rx_ack(snk_ack[8]),
	.rx_data(snk_data[8])
);

// connection: router 1 (port 3) -> sink 5

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(3),
	.RX_PORT(0)
) con_9 (
	.tx_req(tx_req[1]),
	.tx_ack(tx_ack[1]),
	.tx_data(tx_data[1]),
	.rx_req(snk_req[5]),
	.rx_ack(snk_ack[5]),
	.rx_data(snk_data[5])
);

// connection: router 2 (port 1) -> sink 10

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(1),
	.RX_PORT(0)
) con_10 (
	.tx_req(tx_req[2]),
	.tx_ack(tx_ack[2]),
	.tx_data(tx_data[2]),
	.rx_req(snk_req[10]),
	.rx_ack(snk_ack[10]),
	.rx_data(snk_data[10])
);

// connection: router 2 (port 4) -> sink 7

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(4),
	.RX_PORT(0)
) con_11 (
	.tx_req(tx_req[2]),
	.tx_ack(tx_ack[2]),
	.tx_data(tx_data[2]),
	.rx_req(snk_req[7]),
	.rx_ack(snk_ack[7]),
	.rx_data(snk_data[7])
);

// connection: router 2 (port 0) -> sink 2

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(0),
	.RX_PORT(0)
) con_12 (
	.tx_req(tx_req[2]),
	.tx_ack(tx_ack[2]),
	.tx_data(tx_data[2]),
	.rx_req(snk_req[2]),
	.rx_ack(snk_ack[2]),
	.rx_data(snk_data[2])
);

// connection: router 2 (port 2) -> router 3 (port 4)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(2),
	.RX_PORT(4)
) con_13 (
	.tx_req(tx_req[2]),
	.tx_ack(tx_ack[2]),
	.tx_data(tx_data[2]),
	.rx_req(rx_req[3]),
	.rx_ack(rx_ack[3]),
	.rx_data(rx_data[3])
);

// connection: router 2 (port 3) -> router 0 (port 1)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(3),
	.RX_PORT(1)
) con_14 (
	.tx_req(tx_req[2]),
	.tx_ack(tx_ack[2]),
	.tx_data(tx_data[2]),
	.rx_req(rx_req[0]),
	.rx_ack(rx_ack[0]),
	.rx_data(rx_data[0])
);

// connection: router 3 (port 1) -> sink 11

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(1),
	.RX_PORT(0)
) con_15 (
	.tx_req(tx_req[3]),
	.tx_ack(tx_ack[3]),
	.tx_data(tx_data[3]),
	.rx_req(snk_req[11]),
	.rx_ack(snk_ack[11]),
	.rx_data(snk_data[11])
);

// connection: router 3 (port 4) -> router 2 (port 2)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(4),
	.RX_PORT(2)
) con_16 (
	.tx_req(tx_req[3]),
	.tx_ack(tx_ack[3]),
	.tx_data(tx_data[3]),
	.rx_req(rx_req[2]),
	.rx_ack(rx_ack[2]),
	.rx_data(rx_data[2])
);

// connection: router 3 (port 0) -> sink 3

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(0),
	.RX_PORT(0)
) con_17 (
	.tx_req(tx_req[3]),
	.tx_ack(tx_ack[3]),
	.tx_data(tx_data[3]),
	.rx_req(snk_req[3]),
	.rx_ack(snk_ack[3]),
	.rx_data(snk_data[3])
);

// connection: router 3 (port 2) -> sink 9

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(1),
	.TX_PORT(2),
	.RX_PORT(0)
) con_18 (
	.tx_req(tx_req[3]),
	.tx_ack(tx_ack[3]),
	.tx_data(tx_data[3]),
	.rx_req(snk_req[9]),
	.rx_ack(snk_ack[9]),
	.rx_data(snk_data[9])
);

// connection: router 3 (port 3) -> router 1 (port 1)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(PORTS),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(3),
	.RX_PORT(1)
) con_19 (
	.tx_req(tx_req[3]),
	.tx_ack(tx_ack[3]),
	.tx_data(tx_data[3]),
	.rx_req(rx_req[1]),
	.rx_ack(rx_ack[1]),
	.rx_data(rx_data[1])
);

// connection: source 0 -> router 0 (port 0)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(0)
) con_20 (
	.tx_req(src_req[0]),
	.tx_ack(src_ack[0]),
	.tx_data(src_data[0]),
	.rx_req(rx_req[0]),
	.rx_ack(rx_ack[0]),
	.rx_data(rx_data[0])
);

// connection: source 1 -> router 1 (port 0)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(0)
) con_21 (
	.tx_req(src_req[1]),
	.tx_ack(src_ack[1]),
	.tx_data(src_data[1]),
	.rx_req(rx_req[1]),
	.rx_ack(rx_ack[1]),
	.rx_data(rx_data[1])
);

// connection: source 2 -> router 2 (port 0)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(0)
) con_22 (
	.tx_req(src_req[2]),
	.tx_ack(src_ack[2]),
	.tx_data(src_data[2]),
	.rx_req(rx_req[2]),
	.rx_ack(rx_ack[2]),
	.rx_data(rx_data[2])
);

// connection: source 3 -> router 3 (port 0)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(0)
) con_23 (
	.tx_req(src_req[3]),
	.tx_ack(src_ack[3]),
	.tx_data(src_data[3]),
	.rx_req(rx_req[3]),
	.rx_ack(rx_ack[3]),
	.rx_data(rx_data[3])
);

// connection: source 4 -> router 0 (port 3)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(3)
) con_24 (
	.tx_req(src_req[4]),
	.tx_ack(src_ack[4]),
	.tx_data(src_data[4]),
	.rx_req(rx_req[0]),
	.rx_ack(rx_ack[0]),
	.rx_data(rx_data[0])
);

// connection: source 5 -> router 1 (port 3)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(3)
) con_25 (
	.tx_req(src_req[5]),
	.tx_ack(src_ack[5]),
	.tx_data(src_data[5]),
	.rx_req(rx_req[1]),
	.rx_ack(rx_ack[1]),
	.rx_data(rx_data[1])
);

// connection: source 6 -> router 0 (port 4)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(4)
) con_26 (
	.tx_req(src_req[6]),
	.tx_ack(src_ack[6]),
	.tx_data(src_data[6]),
	.rx_req(rx_req[0]),
	.rx_ack(rx_ack[0]),
	.rx_data(rx_data[0])
);

// connection: source 7 -> router 2 (port 4)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(4)
) con_27 (
	.tx_req(src_req[7]),
	.tx_ack(src_ack[7]),
	.tx_data(src_data[7]),
	.rx_req(rx_req[2]),
	.rx_ack(rx_ack[2]),
	.rx_data(rx_data[2])
);

// connection: source 8 -> router 1 (port 2)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(2)
) con_28 (
	.tx_req(src_req[8]),
	.tx_ack(src_ack[8]),
	.tx_data(src_data[8]),
	.rx_req(rx_req[1]),
	.rx_ack(rx_ack[1]),
	.rx_data(rx_data[1])
);

// connection: source 9 -> router 3 (port 2)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(2)
) con_29 (
	.tx_req(src_req[9]),
	.tx_ack(src_ack[9]),
	.tx_data(src_data[9]),
	.rx_req(rx_req[3]),
	.rx_ack(rx_ack[3]),
	.rx_data(rx_data[3])
);

// connection: source 10 -> router 2 (port 1)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(1)
) con_30 (
	.tx_req(src_req[10]),
	.tx_ack(src_ack[10]),
	.tx_data(src_data[10]),
	.rx_req(rx_req[2]),
	.rx_ack(rx_ack[2]),
	.rx_data(rx_data[2])
);

// connection: source 11 -> router 3 (port 1)

connector #(
	.SIZE(SIZE),
	.TX_PORT_COUNT(1),
	.RX_PORT_COUNT(PORTS),
	.TX_PORT(0),
	.RX_PORT(1)
) con_31 (
	.tx_req(src_req[11]),
	.tx_ack(src_ack[11]),
	.tx_data(src_data[11]),
	.rx_req(rx_req[3]),
	.rx_ack(rx_ack[3]),
	.rx_data(rx_data[3])
);
