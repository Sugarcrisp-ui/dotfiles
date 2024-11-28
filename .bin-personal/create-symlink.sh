#!/bin/bash

# Prompt for the source file or directory
read -e -p "Enter the source file or directory: " source

# Expand the tilde (~) if used in the path
source=$(eval echo "$source")

# Check if the source exists
if [[ ! -e $source ]]; then
  echo "Error: Source '$source' does not exist."
  exit 1
fi

# Prompt for the destination of the symlink
read -e -p "Enter the destination for the symlink: " destination

# Expand the tilde (~) if used in the destination
destination=$(eval echo "$destination")

# Create the symbolic link
ln -s "$source" "$destination" && echo "Symlink created: $destination -> $source"
