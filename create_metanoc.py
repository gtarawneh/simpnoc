#!/bin/python

import textwrap
import json
from random import randint

def insertSource(ID, packets = None):
	code = """
		// packet_source %ID

		packet_source #(
			.ID(%ID),
			.FLITS(8),
			.SIZE(SIZE),
			.SEED(SEED + %ID),
			.PACKETS(%PACKETS),
			.SOURCE_RATE(SOURCE_RATE),
			.VERBOSE_DEBUG(VERBOSE_DEBUG)
		) source_%ID (
			clk,
			reset | ~(&ready),
			src_req[%ID],
			src_ack[%ID],
			src_data[%ID],
			src_done[%ID]
		);
	"""
	reps = {
		"%PACKETS" : str(packets) if (packets != None) else "SRC_PACKETS",
		"%ID" : str(ID),
		"%SEED" : str(randint(0, 1e5))
	}
	return insertCode(code, reps)

def insertSink(ID):
	code ="""
		// packet sink %ID

		packet_sink #(
			.ID(%ID),
			.PORT_BITS(PORT_BITS),
			.SIZE(SIZE),
			.SINK_RATE(SINK_RATE),
			.SEED(SEED + %ID),
			.VERBOSE_DEBUG(VERBOSE_DEBUG)
		) sink_%ID (
			clk,
			reset,
			snk_req[%ID],
			snk_data[%ID],
			snk_ack[%ID]
		);
	"""
	reps = {
		"%ID" : str(ID),
	}
	return insertCode(code, reps)

def insertTerminatorTX(ID):
	code ="""
		// term_tx %ID

		term_tx term_tx_%ID (
			clk,
			reset,
			term_tx_req[%ID],
			term_tx_data[%ID],
			term_tx_ack[%ID]
		);

	"""
	reps = {
		"%ID" : str(ID),
	}
	return insertCode(code, reps)

def insertTerminatorRX(ID):
	code ="""
		// term_rx %ID

		term_rx term_rx_%ID (
			clk,
			reset,
			term_rx_req[%ID],
			term_rx_data[%ID],
			term_rx_ack[%ID]
		);

	"""
	reps = {
		"%ID" : str(ID),
	}
	return insertCode(code, reps)


def insertConnection(conInd, ind1, ind2, class1, class2, port1, port2):
	t = (class1, class2)
	if t == ("router", "router"):
		return insertConnectionRR(conInd, ind1, ind2, port1, port2)
	elif t == ("router", "sink"):
		return insertConnectionRS(conInd, ind1, ind2, port1)
	elif t == ("source", "router"):
		return insertConnectionSR(conInd, ind1, ind2, port2)
	elif t == ("router", "term_rx"):
		# TODO
		return insertConnectionRT(conID, ind1, ind2, port1)
	elif t == ("term_tx", "router"):
		# TODO
		return insertConnectionTR(conID, ind1, ind2, port2)
	else:
		# TODO
		raise Exception("connection type not implemented yet")

def insertConnectionRR(conInd, router1, router2, port1, port2):
	code = """
		// connection: router %R1 (port %P1) -> router %R2 (port %P2)

		connector #(
			.SIZE(SIZE),
			.TX_PORT_COUNT(PORTS),
			.RX_PORT_COUNT(PORTS),
			.TX_PORT(%P1),
			.RX_PORT(%P2)
		) con_%CON_ID (
			.tx_req(tx_req[%R1]),
			.tx_ack(tx_ack[%R1]),
			.tx_data(tx_data[%R1]),
			.rx_req(rx_req[%R2]),
			.rx_ack(rx_ack[%R2]),
			.rx_data(rx_data[%R2])
		);
	"""
	reps = {
		"%CON_ID" : str(conInd),
		"%R1" : str(router1),
		"%R2" : str(router2),
		"%P1" : str(port1),
		"%P2" : str(port2),
	}
	return insertCode(code, reps)

def insertConnectionSR(conInd, source, router, port):
	code = """
		// connection: source %SOURCE -> router %ROUTER (port %PORT)

		connector #(
			.SIZE(SIZE),
			.TX_PORT_COUNT(1),
			.RX_PORT_COUNT(PORTS),
			.TX_PORT(0),
			.RX_PORT(%PORT)
		) con_%CON_ID (
			.tx_req(src_req[%SOURCE]),
			.tx_ack(src_ack[%SOURCE]),
			.tx_data(src_data[%SOURCE]),
			.rx_req(rx_req[%ROUTER]),
			.rx_ack(rx_ack[%ROUTER]),
			.rx_data(rx_data[%ROUTER])
		);
	"""
	reps = {
		"%CON_ID" : str(conInd),
		"%SOURCE" : str(source),
		"%ROUTER" : str(router),
		"%PORT" : str(port),
	}
	return insertCode(code, reps)

