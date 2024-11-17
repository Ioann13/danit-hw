#!/bin/bash

# creating an array
fruits=("Apple" "Banana" "Orange" "Grapes" "Pineapple")

# printing each item
for fruit in "${fruits[@]}"; do
    echo $fruit
done
