#!/bin/bash

# whether the argument was passed
if [ -z "$1" ]; then
    echo "specify a file name."
    exit 1
fi

# checking if a file exists
if [ -f "$1" ]; then
    echo "The $1 file exists. Its content:"
    cat "$1"  
else
    echo "Error: The $1 file does not exist."
    exit 1
fi
