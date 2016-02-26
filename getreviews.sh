#!/bin/bash

count=$((0))

filename=$1
name2="$(echo $1 | sed "s/.*\///" | sed "s/\..*//")Scores"
values=""
for i in $(grep "<Overall>" $filename | sed "s/<Overall>//g"); do
	i=`echo $i | tr -d $'\r'`
	values="$values$i,"
done
echo $values >> $name2.txt
