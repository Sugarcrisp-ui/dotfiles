#!/bin/bash

while true; do
    if ! bluetoothctl show | grep -q "Powered: yes"; then
        /home/brett/.bin-personal/switch-to-hdmi.sh
    elif ! bluetoothctl info | grep -q "Device"; then
        /home/brett/.bin-personal/switch-to-hdmi.sh
    fi
    sleep 5
done
