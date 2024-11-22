#!/bin/bash

# Generate a random number from 1 to 100
random_number=$((RANDOM % 100 + 1))

# Attempt Counter
attempts=0
max_attempts=5

echo "I guessed a number from 1 to 100. Try to guess!"

# Main Loop of the Game
while [ $attempts -lt $max_attempts ]; do
    # Increasing the Attempt Count
    attempts=$((attempts + 1))
    
    # Ask the user for a number
    read -p "Trying $attempts: Enter your number:" guess
    
    # Check if the entered value is a number
    if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
        echo "Please enter a valid number."
        attempts=$((attempts - 1))
        continue
    fi

    # Checking assumptions
    if [ "$guess" -eq "$random_number" ]; then
        echo "Welcome! You've guessed the correct number."
        exit 0
    elif [ "$guess" -lt "$random_number" ]; then
        echo "Too low!"
    else
        echo "Too high!"
    fi
done

# If you didn't guess right in 5 attempts
echo "Sorry, you've run out of attempts. The correct number was $random_number."
exit 1
