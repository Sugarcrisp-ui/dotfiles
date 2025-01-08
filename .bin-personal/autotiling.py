#!/usr/bin/env python3

import argparse
import sys
from functools import partial
from i3ipc import Connection, Event

def switch_splitting(i3, e):
    con = i3.get_tree().find_focused()
    if con and con.parent:
        # Check if the window should be split vertically or horizontally
        new_layout = "splitv" if con.rect.height > con.rect.width / 1.618 else "splith"

        # Only change the layout if it's different
        if new_layout != con.parent.layout:
            result = i3.command(new_layout)
            if not result[0].success:
                print(f"Error: Switch to {new_layout} failed", file=sys.stderr)

def main():
    parser = argparse.ArgumentParser(description="Custom autotiling script for i3 or sway")
    parser.add_argument("-d", "--debug", action="store_true", help="Print debug messages")
    parser.add_argument("-v", "--version", action="version", version="1.0", help="Show version")
    args = parser.parse_args()

    # Connect to i3 or sway
    i3 = Connection()

    # Event handler using partial for fixed arguments
    handler = partial(switch_splitting)

    # Subscribe to events that trigger split adjustment
    for event in ["WINDOW", "MODE"]:
        i3.on(getattr(Event, event), handler)

    # Keep the script running to listen for events
    i3.main()

if __name__ == "__main__":
    main()
