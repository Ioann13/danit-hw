#!/bin/bash

echo -n "Enter the filename tocheck:  "; read filename

if [ -e "$filename" ]; then

    echo "The file $filename exists"
else
    echo "the file $filename does not exists"
fi
