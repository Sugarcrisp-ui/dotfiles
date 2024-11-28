#!/usr/bin/env python3

import os
import datetime
import readline

readline.set_completer_delims(' \t\n=')
readline.parse_and_bind("tab: complete") 

original_file = input("Enter the path to the file to backup: ")

if not os.path.exists(original_file):
    print("Error: File does not exist")
    exit()

print("Backup to same directory? (y/n)")
choice = input()
if choice.lower() == 'y' or choice == '':
    backup_dir = os.path.dirname(original_file)
else:
    backup_dir = input("Enter the backup directory path: ")
    if not os.path.exists(backup_dir):
        print("Error: Backup directory does not exist")
        exit()

filename = os.path.basename(original_file)
now = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
backup_file = os.path.join(backup_dir, f"{filename}_{now}")

print(f"Backing up {original_file} to {backup_file}") 

exit_status = os.system(f"cp {original_file} {backup_file}")

if exit_status == 0:
    print("Backup completed successfully")
else:
    print("Backup failed")
