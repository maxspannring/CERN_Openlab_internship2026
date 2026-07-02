#! /bin/bash
filename="filelist.txt"
toBeRemoved="root://cms-xrd-global.cern.ch/"

while read file; do
	echo "${file#$toBeRemoved},"
done < $filename | sed '$s/,$//' | tr -d ' \n' # remove comma frm last line and  whitespaces and newlines 




