#!/bin/bash

FILE="results.txt"

rm -f $FILE

for f in sim/*; do

	result=`cat $f | ./analyze.py | grep delivery`

	echo "$f : $result" | awk '{print (substr($0,14,5) ", " substr($0,24,1)", " substr($0,60,5) )}' >> $FILE

done
