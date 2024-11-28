#!/bin/bash

# Define the download directory
DOWNLOAD_DIR="/home/brett/Videos/youtube-videos/"

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null
then
    echo "yt-dlp could not be found. Installing now..."
    pip3 install --user yt-dlp || { echo "Failed to install yt-dlp"; exit 1; }
fi

# Ensure the download directory exists
mkdir -p "$DOWNLOAD_DIR"

# Prompt user for YouTube video URL
echo "Please enter the YouTube video URL:"
read VIDEO_URL

# Check if URL is provided
if [ -z "$VIDEO_URL" ]; then
    echo "No URL provided. Exiting."
    exit 1
fi

# Download the video
echo "Downloading video from $VIDEO_URL to $DOWNLOAD_DIR..."
yt-dlp -f bestvideo+bestaudio --merge-output-format mp4 -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" "$VIDEO_URL"

# Check if download was successful
if [ $? -eq 0 ]; then
    echo "Download completed successfully."
else
    echo "An error occurred during the download."
fi
