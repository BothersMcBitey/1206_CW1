#!/bin/bash

for filename in $1/*.dat; do
	name=$(echo $filename | cut -d/ -f2 | cut -d. -f1)	
	echo "$name $(grep Author $filename | wc -l)"
done | sort -t" " -k2nr

