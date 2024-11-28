#!/usr/bin/env python3

import os
import readline
from getpass import getuser

def get_user_input(prompt):
    return input(f"{prompt}: ").strip()

def validate_choice(choice, max_choice):
    try:
        choice = int(choice)
        if choice not in range(1, max_choice + 1):
            raise ValueError
    except ValueError:
        return False
    return True

computers = {
    "desktop": "brett@192.168.1.10",
    "laptop": "brett@192.168.1.11",
    "kim": "kim@192.168.1.12"
}

readline.set_completer_delims(' \t\n=')
readline.parse_and_bind("tab: complete")

file_location = get_user_input("Enter the file location")

# Check if file exists
if not os.path.exists(file_location):
    print("File does not exist. Please try again.")
    exit(1)

print("Select the destination computer:")
for i, comp in enumerate(computers.keys(), start=1):
    print(f"{i}. {comp}")
comp_choice = get_user_input("Enter your choice")

# Check if user's choice is valid
if not validate_choice(comp_choice, len(computers)):
    print("Invalid choice. Please try again.")
    exit(1)

destination = list(computers.values())[int(comp_choice) - 1]

destination_dir = get_user_input("Enter the destination directory")

# Perform the rsync
exit_status = os.system(f"rsync -avz --progress {file_location} {destination}:{destination_dir}")

# Check if rsync was successful
if exit_status != 0:
    print("Rsync failed. Please check your inputs and try again.")
else:
    print("Rsync completed successfully.")