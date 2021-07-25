#!/bin/bash

#Locations of programs
DAX_PROG=nDAX-linux-amd64
CAT_PROG=nCAT-linux-amd64
DAX_DIR=/home/$USER/Flexradio
WSJTX=/usr/bin/wsjtx

if [ $# -ne 1 ]; then
    echo "Usage: $0 <STATION>"
    echo "Current Radio STATION options:"
    echo "RDX6500, RDX6600"
    echo "Scripts are case sensitive so make sure you enter the station name exactly as displayed in SmartSDR."
    exit
fi

#Some example configs
if [ ${1^^} == "RDX6500" ]; then
    PORT=64001
    CAT_PORT=:4532
    STATION=${1^^}
    RADIO=192.168.42.165
elif [ ${1^^} == "RDX6600" ] ; then
    PORT=64002
    CAT_PORT=:4533
    STATION=${1^^}
    RADIO=192.168.42.166
else
    echo "Unknown Radio"
    exit
fi

#Make sure these are executable
chmod +x $DAX_DIR/$DAX_PROG
chmod +x $DAX_DIR/$CAT_PROG

if [ $(tmux ls | grep -c "${STATION^^}") -gt 0 ]; then
    echo "Session may already be running - abandoning run."
    tmux ls
    exit
fi

#Start nDAX, nCAT and WSJT-X
tmux start-server
tmux new-session -s ${STATION^^} -d -n "${STATION^^}-DAX" "$DAX_DIR/$DAX_PROG -station $STATION -udp-port $PORT -radio $RADIO -source $STATION.rx -sink $STATION.tx"
tmux new-window -d -n "${STATION^^}-CAT" "$DAX_DIR/$CAT_PROG -station $STATION -listen $CAT_PORT -radio $RADIO"
tmux new-window -d -n "${STATION^^}-WSJTX" "$WSJTX -r $STATION"