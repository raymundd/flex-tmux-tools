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
PACTL=/usr/bin/pactl
DAX_PROG=nDAX-linux-amd64
CAT_PROG=nCAT-linux-amd64
DAX_DIR=/home/$USER/Flexradio
TOOL=/usr/bin/fldigi


if [ $# -ne 1 ]; then
    echo "Usage: $0 <STATION>"
    echo "Current Radio STATION options:"
    echo "RDX6500, RDX6600"
    echo "Scripts are case sensitive so make sure you enter the station name exactly as displayed in SmartSDR."
    exit
fi

#Some example configs
if [ ${1^^} == "RDX6500" ]; then
    SLICE=B
    DAXCH=2
    PORT=64003
    CAT_PORT=:4534
    STATION=${1^^}
    RADIO=192.168.42.165
elif [ ${1^^} == "RDX6600" ] ; then
    SLICE=B
    DAXCH=2
    PORT=64004
    CAT_PORT=:4535
    STATION=${1^^}
    RADIO=192.168.42.166
else
    echo "Unknown Radio"
    exit
fi

#Make sure these are executable
chmod +x $DAX_DIR/$DAX_PROG
chmod +x $DAX_DIR/$CAT_PROG

if [ $(tmux ls | grep -c "${STATION^^}-FL") -gt 0 ]; then
    echo "Session may already be running - abandoning run."
    tmux ls
    exit
fi

# Use randomized unique filenames for each instance of run.
TEMP_SCRIPT=$(mktemp /tmp/${STATION}.XXXXXXXX.sh)
PID_FILE=$(mktemp /tmp/${STATION}.XXXXXXXX.pid)

# Create temporary runtime script to allow us to get the PID of tool.
cat <<EOF > $TEMP_SCRIPT
#!/bin/bash
${TOOL} --config-dir ${HOME}/Fldigi/${STATION}&
PROC1=\$!
echo \$PROC1 > ${PID_FILE}
wait \$PROC1
echo "${TOOL} - FINISHED"
EOF

# Prepare the launch script
chmod +x $TEMP_SCRIPT

# Start tmux, nDAX, nCAT and WSJT-X
tmux new-session -s "${STATION^^}-FL" -d -n "${STATION^^}-FL-DAX" "$DAX_DIR/$DAX_PROG -station $STATION -udp-port $PORT \
                    -radio $RADIO -source ${STATION}-${SLICE}-${DAXCH}.rx -sink ${STATION}-${SLICE}-${DAXCH}.tx \
                    -slice $SLICE -daxch $DAXCH"
tmux new-window -d -n "${STATION^^}-FL-CAT" "$DAX_DIR/$CAT_PROG -station $STATION -listen $CAT_PORT -radio $RADIO \
                    -slice $SLICE"
tmux new-window -d -n "${STATION^^}-FL-TOOL" $TEMP_SCRIPT

# Lets remember the pid of this tmux session so that we can find the associated instance of tool that was launched.
# Wait for the pid file to be created.
loop=0
while [ ! -s ${PID_FILE} ]; do
        sleep 1
        ((loop++))
        echo -n .
        if [ $loop -gt 10 ]; then
                echo "ERROR - Process has failed."
                exit 1
        fi
done

echo

# Spinner routine - Lets just show that the script is alive and waiting for tool to exit.
TOOL_P=$(cat ${PID_FILE})
echo $TOOL_P

# nDAX wants to create the pulseaudio sink for TX - this needs to always be the default sink
# Need to actually check if a sink device exists - if it does then donot ask for it!
echo "Setting default TX Audio to this one..."
${PACTL} set-default-sink "${STATION^^}-${SLICE}-${DAXCH}.tx"

spin='-\|/'
i=0
while [[ $(ps --no-headers -p $TOOL_P) ]]
do
	# wait for it to finish
    	i=$(( (i+1) %4 ))
		printf "\rINFO: Running ${spin:$i:1}"
  		sleep .5
done

echo
echo "Stopping..."

# Clear down the tmux session for this instance.
rm $TEMP_SCRIPT
rm $PID_FILE
# Send CTRL-C to all panes.
tmux list-panes -st "${STATION^^}-FL" -F '#{session_name}:#{window_index}' | xargs -I WINDOW tmux send-keys -t WINDOW C-c

# Cleanup for failed startup
sleep 5
# Need to only kill the following if they are related to the session's STATION SLICE and DAXCH name
pkill -f "^[^tmux].*nDAX.*${STATION}-${SLICE}-${DAXCH}"
pkill -f "^[^tmux].*nCAT.*${STATION}.*slice ${SLICE}"