#!/bin/bash

# Drive and mount point details
EXTERNAL_DRIVE="/dev/sdc1"
UUID="8e7807ea-b45b-4cfe-a767-727994c3d5cd"
MOUNT_POINT="/run/media/brett/backup"

# Keyfile details
KEYFILE="/etc/luks_keyfile"
KEYFILE_SIZE=4096  # Size in bytes, adjust if needed

# Create keyfile
echo "Generating keyfile..."
dd if=/dev/urandom of="$KEYFILE" bs=1 count=$KEYFILE_SIZE
chmod 400 "$KEYFILE"  # Make the keyfile read-only for security

# Add the keyfile to LUKS - this will prompt for the existing password
echo "Adding keyfile to LUKS. Please enter your existing LUKS password when prompted..."
sudo cryptsetup luksAddKey "$EXTERNAL_DRIVE" "$KEYFILE"

# Check if adding was successful
if [ $? -ne 0 ]; then
    echo "Failed to add keyfile to LUKS. Exiting."
    exit 1
fi

# Rest of the script as before...

# Create the mount point if it doesn't exist
sudo mkdir -p "$MOUNT_POINT"

# Open the LUKS encrypted partition using the keyfile
sudo cryptsetup luksOpen "$EXTERNAL_DRIVE" backup_crypt --key-file "$KEYFILE"

# Check if opening was successful
if [ $? -ne 0 ]; then
    echo "Failed to open the encrypted partition."
    exit 1
fi

# Determine the mapper name (usually /dev/mapper/backup_crypt)
MAPPER_NAME="/dev/mapper/backup_crypt"

# Mount the encrypted partition
sudo mount "$MAPPER_NAME" "$MOUNT_POINT"

# Check if mounting was successful
if [ $? -eq 0 ]; then
    echo "Encrypted drive mounted successfully at $MOUNT_POINT."
else
    echo "Failed to mount the encrypted drive."
    # Close the mapper device if mount fails
    sudo cryptsetup luksClose backup_crypt
    exit 1
fi

# Add entry to /etc/fstab for automatic mounting on reboot
echo "UUID=$UUID none $MAPPER_NAME auto,noauto,x-systemd.automount,x-systemd.device-timeout=10,x-systemd.mount-timeout=10,errors=remount-ro 0 2" | sudo tee -a /etc/fstab

# Add entry to /etc/crypttab for automatic unlocking with keyfile
echo "backup_crypt UUID=$UUID $KEYFILE luks" | sudo tee -a /etc/crypttab

echo "Configuration for auto-mounting complete. Please reboot to test if the drive mounts automatically."
