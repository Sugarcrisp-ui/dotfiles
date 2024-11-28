#!/bin/bash

# Wait for network to be available
while ! ping -c1 google.com &>/dev/null; do
    echo "Waiting for network..."
    sleep 5
done

# Start ProtonVPN GUI
flatpak run com.protonvpn.www &

# Wait for GUI to initialize
sleep 15

# Check VPN status and connect if necessary
STATUS=$(flatpak run com.protonvpn.www --status | grep "Connected")

if [ -z "$STATUS" ]; then
    # Connect using the fastest server
    echo "Attempting to connect..."
    flatpak run com.protonvpn.www --fastest
else
    echo "Already connected."
fi
