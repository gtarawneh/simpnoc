#!/bin/python

import textwrap
import json

def insertSource(ind, sourceID, flits, destination):
	code = """
		// source %IND (%ID)

		source #(
			.ID(%IND),
			.DESTINATION(%DEST),
			.MAX_FLITS(%FLITS),
			.SIZE(SIZE),
			.PAYLOAD(%DEST)
		) source_%ID (
			.clk(clk),
			.reset(reset),
			.req(src_req[%IND]),
			.ack(src_ack[%IND]),
			.data(src_data[%IND])
		);
	"""
	reps = {
		"%IND" : str(ind),
		"%ID" : sourceID,
		"%FLITS" : str(flits),
		"%DEST": str(destination),
	}
	return insertCode(code, reps)

def insertSink(sinkID):
	code ="""
		// sink %ID

		sink #(
			.ID(%ID)
		) snk_%ID (
			.clk(clk),
			.reset(reset),
			.req(snk_req[%ID]),
			.ack(snk_ack[%ID]),
			.data(snk_data[%ID])
		);
	"""
	return insertCode(code, {"%ID": str(sinkID)})

def insertConnection(conInd, ind1, ind2, class1, class2, port1, port2):
	if class1 == "router":
		if class2 == "router":
			return insertConnectionRR(conInd, ind1, ind2, port1, port2)
		elif class2 == "sink":
			return insertConnectionRS(conInd, ind1, ind2, port1)
	elif class1 == "source":
		if class2 == "router":
			return insertConnectionSR(conInd, ind1, ind2, port2)
		elif class2 == "sink":
			# TODO
			raise Exception ("source-sink connection not yet implemented")

def insertConnectionRR(conInd, router1, router2, port1, port2):
	code = """
		// connection: router %R1 (port %P1) -> router %R2 (port %P2)

		connector #(
			.SIZE(SIZE),
			.TX_PORT_COUNT(PORT_COUNT),
			.RX_PORT_COUNT(PORT_COUNT),
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
			.RX_PORT_COUNT(PORT_COUNT),
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
			.TX_PORT_COUNT(PORT_COUNT),
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

def insertRouter(routerID):
	code = """
		// router %ID

		router #(
			.ID(%ID),
			.SIZE(SIZE),
			.PORT_COUNT(PORT_COUNT),
			.DESTINATION_BITS(DESTINATION_BITS),
			.DEPTH_LOG2(DEPTH_LOG2)
		) router_%ID (
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
	"""
	return insertCode(code, {"%ID": str(routerID)})

def insertTable(tabID, table):
	lines = [
		"",
		"// routing table (router %ID)",
		"",
		"always @(clk or reset or table_addr[%ID]) case (table_addr[%ID])"
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
		localparam SIZE = 8; // data bits
		localparam PORT_COUNT = 5; // number of ports
		localparam DESTINATION_BITS = 3; // number of bits to specify port
		localparam DEPTH_LOG2 = 4;
		localparam ROUTER_COUNT = %ROUTERS;
		localparam SINK_COUNT = %SINKS;
		localparam SOURCE_COUNT = %SOURCES;
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
	noc_fil = "gen/noc.json"
	routers_file = "gen/gen_routers.v"
	params_file = "gen/gen_params.v"
	connections_file = "gen/gen_connections.v"
	sources_file = "gen/gen_sources.v"
	sinks_file = "gen/gen_sinks.v"
	tables_file = "gen/gen_tables.v"
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
			flits = topology[s]["flits"]
			dest = topology[s]["destination"]
			fid.write(insertSource(ind, s, flits, dest))
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
