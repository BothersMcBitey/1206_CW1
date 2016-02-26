#!/bin/bash

argnum=$((0))
for arg in "$@"; do
	
	argnum=$(($argnum+1))

	#get scores for that hotel and mean
	count[$argnum]=$((0))
	mean[$argnum]=$((0))
	for i in $(grep "<Overall>" $arg | sed "s/[^0-9]*//g"); do
		count[$argnum]=$((${count[$argnum]}+1))
		scores[${count[argnum]}]=$(echo $i)
		mean[$argnum]=$((${mean[$argnum]} + ${scores[${count[$argnum]}]}))
	done
	mean[$argnum]=`echo "scale=20; ${mean[$argnum]}/${count[$argnum]}" | bc`

	
	#get variance
	sigma=$((0))
	for i in "${scores[@]}"; do
		sigma=`echo "scale=20; $sigma+($i-${mean[$argnum]})^2" | bc`
	done

	var[$argnum]=`echo "scale=20; (1/(${count[$argnum]}-1))*$sigma" | bc`	
done

#Calculate t-stat
sx1x2=`echo "scale=20; sqrt(((${count[1]}-1)*${var[1]} + (${count[2]}-1)*${var[2]}) / (${count[1]}+${count[2]}-2))" | bc`
t=`echo "scale=20; (${mean[1]}-${mean[2]}) / ($sx1x2*sqrt((1/${count[1]})+(1/${count[2]})))" | bc`

#print all the stuff
echo "t: $(printf %.2f $t)"
sd1=$(echo "scale=2; sqrt(${var[1]})" | bc)
sd2=$(echo "scale=2; sqrt(${var[2]})" | bc)
echo "Mean $(echo $1 | cut -d/ -f2 | sed 's/\..*//'): $(printf %.2f ${mean[1]}), SD: $(printf %.2f $sd1)"
echo "Mean $(echo $2 | cut -d/ -f2 | sed 's/\..*//'): $(printf %.2f ${mean[2]}), SD: $(printf %.2f $sd2)"

critvalue=1.972731033408872

#bash only does int arithmetic, so multiply the t-value and
#crit value by big number to allow meaningful comparison
t=`echo "scale=0; $t*1000000000" | bc`
t=${t%.*}
critvalue=`echo "scale=0; $critvalue*1000000000" | bc`
critvalue=${critvalue%.*}
negcritvalue=$(($critvalue*-1))

#if inside critical range, return 1
if [ $t -gt $critvalue ] || [ $t -lt $negcritvalue ] 
then
	sig=$((1))
else 
	sig=$((0))
fi

echo $sig
