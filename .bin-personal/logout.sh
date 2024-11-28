#!/bin/bash
~/.bin-personal/post-i3.sh
sleep 1
loginctl terminate-session ${XDG_SESSION_ID-}
