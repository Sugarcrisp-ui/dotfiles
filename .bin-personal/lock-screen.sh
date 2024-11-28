#!/bin/bash

# Check if we're on the laptop by using the hostname
if [ "$(hostname)" = "brett-k501ux" ]; then
    betterlockscreen -l && systemctl suspend
else
    betterlockscreen -l
fi
