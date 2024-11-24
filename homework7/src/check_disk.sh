#!/bin/bash

# percent
THRESHOLD=90

# we get a percentage
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')

# check the percentage
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    # inputt logfile
    echo "$(date): WARNING: Disk usage for / is at ${USAGE}%, which is above the threshold of ${THRESHOLD}%" >> /var/log/disk.log
fi
