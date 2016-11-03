#!/bin/python

from textwrap import dedent

def main():
	print(str1)

str1 = """
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
"""

def insertSource(id):
	pass

def insertSink(id):
	pass

def insertConnectionRR(router1, router2, port1, port2):
	pass

def insertConnectionSR(source, router):
	pass

def insertConnectionRS(router, sink):
	pass

def insertTerminatorRX(router, port):
	pass

def insertTerminatorTX(router, port):
	pass


def insertRouter(id):
	code = """
		// router %ID

		router2 #(
			.ID(%ID),
			.SIZE(SIZE),
			.PORT_COUNT(PORT_COUNT),
			.DESTINATION_BITS(DESTINATION_BITS),
			.DEPTH_LOG2(DEPTH_LOG2)
		) ri (
			clk,
			reset,
			tx_req[%ID],
			tx_ack[%ID],
			tx_data[%ID],
			rx_req[%ID],
			rx_ack[%ID],
			rx_data[%ID],
			table_addr[%ID],
			table_data[%ID]
		);

		assign table_data[%ID] = 0; // dummy routing table
	"""
	# print(dedent(code).replace("%ID", str(id)))
	return insertCode(code, {"%ID": str(id)})

def insertCode(code, replaceDict):
	code = dedent(code)
	for identifier in replaceDict.keys():
		code = code.replace(identifier, replaceDict[identifier])
	return code


def main():
	with open("output/gen_routers_test.v", "w") as fid:
		for i in range(1):
			fid.write(insertRouter(i))
main()
