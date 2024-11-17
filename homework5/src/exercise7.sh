#!/bin/bash

# checking if an argument has been passed
if [ -z "$1" ]; then
    echo "specify the filename as the argument."
    exit 1
fi

# checking if a file exists
if [ ! -f "$1" ]; then
    echo "file $1 not found."
    exit 1
fi

# Counting the number of lines in a file
line_count=$(wc -l < "$1")

# Output Number of Rows
echo "file $1 contains $line_count rows."
