#!/bin/bash

# Lock the screen
betterlockscreen -l &

# Wait for a moment to ensure the lock has taken effect
sleep 2

# Suspend the system
systemctl suspend
