#!/bin/bash

# Set the destination folder based on the first argument
DESTINATION="$1"

# Check if an argument was provided
[ -z "$DESTINATION" ] && { echo "No destination provided. Usage: $0 <destination>"; exit 1; }

# Create destination directory if it doesn't exist
mkdir -p "$DESTINATION"

# Backup the Documents folder to the specified destination
rsync -av /home/brett/Documents/ "$DESTINATION"
