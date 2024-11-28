#!/bin/bash

# Prompt user for the directory path
echo "Please enter the path to the directory containing your MP4 files:"
read DIRECTORY

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist. Please check the path and try again."
    exit 1
fi

# Loop through all MP4 files in the directory
for file in "$DIRECTORY"/*.mp4; do
    # Extract filename without extension
    filename="${file%.*}"
    
    # Create a temporary file to store the normalized video
    temp_file="${filename}_temp.mp4"
    
    # Normalize audio using FFmpeg
    ffmpeg -i "$file" -af "volumedetect" -f null /dev/null
    
    # Extract the max volume detected
    max_volume=$(grep "max_volume: " ffmpeg.log | awk '{print $2}')
    
    # Calculate normalization factor (adjust this value based on your needs)
    normalization_factor=$(echo "1 - $max_volume" | bc)
    
    # Apply volume normalization
    ffmpeg -i "$file" -af "volume=$normalization_factor" -c:v copy "$temp_file"
    
    # Replace the original file with the normalized one
    mv "$temp_file" "$file"
done

echo "Volume normalization process completed for all MP4 files in the specified directory."
