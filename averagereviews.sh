#!/bin/bash

for filename in $1/*.dat; do
	name=$(echo $filename | cut -d/ -f2 | cut -d. -f1)	
	sum=0
	count=0
	for i in $(grep "<Overall>" $filename | sed "s/<Overall>//g"); do
		count=$(($count+1))
		i=`echo $i | tr -d $'\r'`
		sum=$((sum+i))
	done
	avg=`echo "scale=2; $sum/$count" | bc`
	echo "$name $avg"
done | sort -t" " -k2nr


