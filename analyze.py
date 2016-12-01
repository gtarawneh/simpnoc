#!/bin/python

import sys
import re
import json

reg1 = r"(initiated|assembled|destroyed) packet <(0x[0-9a-f]+)>"

def main():
	pat = re.compile(reg1)
	hist = {} # packet records
	while True:
		line = sys.stdin.readline()
		if line:
			for word in pat.findall(line):
				event = word[0] # initiated/assembled/destroyed
				key = word[1] # packet value (hex)
				currentRecord = hist.get(key, [])
				currentRecord.append(event)
				hist[key] = currentRecord
		else:
			break
	packets = hist.values()
	count = lambda isFun : len([p for p in packets if isFun(p)])
	initiated = count(isInit)
	correct = count(isTranCorrect)
	percCorrect = 100.0*correct/initiated if correct else 0
	ghost = count(isGhost)
	if correct != initiated:
		print json.dumps(hist, indent=4)
	print "Initiated Packets     : %d" % initiated
	print "Transferred correctly : %d (%1.1f%%)" % (correct, percCorrect)
	print "Ghost Packets         : %d" % ghost

def isInit(packet):
	return ("initiated" in packet)

def isDest(packet):
	return ("destroyed" in packet)

def isTranCorrect(packet):
	return isInit(packet) and isDest(packet)

def isGhost(packet):
	return (not isInit(packet)) and isDest(packet)

main()
