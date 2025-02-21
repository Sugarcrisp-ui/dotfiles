#!/bin/bash
# Detect connected output and set workspaces
OUTPUT=$(xrandr | grep " connected" | awk '{print $1}' | head -n 1)
i3-msg "workspace 1 output $OUTPUT; workspace 2 output $OUTPUT; workspace 3 output $OUTPUT; workspace 4 output $OUTPUT; workspace 5 output $OUTPUT; workspace 6 output $OUTPUT; workspace 7 output $OUTPUT; workspace 8 output $OUTPUT; workspace 9 output $OUTPUT; workspace 10 output $OUTPUT; workspace 1"
