#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Add a small delay
sleep 1

# Specify the monitor
MONITOR=HDMI-1

# Launch Polybar on the specified monitor
polybar --reload mainbar-i3-desktop -c ~/.config/polybar/config.ini &

# Restart nm-tray if it's running
#pkill -USR1 -x nm-tray

# Optional: Check if nm-tray is not running, then start it
#if ! pgrep -x nm-tray > /dev/null; then
#    nm-tray &
#fi
