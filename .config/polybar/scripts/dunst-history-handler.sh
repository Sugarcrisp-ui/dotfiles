#!/bin/bash

# Define the output file
OUTPUT_FILE="$HOME/notification_history.txt"

# Run the dunst-history.sh script
~/.config/polybar/scripts/dunst-history.sh

# Check if the output file exists and open it
if [ -f "$OUTPUT_FILE" ]; then
    xdg-open "$OUTPUT_FILE"
else
    echo "Error: $OUTPUT_FILE not found."
fi
