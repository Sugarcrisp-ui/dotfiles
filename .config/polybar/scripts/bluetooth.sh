#!/bin/sh

if [ $(pgrep -x blueman-manager) ]
then
  echo "%{F#FFFFFF}%{B#000000}%{A1:blueman-manager:}%{A3:blueman-applet:}%{A}%{B#000000}%{F-}"  # Blueman running, clickable
else
  echo "%{F#66ffffff}%{B#000000}%{A1:blueman-manager:}%{A3:blueman-applet:}%{A}%{B#000000}%{F-}"  # Blueman not running, clickable
fi
