#!/bin/bash

# Exit on any error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo (e.g., sudo bash $0)"
    exit 1
fi

# Update package list
echo "Updating package list..."
apt update

# Remove RealVNC
echo "Removing RealVNC..."
apt remove -y realvnc-vnc-server realvnc-vnc-viewer || echo "RealVNC not found, skipping."
apt autoremove -y

# Install x11vnc
echo "Installing x11vnc..."
apt install -y x11vnc

# Set x11vnc password
echo "Setting x11vnc password..."
echo "Enter your desired VNC password when prompted:"
sudo -u $SUDO_USER x11vnc -storepasswd

# Create systemd user service directory
echo "Creating systemd user service..."
sudo -u $SUDO_USER mkdir -p /home/$SUDO_USER/.config/systemd/user

# Write x11vnc service file
cat << EOF > /home/$SUDO_USER/.config/systemd/user/x11vnc.service
[Unit]
Description=x11vnc Server for Shadowing Desktop
After=graphical.target

[Service]
ExecStart=/usr/bin/x11vnc -display :0 -usepw -forever
Restart=on-failure
Environment="DISPLAY=:0"

[Install]
WantedBy=default.target
EOF

# Set ownership and permissions
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/systemd/user/x11vnc.service
chmod 644 /home/$SUDO_USER/.config/systemd/user/x11vnc.service

# Enable and start the service
echo "Enabling and starting x11vnc service..."
sudo -u $SUDO_USER systemctl --user enable x11vnc.service
sudo -u $SUDO_USER systemctl --user start x11vnc.service

# Open firewall port
echo "Configuring firewall..."
ufw allow 5900

# Get and display IP address
echo "Finding your IP address..."
LOCAL_IP=$(ip addr show | grep -oP 'inet \K[\d.]+(?=/)' | grep -v '127.0.0.1' | head -n 1)
PUBLIC_IP=$(curl -s ifconfig.me || echo "Could not fetch public IP")
echo "x11vnc is now running! Test it with Remmina:"
echo "Local IP (if on same network): $LOCAL_IP:0"
echo "Public IP (for remote access, requires port forwarding): $PUBLIC_IP:5900"
echo "Password: The one you just set"
echo "After testing, you can remove TeamViewer with:"
echo "  sudo apt remove teamviewer"
echo "  sudo apt autoremove"
