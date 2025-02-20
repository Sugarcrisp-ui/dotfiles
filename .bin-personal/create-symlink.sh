#!/bin/bash

# Color definitions
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Flags
FORCE=0

# Functions
validate_path() {
    local path="$1"
    if [[ ! -e "$path" ]]; then
        echo "${RED}Error: Path '$path' does not exist.${RESET}"
        exit 1
    fi
}

validate_symlink_name() {
    local name="$1"
    if [[ "$name" =~ ^[[:space:]]*$ || "$name" =~ [/\*\?\<\>\|] ]]; then
        return 1
    fi
    return 0
}

check_infinite_loop() {
    local source="$1"
    local destination="$2"
    local source_real=$(realpath -m "$source")
    local dest_real=$(realpath -m "$destination")
    
    # Only flag an error if the resolved paths are identical
    if [[ "$source_real" == "$dest_real" ]]; then
        echo "${RED}Error: Infinite loop detected - source and destination resolve to the same path${RESET}"
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
        echo "${RED}Failed to create symlink${RESET}"
        exit 1
    fi
}

# Handle interrupts
trap 'echo "${RED}Script interrupted${RESET}; exit 1' INT TERM

# Parse force option
if [[ "$1" == "--force" || "$1" == "-f" ]]; then
    FORCE=1
    shift
fi

# Main script
clear
echo "${BLUE}################################################################"
echo "                    Symbolic Link Creator"
echo "################################################################${RESET}"
echo

# Source entry
echo "${YELLOW}Source Reminders:"
echo "1. For directories, do NOT add a trailing slash (/)"
echo "2. Paths can be absolute or relative${RESET}"
echo
read -e -p "${CYAN}Enter the source file or directory: ${RESET}" source
source=$(realpath -m "$source")  # Normalize path
validate_path "$source"

# Show source type
if [[ -d "$source" ]]; then
    echo "${GREEN}Selected source is a directory${RESET}"
else
    echo "${GREEN}Selected source is a file${RESET}"
fi
echo

# Destination entry
echo "${YELLOW}Destination Reminders:"
echo "1. Specify the directory where the symlink will be created"
echo "2. Paths can be absolute or relative"
echo "3. Do NOT add a trailing slash (/), but you can use (~) for home"
echo "4. Example: ~/.config ${RESET}"
echo
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
    while ! validate_symlink_name "$symlink_name"; do
        echo "${RED}Please enter a valid name (no slashes or special chars):${RESET}"
        read -e -p "${CYAN}Enter the name for the symlink: ${RESET}" symlink_name
    done
fi

destination="$dest_dir/$symlink_name"

# Check and create destination directory
if [[ ! -d "$dest_dir" ]]; then
    if ! mkdir -p "$dest_dir"; then
        echo "${RED}Error: Failed to create '$dest_dir'. Check permissions.${RESET}"
        exit 1
    else
        echo "${YELLOW}Created directory: $dest_dir${RESET}"
    fi
fi

# Check if destination exists
if [[ -e "$destination" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
        rm -f "$destination" || {
            echo "${RED}Error: Failed to remove existing '$destination'${RESET}"
            exit 1
        }
        echo "${YELLOW}Overwriting existing symlink${RESET}"
    else
        echo "${RED}Error: '$destination' exists. Use -f or --force to overwrite.${RESET}"
        exit 1
    fi
fi

# Check for infinite loop
check_infinite_loop "$source" "$destination"

# Confirmation
read -p "${YELLOW}Create '$destination' -> '$source'? [Y/n]: ${RESET}" -n 1 -r
echo
if [[ ! "$REPLY" =~ ^[Yy]$ && -n "$REPLY" ]]; then
    echo "Symlink creation cancelled."
    exit 0
fi

# Create the symlink
create_symlink "$source" "$destination"