def insertConnectionRS(conInd, router, sink, port):
	code = """
		// connection: router %ROUTER (port %PORT) -> sink %SINK

		connector #(
			.SIZE(SIZE),
			.TX_PORT_COUNT(PORTS),
			.RX_PORT_COUNT(1),
			.TX_PORT(%PORT),
			.RX_PORT(0)
		) con_%CON_ID (
			.tx_req(tx_req[%ROUTER]),
			.tx_ack(tx_ack[%ROUTER]),
			.tx_data(tx_data[%ROUTER]),
			.rx_req(snk_req[%SINK]),
			.rx_ack(snk_ack[%SINK]),
			.rx_data(snk_data[%SINK])
		);
	"""
	reps = {
		"%CON_ID" : str(conInd),
		"%SINK" : str(sink),
		"%ROUTER" : str(router),
		"%PORT" : str(port),
	}
	return insertCode(code, reps)

def insertConnectionRT(conInd, router, term, port):
	code = """
		// connection: router %ROUTER (port %PORT) -> term_rx %TERM

		connector #(
			.SIZE(SIZE),
			.TX_PORT_COUNT(PORTS),
			.RX_PORT_COUNT(1),
			.TX_PORT(%PORT),
			.RX_PORT(0)
		) con_%CON_ID (
			.tx_req(tx_req[%ROUTER]),
			.tx_ack(tx_ack[%ROUTER]),
			.tx_data(tx_data[%ROUTER]),
			.rx_req(term_rx_req[%TERM]),
			.rx_ack(term_rx_ack[%TERM]),
			.rx_data(term_rx_data[%TERM])
		);
	"""
	reps = {
		"%CON_ID" : str(conInd),
		"%TERM" : str(term_rx),
		"%ROUTER" : str(router),
		"%PORT" : str(port),
	}
	return insertCode(code, reps)

def insertConnectionTR(conInd, term, router, port):
	code = """
		// connection: term_tx %TERM -> router %ROUTER (port %PORT)

		connector #(
			.SIZE(SIZE),
			.TX_PORT_COUNT(1),
			.RX_PORT_COUNT(PORTS),
			.TX_PORT(0)
			.RX_PORT(%PORT),
		) con_%CON_ID (
			.tx_req(term_tx_req[%TERM]),
			.tx_ack(term_tx_ack[%TERM]),
			.tx_data(term_tx_data[%TERM])
			.rx_req(rx_req[%ROUTER]),
			.rx_ack(rx_ack[%ROUTER]),
			.rx_data(rx_data[%ROUTER]),
		);
	"""
	reps = {
		"%CON_ID" : str(conInd),
		"%TERM" : str(term_rx),
		"%ROUTER" : str(router),
		"%PORT" : str(port),
	}
	return insertCode(code, reps)


def insertRouter(routerID):
	code = """
		// router %ID

		router #(
			.ID(%ID),
			.PORTS(PORTS),
			.PORT_BITS(PORT_BITS),
			.SIZE(SIZE),
			.VERBOSE_DEBUG(VERBOSE_DEBUG)
		) r%ID (
			reset,
			clk,
			rx_req[%ID],
			rx_ack[%ID],
			rx_data[%ID],
			tx_req[%ID],
			tx_ack[%ID],
			tx_data[%ID],
			table_addr[%ID],
			table_data[%ID],
			ready[%ID]
		);
	"""
	return insertCode(code, {"%ID": str(routerID)})

def insertTable(tabID, table):
	lines = [
		"",
		"// routing table (router %ID)",
		"",
		"always @(table_addr[%ID]) case (table_addr[%ID])"
	]
	for destination in sorted(table.keys()):
		port = table[destination]
		pStr = str(getPortIndex(port))
		reps = {"%DEST" : destination, "%PORT": pStr}
		code = "\t%-10s : table_data[%s] = %s;" % (destination, "%ID", pStr)
		lines.append(code)
	lines += ["endcase", ""]
	code = '\n'.join(lines)
	return insertCode(code, {"%ID": str(tabID)})

