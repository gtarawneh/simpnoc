#!/bin/python

import os
import sys
import time
import subprocess

def runProcess(p, wait = False):
	FNULL = open(os.devnull, 'w')
	if wait:
		subprocess.call(p, stderr = subprocess.STDOUT)
	else:
		obj = subprocess.Popen(p, stderr = subprocess.STDOUT)
		return obj

def main():
	rates = [117, 207, 369, 655, 1165, 2072, 3685, 6554, 11654, 20724, 36854, 65536]
	sinkRate = 1024;
	sourcePackets = 20;
	for sourceRate in rates:
		objs = []
		for seed in range(2):
			filename = "injection%05d_seed%d" % (sourceRate, seed)
			obj = runProcess([
				"./sim-batch.sh",
				str(seed),
				str(sourceRate),
				str(sinkRate),
				str(sourcePackets),
				filename
			])
			objs.append(obj)
		while None in [x.poll() for x in objs]:
			time.sleep(1)

main()
