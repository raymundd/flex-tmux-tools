#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "Usage: $0 <station_name>"
fi

tmux list-panes -st ${1^^} -F '#{session_name}:#{window_index}' | xargs -I WINDOW tmux send-keys -t WINDOW C-c

#Cleanup for failed startup
sleep 5
pkill nDAX
pkill nCAT
pkill pulseaudio