def insertParams(routerCount, sourceCount, sinkCount):
	code = """
		localparam PORTS = 5;
		localparam PORT_BITS = 8;
		localparam SIZE = 8; // flit bits
		localparam DEST_BITS = SIZE - 1; // bits to designate requested destination
		localparam DESTS = 2 ** DEST_BITS;
		localparam ROUTER_COUNT = %ROUTERS;
		localparam SINK_COUNT = %SINKS;
		localparam SOURCE_COUNT = %SOURCES;
		localparam VERBOSE_DEBUG = 0;
	"""
	reps = {
		"%ROUTERS": str(routerCount),
		"%SOURCES": str(sourceCount),
		"%SINKS": str(sinkCount)
	}
	return insertCode(code, reps)

def insertCode(code, replaceDict):
	code = textwrap.dedent(code)
	for identifier in replaceDict.keys():
		code = code.replace(identifier, replaceDict[identifier])
	return code

def getIndexMap(topology, types):
	indMap = {}
	for t in types:
		objects = getTypeList(topology, t)
		n = len(objects)
		for obj, i in zip(sorted(objects), range(n)):
			indMap[obj] = i
	return indMap

def getTypeList(topology, type):
	# returns objects in the hashmap `topology` of the class `type`
	return [x for x in sorted(topology.keys()) if topology[x]["class"] == type]

def getPortIndex(portName):
	mappings = {
		# numeric convention
		"0" : 0,
		"1" : 1,
		"2" : 2,
		"3" : 3,
		"4" : 4,
		# direction convention 1
		"top" : 1,
		"right" : 2,
		"bottom" : 3,
		"left" : 4,
		# direction convention 2
		"local" : 0,
		"north": 1,
		"east": 2,
		"south" : 3,
		"west" : 4,
	}
	return mappings[portName]

def main():
	noc_fil = "gen2/noc.json"
	routers_file = "gen2/gen_routers.v"
	params_file = "gen2/gen_params.v"
	connections_file = "gen2/gen_connections.v"
	sources_file = "gen2/gen_sources.v"
	sinks_file = "gen2/gen_sinks.v"
	tables_file = "gen2/gen_tables.v"
	with open(noc_fil) as fid:
		topology = json.load(fid)
	indMap = getIndexMap(topology, ["router", "source", "sink"])
	routers = getTypeList(topology, "router")
	sources = getTypeList(topology, "source")
	sinks = getTypeList(topology, "sink")
	transmitters = routers + sources;
	with open(routers_file, "w") as fid:
		for r in routers:
			ind = indMap[r]
			fid.write(insertRouter(ind))
		print("Generated %s" % routers_file)
	with open(sinks_file, "w") as fid:
		for s in sinks:
			ind = indMap[s]
			fid.write(insertSink(ind))
		print("Generated %s" % sinks_file)
	with open(sources_file, "w") as fid:
		for s in sources:
			ind = indMap[s]
			packets = topology[s].get("packets")
			fid.write(insertSource(ind, packets))
		print("Generated %s" % sources_file)
	with open(connections_file, "w") as fid:
		conInd = 0
		for r in transmitters:
			lClass = topology[r]["class"]
			ind = indMap[r]
			cons = topology[r].get("connections", {})
			if cons:
				for port in cons.keys():
					destination = cons[port]["to"]
					dPort = cons[port]["port"]
					portInd = getPortIndex(port)
					dPortInd = getPortIndex(dPort)
					dClass = topology[destination]["class"]
					dInd = indMap[destination]
					str1 = insertConnection(conInd, ind, dInd, lClass, dClass, portInd, dPortInd)
					fid.write(str1)
					conInd += 1
			else:
				print("Warning: transmitter <%s> has no outgoing connections" % r)
		print("Generated %s" % connections_file)
	with open(tables_file, "w") as fid:
		for r in routers:
			ind = indMap[r]
			table = topology[r]["table"]
			str1 = insertTable(ind, table)
			fid.write(str1)
		print("Generated %s" % tables_file)
	with open(params_file, "w") as fid:
		routerCount = len(routers)
		sourceCount = len(sources)
		sinkCount = len(sinks)
		str1 = insertParams(routerCount, sourceCount, sinkCount)
		fid.write(str1)
		print("Generated %s" % params_file)
	n1 = len(routers)
	n2 = len(sources)
	n3 = len(sinks)
	print("Completed generating topology (%d routers, %d sources and %d sinks)" % (n1, n2, n3))

main()
