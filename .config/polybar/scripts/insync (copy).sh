#!/bin/bash

# Check if Insync is running
if pgrep -x "insync" > /dev/null; then
    icon="%{T2}%{F#00FF00}󰤉%{T-}"  # Green satellite icon when Insync is running
else
    icon="%{T2}%{F#FF0000}󰤉%{T-}"  # Red satellite icon when Insync is not running
fi

# Check if the module was clicked
if [[ $1 -eq 1 ]]; then
    # Action to open Insync
    insync &
fi

# Print the icon
echo "$icon"
