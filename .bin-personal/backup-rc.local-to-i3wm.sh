#!/bin/bash

# Directory where we want to save the backup
BACKUP_DIR="$HOME/i3wm/personal-settings/etc"

# Create the backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Copy rc.local to the backup directory
cp /etc/rc.local "$BACKUP_DIR/rc.local"

# Verify if the copy was successful
if [ $? -eq 0 ]; then
    echo "Backup of rc.local completed successfully."
else
    echo "Backup failed. Please check if you have the necessary permissions."
fi
