#!/bin/bash

# sentence input request
echo "Enter a sentence:"
read sentence

# flipping the sentence
reversed=$(echo $sentence | awk '{for(i=NF;i>0;i--) printf $i" "; print ""}')

# displaying the result
echo $reversed
