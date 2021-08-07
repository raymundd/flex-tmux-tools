#!/bin/bash
# start_radio.sh
#
# Copyright 2021 Ray Delaforce
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

# Create a launch script
cat <<EOF > /tmp/wsjtx.sh
#!/bin/bash
${WSJTX} -r ${STATION}&
PROC1=\$!
echo \$PROC1 > /tmp/${STATION}.pid
wait \$PROC1
echo "WSJT - FINISHED"
EOF

# Prepare the launch script and pid file
chmod +x /tmp/wsjtx.sh
rm /tmp/${STATION}.pid

#Start nDAX, nCAT and WSJT-X
tmux start-server
tmux new-session -s ${STATION^^} -d -n "${STATION^^}-DAX" "$DAX_DIR/$DAX_PROG -station $STATION -udp-port $PORT -radio $RADIO -source $STATION.rx -sink $STATION.tx"
tmux new-window -d -n "${STATION^^}-CAT" "$DAX_DIR/$CAT_PROG -station $STATION -listen $CAT_PORT -radio $RADIO"
tmux new-window -d -n "${STATION^^}-WSJTX" /tmp/wsjtx.sh

# Lets remember the pid of this tmux session so that we can find the associated instance of WSJTX.exe that was launched.
# Wait for the pid file to be created.
loop=0
while [ ! -e /tmp/${STATION}.pid ]; do
        sleep 1
        ((loop++))
        if [ $loop -gt 10 ]; then
                echo "ERROR - Process has failed."
        fi
done

WSJTX_P=$(cat /tmp/${STATION}.pid)
echo $WSJTX_P

# Spinner routine - Lets just show that the script is alive and waiting for SmartSDR.exe to exit.
spin='-\|/'
i=0
while [[ $(ps --no-headers -p $WSJTX_P) ]]
do
	# wait for it to finish
    	i=$(( (i+1) %4 ))
		printf "\rINFO: Running ${spin:$i:1}"
  		sleep .5
done

echo

#TODO - Clear down the tmux session for this instance.
rm /tmp/wsjtx.sh
rm /tmp/${STATION}.pid