#!/bin/bash

# Color definitions
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Functions
validate_path() {
    local path="$1"
    if [[ ! -e "$path" ]]; then
        echo "${RED}Error: Path '$path' does not exist.${RESET}"
        exit 1
    fi
}

check_infinite_loop() {
    local source="$1"
    local destination="$2"
    if [[ "$(realpath "$source")" == "$(realpath "$destination")" ]]; then
        echo "${RED}Error: This would create an infinite symlink loop. Operation cancelled.${RESET}"
        exit 1
    fi
}

create_symlink() {
    local source="$1"
    local destination="$2"
    if ln -s "$source" "$destination"; then
        echo "${GREEN}Success! Symlink created:"
        echo "  $destination -> $source${RESET}"
    else
        echo "${RED}Failed to create symlink.${RESET}"
        exit 1
    fi
}

# Main script
clear
echo "${BLUE}################################################################"
echo "                    Symbolic Link Creator"
echo "################################################################${RESET}"
echo

# Source entry reminders
echo "${YELLOW}Source Reminders:"
echo "1. For source directories, do NOT add a trailing slash (/)"
echo "2. Paths can be absolute or relative ${RESET}"
echo

# Prompt for source
read -e -p "${CYAN}Enter the source file or directory: ${RESET}" source
source=$(realpath -m "$source")  # Normalize path
validate_path "$source"

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

# Prompt for destination directory
read -e -p "${CYAN}Enter the directory for the symlink: ${RESET}" dest_dir
dest_dir=$(realpath -m "$dest_dir")  # Normalize path

# Determine symlink name
default_symlink_name=$(basename "$source")
echo
read -p "${CYAN}Use default symlink name '$default_symlink_name'? [Y/n]: ${RESET}" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    symlink_name="$default_symlink_name"
else
    while [[ -z "$symlink_name" || "$symlink_name" =~ [/\*\?] ]]; do
        echo "${RED}Please enter a valid symlink name without slashes or special characters:${RESET}"
        read -e -p "${CYAN}Enter the name for the symlink: ${RESET}" symlink_name
    done
fi

destination="$dest_dir/$symlink_name"

# Check if destination directory exists
if [[ ! -d "$dest_dir" ]]; then
    if ! mkdir -p "$dest_dir"; then
        echo "${RED}Error: Failed to create directory '$dest_dir'. Check permissions or path.${RESET}"
        exit 1
    else
        echo "${YELLOW}Creating parent directory: $dest_dir${RESET}"
    fi
fi

# Check if destination already exists
if [[ -e "$destination" ]]; then
    echo "${RED}Error: '$destination' already exists. Use --force to overwrite.${RESET}"
    exit 1
fi

# Check for infinite loop
check_infinite_loop "$source" "$destination"

# Confirmation before creation
read -p "${YELLOW}Create symlink '$destination' pointing to '$source'? [Y/n]: ${RESET}" -n 1 -r
echo
if [[ ! "$REPLY" =~ ^[Yy]$ && -n "$REPLY" ]]; then
    echo "Symlink creation cancelled."
    exit 0
fi

# Create the symbolic link
create_symlink "$source" "$destination"
