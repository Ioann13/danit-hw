#!/bin/bash
#assigning arguments to variables
OUTPUT=/home/ivan/danit-hw/homework5/test.txt
INPUT=/home/ivan/danit-hw

#checking if the source file exists
if [ -f "$OUTPUT" ]

#copying a file
then
     cp "$OUTPUT" "$INPUT"
     echo "copying successful"
else
     echo "copying error"

fi
