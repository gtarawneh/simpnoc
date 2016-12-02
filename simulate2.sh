#!/bin/bash

mkdir -p {build,output}

OUT="build/a.out"

iverilog -I common -I src2 -I gen2 -o $OUT src2/testbench.v && vvp $OUT
