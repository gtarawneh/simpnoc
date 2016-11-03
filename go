#!/bin/bash

mkdir -p {build,output}

OUT="build/a.out"

iverilog -I src -I traffic -o $OUT src/noc.v && vvp $OUT
