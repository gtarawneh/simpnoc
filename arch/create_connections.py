#!/bin/python

import sys

def main():
	args = sys.argv[1:]
	if not args:
		print('Usage: create_connections.py <file>')
		return
	file = args[0]
	with open(file, 'r') as fid:
		for line in fid:
			if not line or line[0] == '#':
				continue
			arr = line.rstrip().split(',')
			insType = arr[0]
			if insType == 'rr':
				data = {
					"r1" : arr[1],
					"r2" : arr[2],
					"p1" : arr[3],
					"p2" : arr[4],
				}
				print("assign rx_data[%(r2)s][%(p2)s] = tx_data[%(r1)s][%(p1)s];" % data);
				print("assign tx_busy[%(r1)s][%(p1)s] = rx_busy[%(r2)s][%(p2)s];" % data);
				print("");
			elif insType == 'sr':
				data = {
					"s" : arr[1],
					"r" : arr[2],
					"p" : arr[3],
				}
				print("assign rx_data[%(r)s][%(p)s] = source_data[%(s)s];" % data);
				print("assign source_busy[%(s)s] = rx_busy[%(r)s][%(p)s];" % data);
				print("");
			elif insType == 'rs':
				data = {
					"r" : arr[1],
					"p" : arr[2],
					"s" : arr[3],
				}
				print("assign sink_data[%(s)s] = tx_data[%(r)s][%(p)s];" % data);
				print("assign tx_busy[%(r)s][%(p)s] = sink_busy[%(s)s];" % data);
				print("");
			elif insType == 'tx':
				data = {
					"r" : arr[1],
					"p" : arr[2],
				}
				print("assign tx_busy[%(r)s][%(p)s] = 0;" % data);
			elif insType == 'rx':
				data = {
					"r" : arr[1],
					"p" : arr[2],
				}
				print("assign rx_data[%(r)s][%(p)s] = 0;" % data);
			else:
				raise Exception('** syntax error in file %s **', file)

main()
