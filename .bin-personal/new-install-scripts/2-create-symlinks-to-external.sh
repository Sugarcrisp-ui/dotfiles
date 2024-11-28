#!/bin/bash

# Define the source directory on the external drive
source_dir="/run/media/brett/backup"

# Define the destination directory (home)
dest_dir="$HOME"

# List of directories and files to symlink
directories_to_symlink=(
    ".bin-personal"
    ".config"
    ".fonts"
    ".local"
    ".ssh"
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Trading"
    "usr"
    "Videos"
    ".bashrc-personal"
    ".fehbg"
)

# Loop through each directory/file
for dir in "${directories_to_symlink[@]}"; do
    # Full path to the source
    src_path="${source_dir}/${dir}"
    
    # Full path to where the symlink should be in the home directory
    dest_path="${dest_dir}/${dir}"
    
    # Ensure the parent directories exist in $HOME if the item isn't in the root of the home directory
    if [[ "$dir" != .* ]]; then
        mkdir -p "$(dirname "$dest_path")"
    fi
    
    # Remove existing file/folder if it's not a symlink or if it's a broken symlink
    if [ -e "$dest_path" ] && [ ! -L "$dest_path" ]; || [ -L "$dest_path" ] && ! [ -e "$dest_path" ]; then
        rm -rf "$dest_path"
    fi
    
    # Create the symlink
    ln -s "$src_path" "$dest_path"
    
    echo "Symlink created: $dest_path -> $src_path"
done

echo "All symlinks have been created."
