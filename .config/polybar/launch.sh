#!/bin/bash

# Terminate already running bar instances 
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Get the static hostname
HOSTNAME=$(hostnamectl --static)

# Loop through monitors
for m in $(xrandr --query | grep "connected" | cut -d" " -f1); do

  # Check hostname and launch appropriate bar 
  if [ "$HOSTNAME" == "brett-ms7d82" ]; then

    # Launch desktop bar with config file and --reload
    MONITOR=$m polybar --reload mainbar-i3-desktop -c ~/.config/polybar/config.ini

  elif [ "$HOSTNAME" == "brett-k501ux" ]; then

    # Launch laptop bar with config file and --reload 
    MONITOR=$m polybar --reload mainbar-i3-laptop -c ~/.config/polybar/config.ini

  elif [ "$HOSTNAME" == "archlinux" ]; then

    # Launch VM-specific bar with config file and --reload
    MONITOR=$m polybar --reload mainbar-i3-vm -c ~/.config/polybar/config.ini

  else
    echo "Unknown hostname: $HOSTNAME"
  fi

done
