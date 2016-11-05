#!/bin/bash

mkdir -p {build,output}

OUT="build/a.out"

if [ ! -d "gen" ]; then
	echo "NoC not generated, running make first ..."
	make
fi

iverilog -I src -I gen -o $OUT src/testbench.v && vvp $OUT | ./beautify.py
