#!/usr/bin/env python3
"""
This script downloads YouTube videos using yt-dlp.
"""

import os
import subprocess
import sys

# Define the download directory
DOWNLOAD_DIR = "/home/brett/Videos/youtube-videos/"

# Ensure the download directory exists
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

# Check if yt-dlp is installed
def check_yt_dlp():
    try:
        subprocess.run(["yt-dlp", "--version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    except FileNotFoundError:
        print("yt-dlp could not be found. Installing now...")
        try:
            subprocess.run(["pip3", "install", "--user", "yt-dlp"], check=True)
        except subprocess.CalledProcessError:
            print("Failed to install yt-dlp")
            sys.exit(1)

# Function to download the video
def download_video(video_url):
    try:
        result = subprocess.run([
            "yt-dlp",
            "-f", "bestvideo+bestaudio",
            "--merge-output-format", "mp4",
            "-o", os.path.join(DOWNLOAD_DIR, "%(title)s.%(ext)s"),
            video_url
        ], check=True, capture_output=True, text=True)
        print("Download completed successfully.")
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print("An error occurred during the download.")
        print(e.stderr)

# Main execution
if __name__ == "__main__":
    check_yt_dlp()
    
    # Prompt user for YouTube video URL
    video_url = input("Please enter the YouTube video URL: ").strip()
    
    # Check if URL is provided
    if not video_url:
        print("No URL provided. Exiting.")
        sys.exit(1)
    
    # Download the video
    print(f"Downloading video from {video_url} to {DOWNLOAD_DIR}...")
    download_video(video_url)