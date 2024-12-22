#!/bin/bash

# Hardcode the destination
DESTINATION="/run/media/brett/backup/daily-backup/Documents"

# Create destination directory if it doesn't exist
mkdir -p "$DESTINATION"

# Backup the Documents folder to the specified destination
rsync -av /home/brett/Documents/ "$DESTINATION"
