#!/bin/bash
# stop_radio.sh
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
