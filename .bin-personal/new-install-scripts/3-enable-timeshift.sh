#!/bin/bash

# Timeshift setup automation script for both ext4 and btrfs setups

# Find where Timeshift stores its configuration
CONFIG_FILE="/etc/timeshift/timeshift.json"

# Check if Timeshift is installed
if ! command -v timeshift &> /dev/null; then
    echo "Timeshift is not installed. Please install it first."
    exit 1
fi

# Detect filesystem type
ROOT_FS=$(df -T / | awk 'END{print $2}')

# Set backup type based on filesystem
if [[ "$ROOT_FS" == "btrfs" ]]; then
    BACKUP_TYPE="btrfs"
else
    BACKUP_TYPE="rsync"
fi

# Function to set up Timeshift
setup_timeshift() {
    # Run Timeshift with sudo to elevate privileges
    sudo timeshift --backup-device "/dev/sdX1" --backup-type $BACKUP_TYPE --schedule-daily 5 --schedule-weekly 2 --create

    # Check if setup was successful
    if [ $? -eq 0 ]; then
        echo "Timeshift setup completed successfully for $BACKUP_TYPE."
    else
        echo "Failed to setup Timeshift for $BACKUP_TYPE. Please check the configuration manually."
    fi
}

# Run the setup function
setup_timeshift
