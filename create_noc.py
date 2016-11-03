#!/bin/python

from textwrap import dedent

def main():
	print(str1)

def insertSource(id):
	code = """
		// source %ID

		source2 #(
			.ID(%ID),
			.DESTINATION(100 + %ID),
			.MAX_FLITS(1),
			.SIZE(SIZE),
			.PAYLOAD(10 + %ID)
		) src1 (
			.clk(clk),
			.reset(reset),
			.req(src_req[%ID]),
			.ack(src_ack[%ID]),
			.data(src_data[%ID])
		);
	"""
	return insertCode(code, {"%ID": str(id)})

def insertSink(id):
	code ="""
		// sink %ID

		sink2 #(
			.ID(%ID)
		) snk1 (
			.clk(clk),
			.reset(reset),
			.req(snk_req[%ID]),
			.ack(snk_ack[%ID]),
			.data(snk_data[%ID])
		);
	"""
	return insertCode(code, {"%ID": str(id)})

def insertConnectionRR(router1, router2, port1, port2):
	code = """
		// connection: router %R1 (port %P1) -> router %R2 (port %P2)

		connector #(
			.SIZE(SIZE),
			.TX_PORT_COUNT(PORT_COUNT),
			.RX_PORT_COUNT(PORT_COUNT),
			.TX_PORT(%P1),
			.RX_PORT(%P2)
		) con2 (
			.tx_req(tx_req[%R1]),
			.tx_ack(tx_ack[%R1]),
			.tx_data(tx_data[%R1]),
			.rx_req(rx_req[%R2]),
			.rx_ack(rx_ack[%R2]),
			.rx_data(rx_data[%R2])
		);
	"""
	reps = {
		"%R1" : str(router1),
		"%R2" : str(router2),
		"%P1" : str(port1),
		"%P2" : str(port2),
	}
	return insertCode(code, reps)

def insertConnectionSR(source, router, port):
	code = """
		// connection: source %SOURCE -> router %ROUTER (port %PORT)

		connector #(
			.SIZE(SIZE),
			.TX_PORT_COUNT(1),
			.RX_PORT_COUNT(PORT_COUNT),
			.TX_PORT(0),
			.RX_PORT(%PORT)
		) con1 (
			.tx_req(src_req[%SOURCE]),
			.tx_ack(src_ack[%SOURCE]),
			.tx_data(src_data[%SOURCE]),
			.rx_req(rx_req[0]),
			.rx_ack(rx_ack[0]),
			.rx_data(rx_data[0])
		);
	"""
	reps = {
		"%SOURCE" : str(source),
		"%ROUTER" : str(router),
		"%PORT" : str(port),
	}
	return insertCode(code, reps)

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
	return insertCode(code, {"%ID": str(id)})

def insertCode(code, replaceDict):
	code = dedent(code)
	for identifier in replaceDict.keys():
		code = code.replace(identifier, replaceDict[identifier])
	return code

def main():
	with open("output/gen_routers_test.v", "w") as fid:
		fid.write(insertRouter(0))
		fid.write(insertConnectionRR(1, 3, 0, 1))
		fid.write(insertSource(5))
		fid.write(insertConnectionSR(2, 3, 5))
main()
