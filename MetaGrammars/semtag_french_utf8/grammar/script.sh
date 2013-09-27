#!/bin/bash
for i in *.mg
do
   iconv -f LATIN1 -t utf8 "$i" > "$i"_
done
for i in *.mg
do 
	rm $i
done
for i in *.mg_
do
	X=`basename $i`
	mv $i $X.mg 
done
