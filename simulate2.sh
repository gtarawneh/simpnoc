#!/bin/bash

mkdir -p {build,output}

DIR="build/"

SEED=${1:-2}

SOURCE_RATE=${2:-65535}

SINK_RATE=${3:-1024}

SRC_PACKETS=${4:-20}

RFILE=bin-"$SEED"-"$SOURCE_RATE"-"$SINK_RATE"-"$SRC_PACKETS".out

OUT="$DIR/$RFILE"

iverilog \
	-DSEED=$SEED \
	-DSOURCE_RATE=$SOURCE_RATE \
	-DSINK_RATE=$SINK_RATE \
	-DSRC_PACKETS=$SRC_PACKETS \
	-I common \
	-I src2 \
	-I gen2 \
	-o $OUT src2/testbench.v \
	&& vvp $OUT \
	&& rm -f $OUT
