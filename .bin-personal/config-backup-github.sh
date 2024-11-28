#!/bin/bash

set -e

# Define common rsync options
RSYNC_OPTS="-avh -r --exclude=.cache --mkpath --delete"

# Define backup destination
DEST="/home/brett/i3wm/personal-settings"

# Backup etc files, excluding sddm.conf.d and mkinitcpio.conf
for file in \
    vconsole.conf \
    rc.local
do
    rsync $RSYNC_OPTS /etc/$file $DEST/etc/$file
done

# Error handling
if [ $? -ne 0 ]; then
    echo "An error occurred during the backup process."
    exit 1
fi

echo "Backup completed successfully."
