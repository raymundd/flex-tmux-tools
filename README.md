# flex-tmux-tools

A bunch of example scripts to use tmux with nCAT and nDAX

These scripts are just wrappers for the following programs:

Name : Installation source
tmux : (RH/CentOS/Rocky/Alma) dnf install tmux
nCAT : Available on GITHUB repository "kc2g-flex-tools"
nDAX : Available on GITHUB repository "kc2g-flex-tools"
WSJTX : Available from "www.physics.pronceton.edu/pulsar/k1jt/wsjtx.html"

The following firewall ports need to be opened:

4992/udp, 4992/tcp, 64001/udp, 64002/udp

These scripts assume that the Radio station name is all Uppercase:

start_radio.sh <STATION_NAME>

stop_radio.sh <STATION_NAME>