#!/bin/bash

# Check for available updates
updates=$(apt list --upgradable 2>/dev/null | grep -c ^)

# Check if updates are available
if [ "$updates" -gt 1 ]; then
  echo "%{F#ff0000}%{F-}"  # Red update icon
else
  echo "%{F#00ff00}%{F-}"  # Green check icon
fi
