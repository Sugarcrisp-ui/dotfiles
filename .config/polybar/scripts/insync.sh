#!/bin/bash

# Check if InSync is running
if pgrep -x "insync" > /dev/null; then
   echo "%{A1:insync start:}%{T1}%{F#5be610}󰤉%{T-}%{A}"
else
   echo "%{A1:insync start:}%{T1}%{F#FF0000}󰤉%{T-}%{A}"
fi
