#!/bin/bash

# The path to the directory
WATCH_DIR="/home/ivan/Downloads"


while true; do
    # Checking for new files
    for FILE in "$WATCH_DIR"/*; do
        if [ -f "$FILE" ] && [[ "$FILE" != *.back ]]; then
            echo "[$(date)] New file: $(basename "$FILE")"
            
            # Print the contents of the file
            cat "$FILE"
            
            # Rename the file to *.back format
            mv "$FILE" "$FILE.back"
            echo "[$(date)] renam te file to *.back formats $(basename "$FILE").back"
        fi
     done

    sleep 2
done
