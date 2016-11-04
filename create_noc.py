#!/bin/python

import textwrap
import json

def insertSource(ind, id, flits):
	code = """
		// source %IND (%ID)

		source2 #(
			.ID(%IND),
			.DESTINATION(100 + %IND),
			.MAX_FLITS(%FLITS),
			.SIZE(SIZE),
			.PAYLOAD(10 + %IND)
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
		"%ID" : id,
		"%FLITS" : str(flits),
	}
	return insertCode(code, reps)

def insertSink(id):
	code ="""
		// sink %ID

		sink2 #(
			.ID(%ID)
		) snk_%ID (
			.clk(clk),
			.reset(reset),
			.req(snk_req[%ID]),
			.ack(snk_ack[%ID]),
			.data(snk_data[%ID])
		);
	"""
	return insertCode(code, {"%ID": str(id)})

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
			.rx_req(rx_req[0]),
			.rx_ack(rx_ack[0]),
			.rx_data(rx_data[0])
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

def insertRouter(id):
	code = """
		// router %ID

		router2 #(
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

		assign table_data[%ID] = 0; // dummy routing table
	"""
	return insertCode(code, {"%ID": str(id)})

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
		"top" : 0,
		"right" : 1,
		"bottom" : 2,
		"left" : 3,
		"inside" : 4,
		# direction convention 2
		"north": 0,
		"east": 1,
		"south" : 2,
		"west" : 3,
		"local" : 4,
	}
	return mappings[portName]

def main():
	file = "gen/noc.json"
	with open(file) as fid:
		topology = json.load(fid)
	indMap = getIndexMap(topology, ["router", "source", "sink"])
	routers = getTypeList(topology, "router")
	sources = getTypeList(topology, "source")
	sinks = getTypeList(topology, "sink")
	with open("gen/gen_routers.v", "w") as fid:
		for r in routers:
			ind = indMap[r]
			fid.write(insertRouter(ind))
			print("Generated router %d ...." % ind)
	with open("gen/gen_sinks.v", "w") as fid:
		for s in sinks:
			ind = indMap[s]
			fid.write(insertSink(ind))
			print("Generated sink %d ...." % ind)
	with open("gen/gen_sources.v", "w") as fid:
		for s in sources:
			ind = indMap[s]
			flits = topology[s]["flits"]
			fid.write(insertSource(ind, s, flits))
			print("Generated source %d ...." % ind)
	with open("gen/gen_connections.v", "w") as fid:
		conInd = 0
		for r in topology:
			lClass = topology[r]["class"]
			ind = indMap[r]
			cons = topology[r].get("connections", {})
			for port in cons.keys():
				destination = cons[port]["destination"]
				dPort = cons[port]["port"]
				portInd = getPortIndex(port)
				dPortInd = getPortIndex(dPort)
				dClass = topology[destination]["class"]
				dInd = indMap[destination]
				str1 = insertConnection(conInd, ind, dInd, lClass, dClass, portInd, dPortInd)
				print("Generated connection: %s %d (port %d)-> %s %d (port %d) ...." % (lClass, ind, portInd, dClass, dInd, dPortInd))
				fid.write(str1)
				conInd += 1
	n1 = len(routers)
	n2 = len(sources)
	n3 = len(sinks)
	print("generated topology with %d routers, %d sources and %d sinks" % (n1, n2, n3))

main()
