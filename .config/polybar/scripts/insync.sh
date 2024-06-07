#!/bin/bash

# Path to the red and green icons
RED_ICON="/home/brett/Pictures/insync-red.png"
GREEN_ICON="/home/brett/Pictures/insync-green.png"

# Check if InSync is running
if pgrep -x "insync" > /dev/null; then
    feh --bg-scale "$GREEN_ICON" # Set background to green icon
else
    feh --bg-scale "$RED_ICON" # Set background to red icon
fi
