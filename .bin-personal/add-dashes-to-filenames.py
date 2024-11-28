#!/usr/bin/env python3
"""
This script will replace spaces in filenames with '-'.
"""

import os

# Iterate over all files and directories in the current directory
for filename in os.listdir('.'):
    # Check if the filename contains a space
    if ' ' in filename:
        # Replace spaces with hyphens
        new_filename = filename.replace(' ', '-')
        # Construct the full path for the source and destination
        src = os.path.join('.', filename)
        dst = os.path.join('.', new_filename)
        
        # Rename the file or directory
        try:
            os.rename(src, dst)
            print(f"Renamed: {filename} -> {new_filename}")
        except OSError as e:
            print(f"Error renaming {filename} to {new_filename}: {e}")