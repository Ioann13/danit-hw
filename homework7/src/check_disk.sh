#!/bin/bash

# percent
THRESHOLD=${1:-90}

# we get a percentage
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# check the percentage
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    # inputt logfile
    echo "$(date): WARNING: Disk usage for / is at ${USAGE}%, which is above the threshold of ${THRESHOLD}%" >> /var/log/disk.log
fi
