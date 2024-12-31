#!/bin/bash

# Define common rsync options
RSYNC_OPTS="-avz --delete"
DESTINATION="/personal/"

# Backup .bin-personal directory
rsync $RSYNC_OPTS /home/brett/.bin-personal/ $DESTINATION/.bin-personal

# Backup .config directories and files
for dir in \
    arcolinux-welcome-app \
    archlinux-betterlockscreen \
    dconf \
    i3 \
    polybar \
    systemd \
    Thunar \
    variety/Fetched \
    xfce4
do
    rsync $RSYNC_OPTS /home/brett/.config/$dir/ $DESTINATION/.config/$dir
done

# Backup .local directories
rsync $RSYNC_OPTS /home/brett/.local/share/applications/ $DESTINATION/.local/share/applications

# Backup .config files
rsync $RSYNC_OPTS /home/brett/.config/variety/variety.conf $DESTINATION/.config/variety/variety.conf
rsync $RSYNC_OPTS /home/brett/.config/mimeapps.list $DESTINATION/.config/mimeapps.list

# Error handling
if [ $? -ne 0 ]; then
    echo "An error occurred during the backup process."
    exit 1
fi

echo "Backup completed successfully."
