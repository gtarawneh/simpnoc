#!/bin/bash

OUT="build/a.out"

iverilog -I src -I traffic -o $OUT $1 && vvp $OUT