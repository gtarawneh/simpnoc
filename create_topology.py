#!/bin/python

import json

def getRouterID(x, y):
	return "router_%d%d" % (y, x)

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

def main():
	noc = {}
	# noc parameters
	width = 2
	height = 2
	# add routers
	routers = [(x,y) for x in range(width) for y in range(height)]
	for x, y in routers:
		id = getRouterID(x,y)
		isBorderLeft = x == 0
		isBorderRight = x == width-1
		isBorderTop = y == 0
		isBorderBottom = y == height-1
		leftTerm = {"destination": getTerminatorID("rx", "left", y), "port": "0"}
		rightTerm = {"destination": getTerminatorID("rx", "right", y), "port": "0"}
		topTerm = {"destination": getTerminatorID("rx", "top", x), "port": "0"}
		bottomTerm = {"destination": getTerminatorID("rx", "bottom", x), "port": "0"}
		localTerm = {"destination": getSinkID(x, y), "port": "0"}
		rightRouter = {"destination": getRouterID(x+1, y), "port": "left"}
		leftRouter = {"destination": getRouterID(x-1, y), "port": "right"}
		topRouter = {"destination": getRouterID(x, y-1), "port": "bottom"}
		bottomRouter = {"destination": getRouterID(x, y+1), "port": "top"}
		cons = {
			"right": rightTerm if isBorderRight else rightRouter,
			"left": leftTerm if isBorderLeft else leftRouter,
			"top": topTerm if isBorderTop else topRouter,
			"bottom": bottomTerm if isBorderBottom else bottomRouter,
			"local": localTerm
		}
		noc[id] = {
			"class": "router",
			"connections": cons,
			"table": {
				"0" : "right",
				"default": "local"
			}
		}
	# add local sinks
	sinks = [(x,y) for x in range(width) for y in range(height)]
	for x, y in sinks:
		noc[getSinkID(x, y)] = {"class": "sink"}
	# add local sources
	sources = [(x,y) for x in range(width) for y in range(height)]
	for x, y, in sources:
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
		noc[getTerminatorID("rx", "top", x)] = {"class": "sink"}
		noc[getTerminatorID("tx", "bottom", x)] = {"class": "source", "flits": 0}
		noc[getTerminatorID("rx", "bottom", x)] = {"class": "sink"}
	# add terminators (left & right)
	for y in range(height):
		noc[getTerminatorID("tx", "left", y)] = {"class": "source", "flits": 0}
		noc[getTerminatorID("rx", "left", y)] = {"class": "sink"}
		noc[getTerminatorID("tx", "right", y)] = {"class": "source", "flits": 0}
		noc[getTerminatorID("rx", "right", y)] = {"class": "sink"}
	with open("gen/noc.json", "w") as fid:
		fid.write(json.dumps(noc, indent = 4, sort_keys = True))

main()
