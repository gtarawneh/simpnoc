#!/bin/python

import json
import os

def getRouterID(x, y, width, height):
	ind = getIndex(x, y, width, height)
	return "router_%02d" % ind

def getSinkID(x, y, width, height):
	ind = getIndex(x, y, width, height)
	return "sink_%02d" % ind

def getSourceID(x, y, width, height):
	ind = getIndex(x, y, width, height)
	return "source_%02d" % ind

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
	width = 4
	height = 4
	# add routers
	for x, y in getSerializedCoords(width, height):
		isBorderLeft = x == 0
		isBorderRight = x == width-1
		isBorderTop = y == height-1
		isBorderBottom = y == 0
		leftTerm = {"to": getTerminatorID("rx", "left", y), "port": "local"}
		rightTerm = {"to": getTerminatorID("rx", "right", y), "port": "local"}
		topTerm = {"to": getTerminatorID("rx", "top", x), "port": "local"}
		bottomTerm = {"to": getTerminatorID("rx", "bottom", x), "port": "local"}
		localTerm = {"to": getSinkID(x, y, width, height), "port": "local"}
		rightRouter = {"to": getRouterID(x+1, y, width, height), "port": "left"}
		leftRouter = {"to": getRouterID(x-1, y, width, height), "port": "right"}
		topRouter = {"to": getRouterID(x, y+1, width, height), "port": "bottom"}
		bottomRouter = {"to": getRouterID(x, y-1, width, height), "port": "top"}
		cons = {
			"right": rightTerm if isBorderRight else rightRouter,
			"left": leftTerm if isBorderLeft else leftRouter,
			"top": topTerm if isBorderTop else topRouter,
			"bottom": bottomTerm if isBorderBottom else bottomRouter,
			"local": localTerm
		}
		noc[getRouterID(x, y, width, height)] = {
			"class": "router",
			"connections": cons,
			"table": getRoutingTableXY(x, y, width, height)
		}
	# add sinks
	localSinks = [getSinkID(x, y, width, height) for x, y in getSerializedCoords(width, height)]
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
				"to": getRouterID(x, y, width, height),
				"port": "local"
			}
		}
		noc[getSourceID(x, y, width, height)] = {
			"class": "source",
			"connections": cons
		}
	# add terminators
	for x in range(width):
		noc[getTerminatorID("tx", "top", x)] = {
			"class": "source",
			"packets": 0,
			"connections": {
				"0": {
					"to": getRouterID(x, height-1, width, height),
					"port": "top"
				}
			}
		}
		noc[getTerminatorID("tx", "bottom", x)] = {
			"class": "source",
			"packets": 0,
			"connections": {
				"0": {
					"to": getRouterID(x, 0, width, height),
					"port": "bottom"
				}
			}

		}
	for y in range(height):
		noc[getTerminatorID("tx", "left", y)] = {
			"class": "source",
			"packets": 0,
			"connections": {
				"0": {
					"to": getRouterID(0, y, width, height),
					"port": "left"
				}
			}

		}
		noc[getTerminatorID("tx", "right", y)] = {
			"class": "source",
			"packets": 0,
			"connections": {
				"0": {
					"to": getRouterID(width-1, y, width, height),
					"port": "right"
				}
			}

		}
	try:
		os.mkdir("gen2")
	except:
		pass
	with open("gen2/noc.json", "w") as fid:
		fid.write(json.dumps(noc, indent = 4, sort_keys = True))

def getIndex(x, y, width, height):
	return y * width + x

def getRoutingTableXY(rx, ry, width, height):
	table = {}
	for sx, sy in getSerializedCoords(width, height):
		sinkAddr = getIndex(sx, sy, width, height)
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
	return table

main()
