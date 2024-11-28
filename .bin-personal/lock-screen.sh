#!/bin/bash

# Check if we're on the laptop by using the hostname
if [ "$(hostname)" = "brett-k501ux" ]; then
    # Lock the screen
    betterlockscreen -l &
    
    # Wait for a moment to ensure the lock has taken effect
    # Adjust the sleep time if necessary
    sleep 5
    
    # Suspend the system
    systemctl suspend
else
    betterlockscreen -l
fi
