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
    if [[ -z "$name" || "$name" =~ / ]]; then
        return 1
    fi
    return 0
}

check_infinite_loop() {
    local source="$1"
    local destination="$2"
    local source_real=$(realpath -m "$source")
    local dest_real=$(realpath -m "$destination")
    if [[ "$source_real" == "$dest_real" ]]; then
        echo "${RED}Error: Infinite loop detected${RESET}"
        exit 1
    fi
}

create_symlink() {
    local source="$1"
    local destination="$2"
    if ln -s "$source" "$destination"; then
        echo "${GREEN}Success! Symlink created: $destination -> $source${RESET}"
    else
        echo "${RED}Failed to create symlink${RESET}"
        exit 1
    fi
}

# Handle interrupts
trap 'echo "${RED}Script interrupted${RESET}; exit 1' INT TERM

# Parse options
while [[ "$1" == -* ]]; do
    case "$1" in
        --force|-f)
            FORCE=1
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--force]"
            echo "  --force, -f: Overwrite existing symlinks"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

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
source=$(realpath -m "$source")
validate_path "$source"

if [[ -d "$source" ]]; then
    echo "${GREEN}Selected source is a directory${RESET}"
else
    echo "${GREEN}Selected source is a file${RESET}"
fi
echo

# Destination entry
echo "${YELLOW}Destination Reminders:"
echo "1. Specify the directory for the symlink"
echo "2. Paths can be absolute or relative"
echo "3. Example: ~/.config${RESET}"
echo
read -e -p "${CYAN}Enter the directory for the symlink: ${RESET}" dest_dir
dest_dir=$(realpath -m "$dest_dir")

# Symlink name
default_symlink_name=$(basename "$source")
echo
read -p "${CYAN}Use default name '$default_symlink_name'? [Y/n]: ${RESET}" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    symlink_name="$default_symlink_name"
else
    while ! validate_symlink_name "$symlink_name"; do
        echo "${RED}Enter a valid name (no slashes or empty):${RESET}"
        read -e -p "${CYAN}Enter the symlink name: ${RESET}" symlink_name
    done
fi

destination="$dest_dir/$symlink_name"

# Check if destination is a directory
if [[ -d "$destination" ]]; then
    echo "${RED}Error: '$destination' is a directory. Cannot overwrite.${RESET}"
    exit 1
fi

# Create destination directory if needed
if [[ ! -d "$dest_dir" ]]; then
    if ! mkdir -p "$dest_dir"; then
        echo "${RED}Error: Failed to create '$dest_dir'.${RESET}"
        exit 1
    else
        echo "${YELLOW}Created directory: $dest_dir${RESET}"
    fi
fi

# Handle existing destination
if [[ -e "$destination" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
        rm -f "$destination" || {
            echo "${RED}Error: Failed to remove '$destination'${RESET}"
            exit 1
        }
        echo "${YELLOW}Overwriting existing symlink${RESET}"
    else
        echo "${RED}Error: '$destination' exists. Use --force to overwrite.${RESET}"
        exit 1
    fi
fi

# Check for infinite loop
check_infinite_loop "$source" "$destination"

# Confirmation
read -p "${YELLOW}Create '$destination' -> '$source'? [Y/n]: ${RESET}" -n 1 -r
echo
if [[ ! "$REPLY" =~ ^[Yy]$ && -n "$REPLY" ]]; then
    echo "Cancelled."
    exit 0
fi

# Create the symlink
create_symlink "$source" "$destination"
