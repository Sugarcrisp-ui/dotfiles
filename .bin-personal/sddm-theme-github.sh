#!/bin/bash

# Define common rsync options
RSYNC_OPTS="-r -t -p -o -g -v --progress -s"
DESTINATION="/home/brett/Github/i3wm/arcolinux-sugar-candy"

# Directories

rsync $RSYNC_OPTS /usr/share/sddm/themes/arcolinux-sugar-candy/ $DESTINATION/ --delete
