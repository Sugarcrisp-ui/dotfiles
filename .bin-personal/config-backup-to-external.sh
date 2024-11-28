#!/bin/bash

set -e

# Define common rsync options
RSYNC_OPTS="-avh -r --exclude=.cache --mkpath --delete"
DEST="/run/media/brett/backup"

# Backup .bin-personal directory
rsync $RSYNC_OPTS /home/brett/.bin-personal/ $DEST/.bin-personal

# Backup .config directories and files
for dir in \
    archlinux-betterlockscreen \
    dconf \
    paru \
    polybar \
    rofi \
    systemd \
    Thunar \
    variety/Fetched \
    xfce4
do
    rsync $RSYNC_OPTS /home/brett/.config/$dir/ $DEST/.config/$dir
done

for file in \
    i3/config \
    Code/User/settings.json \
    micro/settings.json \
    mimeapps.list \
    nano/nanorc \
    qBittorrent/qBittorrent.conf
do
    rsync $RSYNC_OPTS /home/brett/.config/$file $DEST/.config/$file
done

# Backup .vscode directory
rsync $RSYNC_OPTS /home/brett/.vscode/ $DEST/.vscode

# Backup .ssh directory
rsync $RSYNC_OPTS /home/brett/.ssh/ $DEST/.ssh

# Backup etc directories
rsync $RSYNC_OPTS /etc/sddm.conf.d/ $DEST/etc/sddm.conf.d

# Backup etc files
for file in \
    vconsole.conf \
    rc.local \
    mkinitcpio.conf
do
    rsync $RSYNC_OPTS /etc/$file $DEST/etc/$file
done

# Backup sddm themes directory
rsync $RSYNC_OPTS /usr/share/sddm/themes/arcolinux-sugar-candy/ $DEST/usr/share/sddm/themes/arcolinux-sugar-candy

# Sync the entire .local/share/applications directory
rsync $RSYNC_OPTS ~/.local/share/applications/ $DEST/.local/share/applications

# Error handling
if [ $? -ne 0 ]; then
    echo "An error occurred during the backup process."
    exit 1
fi

echo "Backup completed successfully."
