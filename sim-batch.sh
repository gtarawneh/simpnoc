#!/bin/bash

DIR="sim"

mkdir -p $DIR

SEED=$1

SOURCE_RATE=$2

SINK_RATE=$3

SRC_PACKETS=$4

filename=$5

echo "./simulate2.sh $1 $2 $3 $4 > $DIR/$filename"

./simulate2.sh $1 $2 $3 $4 > $DIR/$filename
