#!/bin/python

import sys
import re
import json

# reg1 = r"(initiated|assembled|destroyed) packet <(0x[0-9a-f]+)>"
reg1 = r"#([ 0-9]+), .+ (initiated|assembled|destroyed) packet <(0x[0-9a-f]+)>"

def main():
	pat = re.compile(reg1)
	hist = {} # packet records
	while True:
		line = sys.stdin.readline()
		if line:
			for word in pat.findall(line):
				cycle = int(word[0])
				event = word[1] # initiated/assembled/destroyed
				key = word[2] # packet value (hex)
				# record = "%d:%s" % (cycle, event)
				record = [cycle, event]
				currentRecord = hist.get(key, [])
				currentRecord.append(record)
				hist[key] = currentRecord
		else:
			break
	packets = hist.values()
	count = lambda isFun : len([p for p in packets if isFun(p)])
	initiated = count(isInit)
	corrupt = count(isCorrupt)
	correct = count(isTranCorrect)
	dropped = initiated - correct - corrupt
	corruptPerc = 100.0 * corrupt / initiated
	droppedPerc = 100.0 * dropped / initiated
	meanHops,meanDeliveryTime = getPacketTransferStats(packets)
	print "Initiated Packets             : %d" % initiated
	print "Corrupt Packets               : %d (%1.1f%%)" % (corrupt, corruptPerc)
	print "Dropped Packets               : %d (%1.1f%%)" % (dropped, droppedPerc)
	print "Mean routers crossed / packet : %1.3f" % meanHops
	print "Mean delivery time (cycles)   : %1.1f" % meanDeliveryTime

def getPacketTransferStats(packets):
	hops = []
	dtimes = []
	for packet in packets:
		if isTranCorrect(packet):
			initTime = packet[0][0]
			destTime = packet[-1][0]
			hops.append(len(packet)-2)
			dtimes.append(destTime - initTime)
	n = float(len(hops))
	# meanHops is the mean # of routers crossed by the packet
	meanHops = sum(hops)/n
	meanDeliveryTime = sum(dtimes)/n
	return (meanHops, meanDeliveryTime)

def containEvent(packet, event):
	eventNames = [name for _, name in packet]
	return event in eventNames

def isInit(packet):
	return containEvent(packet, "initiated")

def isDest(packet):
	return containEvent(packet, "destroyed")

def isTranCorrect(packet):
	return isInit(packet) and isDest(packet)

def isCorrupt(packet):
	return (not isInit(packet)) and isDest(packet)

def isDropped(packet):
	return isInit(packet) and (not isDest(packet))

main()
