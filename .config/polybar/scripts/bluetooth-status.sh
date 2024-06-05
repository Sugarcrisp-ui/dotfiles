#!/bin/bash

# Get Bluetooth status
bluetooth_status=$(rfkill list bluetooth | grep -oP '(?<=Soft blocked: )\w+')

# Format output based on Bluetooth status
if [[ $bluetooth_status == "yes" ]]; then
    echo ""  # Bluetooth icon when disabled
else
    echo ""  # Bluetooth icon when enabled
fi
