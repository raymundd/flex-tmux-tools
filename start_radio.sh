#!/bin/bash

DAX_PROG=nDAX-linux-amd64
CAT_PROG=nCAT-linux-amd64
DAX_DIR=/home/$USER/Flexradio
PROG=${DAX_PROG:0:15}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <radio_name>"
    echo "Current Radio options:"
    echo "bluemoon, reddwarf"
    exit
fi

if [ $1 == "bluemoon" ]; then
    PORT=64001
    STATION=BLUEMOON
    RADIO=192.168.42.144
elif [ $1 == "reddwarf" ] ; then
    PORT=64002
    STATION=REDDWARF
    RADIO=192.168.42.119
else
    echo "Unknown Radio"
    exit
fi

chmod +x $DAX_DIR/$DAX_PROG

#Start nDAX, nCAT and WSJT-X
tmux new-session -d -s $1 -n "$STATION-DAX" "$DAX_DIR/$DAX_PROG -station $1 -udp-port $PORT -radio $RADIO -source $STATION.rx -sink $STATION.tx"
tmux new-window -d -n "$STATION-CAT" "$DAX_DIR/$CAT_PROG -station $STATION -listen :4532 -radio $RADIO"
tmux new-window -d -n "$STATION-WSJTX" "wsjtx -r $STATION"