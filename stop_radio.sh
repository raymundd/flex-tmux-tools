#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "Usage: $0 <station_name>"
fi

#Send CTRL-C to all panes.
tmux list-panes -st ${1^^} -F '#{session_name}:#{window_index}' | xargs -I WINDOW tmux send-keys -t WINDOW C-c

#Cleanup for failed startup
sleep 5
#Need to only kill the following if they are related to the session's STATION name
pkill -f "^[^tmux].*nDAX.*${1}"
pkill -f "^[^tmux].*nCAT.*${1}"