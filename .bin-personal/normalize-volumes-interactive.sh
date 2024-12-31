#!/bin/bash

# Color definitions
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

clear
echo "${BLUE}################################################################"
echo "                  Volume Normalization for MP4 Files"
echo "################################################################${RESET}"
echo

# Prompt for directory (using simplified read -e)
read -e -p "${CYAN}Enter the path to the directory containing your MP4 files: ${RESET}" DIRECTORY
# Safer tilde expansion
DIRECTORY="${DIRECTORY/#~/$HOME}"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "${RED}Error: Directory '$DIRECTORY' does not exist. Please check the path.${RESET}"
    exit 1
fi

# Confirmation before normalization
read -p "${YELLOW}Normalize volume for all MP4 files in '$DIRECTORY'? [Y/n]: ${RESET}" -n 1 -r
echo # Move to a new line
if [[ ! "$REPLY" =~ ^[Yy]$ && -n "$REPLY" ]]; then
    echo "Volume normalization cancelled."
    exit 0
fi

# Loop through all MP4 files in the directory
for file in "$DIRECTORY"/*.mp4; do
    filename="${file%.*}"
    temp_file="${filename}_temp.mp4"
    
    # Normalize audio using FFmpeg
    ffmpeg -i "$file" -af "volumedetect" -f null /dev/null 2> ffmpeg.log
    
    # Extract the max volume detected
    max_volume=$(grep "max_volume: " ffmpeg.log | awk '{print $2}' 2>/dev/null)
    
    # Calculate normalization factor (adjust this value based on your needs)
    if [[ -n "$max_volume" ]]; then
        normalization_factor=$(echo "1 - $max_volume" | bc)
        # Apply volume normalization
        if ffmpeg -i "$file" -af "volume=$normalization_factor" -c:v copy "$temp_file"; then
            mv "$temp_file" "$file"
            echo "${GREEN}Normalized: $file${RESET}"
        else
            echo "${RED}Failed to normalize: $file${RESET}"
        fi
    else
        echo "${RED}Could not detect volume for: $file${RESET}"
    fi
done

echo "${GREEN}Volume normalization process completed for all MP4 files in '$DIRECTORY'.${RESET}"
