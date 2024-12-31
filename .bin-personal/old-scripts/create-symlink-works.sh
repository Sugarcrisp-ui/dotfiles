#!/bin/bash

# Color definitions
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Clear screen and show header
clear
echo "${BLUE}################################################################"
echo "                    Symbolic Link Creator"
echo "################################################################${RESET}"
echo

# Function to bind tab for proper completion
bind 'TAB: complete' 2>/dev/null

# Function to read input with proper completion
read_with_completion() {
    local prompt="$1"
    local var_name="$2"

    # Use readline to get input with completion
    READLINE_LINE=""
    READLINE_POINT=0
    while true; do
        read -e -p "$prompt" input
        eval "$var_name=\"$input\""
        return 0
    done
}

# Source entry reminders
echo "${YELLOW}Source Reminders:"
echo "1. For source directories, do NOT add a trailing slash (/)"
echo "2. Paths can be absolute or relative ${RESET}"
echo

# Prompt for the source file or directory
read_with_completion "${CYAN}Enter the source file or directory: ${RESET}" source

# Expand the tilde (~) if used in the path safely
source="${source/#~/$HOME}"

# Check if the source exists
if [[ ! -e "$source" ]]; then
    echo "${RED}Error: Source '$source' does not exist. Please check the path.${RESET}"
    exit 1
fi

# Show the type of source selected
if [[ -d "$source" ]]; then
    echo "${GREEN}Selected source is a directory${RESET}"
else
    echo "${GREEN}Selected source is a file${RESET}"
fi

echo

# Destination entry reminders
echo "${YELLOW}Destination Reminders:"
echo "1. Specify the directory where the symlink will be created"
echo "2. Paths can be absolute or relative"
echo "3. Do NOT add a trailing slash (/), but you can use (~) for the home directory"
echo "4. Example: Directory: ~/.config ${RESET}"
echo

# Prompt for the destination directory
read_with_completion "${CYAN}Enter the directory for the symlink: ${RESET}" dest_dir

# Expand tilde for dest_dir safely
dest_dir="${dest_dir/#~/$HOME}"
dest_dir="${dest_dir%/}"

# Determine symlink name
default_symlink_name=$(basename "$source")
echo
read -p "${CYAN}Use default symlink name '$default_symlink_name'? [Y/n]: ${RESET}" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    symlink_name="$default_symlink_name"
else
    read_with_completion "${CYAN}Enter the name for the symlink: ${RESET}" symlink_name
fi

destination="$dest_dir/$symlink_name"

# Check if destination directory exists *and* is a directory
if [[ ! -d "$dest_dir" ]]; then
    if ! mkdir -p "$dest_dir"; then
        echo "${RED}Failed to create directory '$dest_dir'.${RESET}"
        exit 1
    else
        echo "${YELLOW}Creating parent directory: $dest_dir${RESET}"
    fi
# Check if destination already exists (improved)
elif [[ -e "$destination" ]]; then
    if [[ -f "$destination" ]]; then
        echo "${RED}Error: A file already exists at '$destination'.${RESET}"
    else
        echo "${RED}Error: A directory already exists at '$destination'.${RESET}"
    fi
    exit 1
# Check if destination is a file (accidental selection)
elif [[ -f "$dest_dir" ]]; then
    echo "${RED}Error: Destination '$dest_dir' is a file, not a directory.${RESET}"
    exit 1
fi

# Check if symlink already exists at destination or if it would create a loop
current_dir=$(pwd)
cd "$dest_dir" || exit 1
if [[ -L "$symlink_name" ]]; then
    echo "${RED}Error: A symlink named '$symlink_name' already exists at '$dest_dir'. Operation cancelled.${RESET}"
    cd "$current_dir" || exit 1
    exit 1
elif [[ "$(readlink -f "$source")" == "$PWD/$symlink_name" ]]; then
    echo "${RED}Error: This would create an infinite symlink loop. Operation cancelled.${RESET}"
    cd "$current_dir" || exit 1
    exit 1
else
    cd "$current_dir" || exit 1
fi

# Confirmation before creation
read -p "${YELLOW}Create symlink '$destination' pointing to '$source'? [Y/n]: ${RESET}" -n 1 -r
echo    # (new line)
if [[ ! "$REPLY" =~ ^[Yy]$ && -n "$REPLY" ]]; then
    echo "Symlink creation cancelled."
    exit 0
fi

# Create the symbolic link
if ln -s "$source" "$destination"; then
    echo "${GREEN}Success! Symlink created:"
    echo "  $destination -> $source${RESET}"
else
    echo "${RED}Failed to create symlink.${RESET}"
    exit 1
fi
