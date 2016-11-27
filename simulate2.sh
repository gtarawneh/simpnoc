#!/bin/bash

mkdir -p {build,output}

OUT="build/a.out"

iverilog -I src -I src2 -o $OUT src2/rx_testbench.v && vvp $OUT | ./beautify.py