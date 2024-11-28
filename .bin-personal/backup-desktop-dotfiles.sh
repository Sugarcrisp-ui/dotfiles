#!/bin/bash

DESTINATION="/run/media/brett/backup/dotfiles-desktop"

# Check if destination directory exists, if not create it
if [ ! -d "$DESTINATION" ]; then
    mkdir -p "$DESTINATION" || { echo "Failed to create directory: $DESTINATION"; exit 1; }
fi

# Check if the source directory exists
if [ ! -d "/home/brett/dotfiles" ]; then
    echo "Source directory /home/brett/dotfiles does not exist." >&2
    exit 1
fi

# Backup the dotfiles to the specified destination
rsync -av /home/brett/dotfiles/ "$DESTINATION" || { echo "Rsync failed to backup to $DESTINATION"; exit 1; }

# Log the successful completion of the backup
echo "$(date +"%Y-%m-%d %T") - Successfully backed up dotfiles to $DESTINATION" >> /path/to/your/backup.log
