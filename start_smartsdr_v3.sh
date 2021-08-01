#!/bin/bash
# start_smartsdr_v3.sh
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

SDR_VER="v3.2.39"
RADIO="RDX6600"
LOCK_DIR="/tmp/smartsdr"
LOCK_FILE="${LOCK_DIR}/lock"

# Make the lock folder
if [ ! -d $LOCK_DIR ]; then
	mkdir -p $LOCK_DIR
fi

while [ -e $LOCK_FILE ]
do
	#wait for the lock to clear
	echo "waiting..."
	sleep 2
done

touch $LOCK_FILE
echo "LOCKED..."

cp ~/Flexradio/SSDR_${RADIO}.settings "/home/raymundd/radiotools/drive_c/users/raymundd/AppData/Roaming/FlexRadio Systems/SSDR.settings"
env WINEPREFIX=$HOME/radiotools wine "c:\Program Files\FlexRadio Systems\SmartSDR ${SDR_VER}\SmartSDR.exe" &

PROC=$$

while [ ! `pgrep -cf "${SDR_VER}.+SmartSDR.exe"` ]
do
	# wait for it to start
	echo "Wait for SmartSDR to start..."
	sleep 1
done

sleep 5

# Get the PID of SmartSDR.exe
for pid in "$(pgrep --parent $PROC)"
do
	echo $pid
	if [[ -n $pid ]] && [[ $(ps --no-headers -fp $pid | egrep -c "${SDR_VER}.+SmartSDR.exe") -eq 1 ]]
	then
		SDR=$pid
		break
	else
		echo "SmartSDR.exe not running."
		exit 1
	fi
done

rm $LOCK_FILE
echo "UNLOCKED..."
echo $SDR

while [[ $(ps --no-headers -p $SDR) ]]
do
	# wait for it to finish
	echo -n "."
	sleep 5
done

touch $LOCK_FILE
echo "LOCKED..."

cp "/home/raymundd/radiotools/drive_c/users/raymundd/AppData/Roaming/FlexRadio Systems/SSDR.settings" ~/Flexradio/SSDR_${RADIO}.settings
_saved

rm $LOCK_FILE
echo "UNLOCKED..."
