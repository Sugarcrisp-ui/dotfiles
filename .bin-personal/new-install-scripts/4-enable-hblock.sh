#!/bin/bash

# This script will automate the setup of hblock on an Arch Linux system

# Run hblock with default settings to update /etc/hosts
sudo hblock

# Check if hblock ran successfully
if [ $? -eq 0 ]; then
    echo "hblock has successfully updated the hosts file."
else
    echo "There was an error running hblock. Please check the command output for details."
fi
