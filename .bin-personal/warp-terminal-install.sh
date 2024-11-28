#!/bin/bash

# Function to check if command was successful
check_success() {
    if [ $? -ne 0 ]; then
        echo "An error occurred during the last command. Please check your system and try again."
        exit 1
    fi
}

# Define paths
DOWNLOAD_DIR="$HOME/Downloads"
DOWNLOAD_URL="https://app.warp.dev/download?package=pacman"
PACKAGE_NAME="warp-terminal.pkg.tar.zst"

# Ensure Downloads directory exists
mkdir -p $DOWNLOAD_DIR

# Download the file
echo "Downloading Warp Terminal package to $DOWNLOAD_DIR..."
curl -L -o "$DOWNLOAD_DIR/$PACKAGE_NAME" "$DOWNLOAD_URL"
check_success

# Set the full path to the downloaded file
FULL_PATH="$DOWNLOAD_DIR/$PACKAGE_NAME"

# Add Warp's repository to pacman.conf if not already added
if ! grep -q "warpdotdev" /etc/pacman.conf; then
    echo "Adding Warp's repository to pacman.conf..."
    sudo sh -c "echo -e '\n[warpdotdev]\nServer = https://releases.warp.dev/linux/pacman/\$repo/\$arch' >> /etc/pacman.conf"
    check_success
fi

# Retrieve and sign the GPG key for Warp's repository (use keyserver if WKD fails)
echo "Attempting to retrieve and sign the GPG key..."
if ! sudo pacman-key -r "linux-maintainers@warp.dev"; then
    sudo pacman-key -r "linux-maintainers@warp.dev" --keyserver hkp://keys.openpgp.org:80
    check_success
fi
sudo pacman-key --lsign-key "linux-maintainers@warp.dev"
check_success

# Update the package database
echo "Updating package database..."
sudo pacman -Sy
check_success

# Install Warp Terminal from the downloaded package
echo "Installing Warp Terminal from $FULL_PATH..."
sudo pacman -U "$FULL_PATH"
check_success

# Clean up the temporary file (optional)
echo "Cleaning up..."
rm "$FULL_PATH"

echo "Installation of Warp Terminal completed successfully."
