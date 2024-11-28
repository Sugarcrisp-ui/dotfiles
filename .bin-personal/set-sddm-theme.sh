#!/bin/bash

# Combined script to copy background images, update SDDM theme configuration, and set the theme

# Source and destination for background images
SOURCE_BACKGROUND="/run/media/brett/backup/usr/share/sddm/themes/arcolinux-sugar-candy/images/"
DEST_BACKGROUND="/usr/share/sddm/themes/arcolinux-sugar-candy/images/"

# Ensure the destination directory exists
sudo mkdir -p "$DEST_BACKGROUND"

# Copy backgrounds from external drive to system
sudo cp -r "$SOURCE_BACKGROUND"/* "$DEST_BACKGROUND"

# Check if copy was successful
if [ $? -eq 0 ]; then
    echo "Background images copied successfully."
else
    echo "Failed to copy background images."
    exit 1
fi

# Path to the theme configuration file
THEME_CONF="/usr/share/sddm/themes/arcolinux-sugar-candy/theme.conf"

# Ensure the theme.conf exists
if [ ! -f "$THEME_CONF" ]; then
    echo "Theme configuration file does not exist at $THEME_CONF."
    exit 1
fi

# Update the background path in theme.conf
sudo sed -i 's|^background=.*|background=/usr/share/sddm/themes/arcolinux-sugar-candy/Backgrounds/arco-login-plasma.jpg|' "$THEME_CONF"

# Check if update was successful
if [ $? -eq 0 ]; then
    echo "Theme configuration file updated successfully."
else
    echo "Failed to update theme configuration file."
    exit 1
fi

# Define the path to the SDDM configuration file
SDDM_CONFIG="/etc/sddm.conf"

# Check if the configuration file exists
if [ ! -f "$SDDM_CONFIG" ]; then
    echo "SDDM configuration file does not exist at $SDDM_CONFIG. Creating a new one."
    sudo touch "$SDDM_CONFIG"
fi

# Use sed to update or add the Current theme line
sudo sed -i '/^Current=/c\Current=arcolinux-sugar-candy' "$SDDM_CONFIG"

# Add the line if it doesn't exist
if ! grep -q "^Current=" "$SDDM_CONFIG"; then
    echo "Current=arcolinux-sugar-candy" | sudo tee -a "$SDDM_CONFIG"
fi

# Ensure SDDM service is enabled (if not already)
sudo systemctl enable sddm.service

echo "SDDM theme setup and configuration completed. Reboot for changes to take effect."
