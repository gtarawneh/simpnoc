
// packet_source 0

packet_source #(
	.ID(0),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 0),
	.PACKETS(SRC_PACKETS)
) source_0 (
	clk,
	reset | ~(&ready),
	src_req[0],
	src_ack[0],
	src_data[0],
	src_done[0]
);

// packet_source 1

packet_source #(
	.ID(1),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 1),
	.PACKETS(SRC_PACKETS)
) source_1 (
	clk,
	reset | ~(&ready),
	src_req[1],
	src_ack[1],
	src_data[1],
	src_done[1]
);

// packet_source 2

packet_source #(
	.ID(2),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 2),
	.PACKETS(SRC_PACKETS)
) source_2 (
	clk,
	reset | ~(&ready),
	src_req[2],
	src_ack[2],
	src_data[2],
	src_done[2]
);

// packet_source 3

packet_source #(
	.ID(3),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 3),
	.PACKETS(SRC_PACKETS)
) source_3 (
	clk,
	reset | ~(&ready),
	src_req[3],
	src_ack[3],
	src_data[3],
	src_done[3]
);

// packet_source 4

packet_source #(
	.ID(4),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 4),
	.PACKETS(0)
) source_4 (
	clk,
	reset | ~(&ready),
	src_req[4],
	src_ack[4],
	src_data[4],
	src_done[4]
);

// packet_source 5

packet_source #(
	.ID(5),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 5),
	.PACKETS(0)
) source_5 (
	clk,
	reset | ~(&ready),
	src_req[5],
	src_ack[5],
	src_data[5],
	src_done[5]
);

// packet_source 6

packet_source #(
	.ID(6),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 6),
	.PACKETS(0)
) source_6 (
	clk,
	reset | ~(&ready),
	src_req[6],
	src_ack[6],
	src_data[6],
	src_done[6]
);

// packet_source 7

packet_source #(
	.ID(7),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 7),
	.PACKETS(0)
) source_7 (
	clk,
	reset | ~(&ready),
	src_req[7],
	src_ack[7],
	src_data[7],
	src_done[7]
);

// packet_source 8

packet_source #(
	.ID(8),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 8),
	.PACKETS(0)
) source_8 (
	clk,
	reset | ~(&ready),
	src_req[8],
	src_ack[8],
	src_data[8],
	src_done[8]
);

// packet_source 9

packet_source #(
	.ID(9),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 9),
	.PACKETS(0)
) source_9 (
	clk,
	reset | ~(&ready),
	src_req[9],
	src_ack[9],
	src_data[9],
	src_done[9]
);

// packet_source 10

packet_source #(
	.ID(10),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 10),
	.PACKETS(0)
) source_10 (
	clk,
	reset | ~(&ready),
	src_req[10],
	src_ack[10],
	src_data[10],
	src_done[10]
);

// packet_source 11

packet_source #(
	.ID(11),
	.FLITS(8),
	.SIZE(SIZE),
	.SEED(SEED + 11),
	.PACKETS(0)
) source_11 (
	clk,
	reset | ~(&ready),
	src_req[11],
	src_ack[11],
	src_data[11],
	src_done[11]
);
