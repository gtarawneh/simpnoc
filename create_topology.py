#!/bin/python

import json

def getRouterID(x, y):
	return "router_%d%d" % (x, y)

def getSinkID(x, y):
	return "sink_local_%d%d" % (x, y)

def getSourceID(x, y):
	return "source_local_%d%d" % (x, y)

def getTerminatorID(ttype, location, i):
	# ttype = tx/rx
	# location = top/bottom/left/right
	if ttype == "rx":
		return "sink_%s_%d" % (location, i)
	elif ttype == "tx":
		return "source_%s_%d" % (location, i)
	else:
		raise Exception("unknown terminator type")

def getSerializedCoords(width, height):
	# returns a list of (x, y) tuples arranged in increasing
	# order of x then y
	return [(x, y) for y in range(height) for x in range(width)]

def main():
	noc = {}
	# noc parameters
	width = 2
	height = 2
	# add routers
	for x, y in getSerializedCoords(width, height):
		isBorderLeft = x == 0
		isBorderRight = x == width-1
		isBorderTop = y == height-1
		isBorderBottom = y == 0
		leftTerm = {"destination": getTerminatorID("rx", "left", y), "port": "0"}
		rightTerm = {"destination": getTerminatorID("rx", "right", y), "port": "0"}
		topTerm = {"destination": getTerminatorID("rx", "top", x), "port": "0"}
		bottomTerm = {"destination": getTerminatorID("rx", "bottom", x), "port": "0"}
		localTerm = {"destination": getSinkID(x, y), "port": "0"}
		rightRouter = {"destination": getRouterID(x+1, y), "port": "left"}
		leftRouter = {"destination": getRouterID(x-1, y), "port": "right"}
		topRouter = {"destination": getRouterID(x, y+1), "port": "bottom"}
		bottomRouter = {"destination": getRouterID(x, y-1), "port": "top"}
		cons = {
			"right": rightTerm if isBorderRight else rightRouter,
			"left": leftTerm if isBorderLeft else leftRouter,
			"top": topTerm if isBorderTop else topRouter,
			"bottom": bottomTerm if isBorderBottom else bottomRouter,
			"local": localTerm
		}
		noc[getRouterID(x,y)] = {
			"class": "router",
			"connections": cons,
			"table": {
				"0" : "right",
				"default": "local"
			}
		}
	# add sinks
	localSinks = [getSinkID(x, y) for x, y in getSerializedCoords(width, height)]
	topSinks = [getTerminatorID("rx", "top", x) for x in range(width)]
	bottomSinks = [getTerminatorID("rx", "bottom", x) for x in range(width)]
	leftSinks = [getTerminatorID("rx", "left", x) for x in range(height)]
	rightSinks = [getTerminatorID("rx", "right", x) for x in range(height)]
	sinks = localSinks + topSinks + bottomSinks + leftSinks + rightSinks
	for ind, sinkID in enumerate(sinks):
		noc[sinkID] = {
			"class": "sink",
			"address": str(ind)
		}
	# add local sources
	for x, y, in getSerializedCoords(width, height):
		cons = {
			"0": {
				"destination": getRouterID(x, y),
				"port": "local"
			}
		}
		noc[getSourceID(x, y)] = {"class": "source", "flits": 1, "connections": cons}
	# add terminators (top & bottom)
	for x in range(width):
		noc[getTerminatorID("tx", "top", x)] = {"class": "source", "flits": 0}
		noc[getTerminatorID("tx", "bottom", x)] = {"class": "source", "flits": 0}
	# add terminators (left & right)
	for y in range(height):
		noc[getTerminatorID("tx", "left", y)] = {"class": "source", "flits": 0}
		noc[getTerminatorID("tx", "right", y)] = {"class": "source", "flits": 0}
	# add routing tables
	for rx, ry in getSerializedCoords(width, height):
		routerID = getRouterID(rx, ry)
		table = {}
		for sx, sy in getSerializedCoords(width, height):
			sinkID = getSinkID(sx, sy)
			sinkAddr = noc[sinkID]["address"]
			if (rx, ry) == (sx, sy):
				port = "local"
			elif sx > rx:
				port = "right"
			elif sx < rx:
				port = "left"
			elif sy < ry:
				port = "bottom"
			else:
				port = "top"
			table[sinkAddr] = port
		table["default"] = "local"
		noc[routerID]["table"] = table
	with open("gen/noc.json", "w") as fid:
		fid.write(json.dumps(noc, indent = 4, sort_keys = True))

main()
