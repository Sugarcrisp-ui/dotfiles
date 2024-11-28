#!/bin/bash

# Define common rsync options
# -r: recursive, -t: preserve times, -p: preserve permissions, -o: preserve owner, 
# -g: preserve group, -v: verbose, --progress: show progress during transfer,
# -s: protect args (not generally needed for this use case), --delete: delete extraneous files from dest dirs
RSYNC_OPTS="-rtpogv --progress --delete"

# Backup destination
DEST="/home/brett/i3wm/personal-settings/var/spool/cron"

# Backup cron files
rsync $RSYNC_OPTS /var/spool/cron/ $DEST/

# Change ownership of the backup directory to brett
chown -R brett:brett $DEST

# Check if the last command was successful
if [ $? -ne 0 ]; then
    echo "An error occurred during the backup process."
    exit 1
fi

echo "Backup of cron files completed successfully."
