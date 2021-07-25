# flex-tmux-tools

A bunch of example scripts to use tmux with nCAT and nDAX

These scripts are just wrappers for the following programs:

Name : Installation source
tmux : (RH/CentOS/Rocky/Alma) dnf install tmux
nCAT : Available on GITHUB repository "kc2g-flex-tools"
nDAX : Available on GITHUB repository "kc2g-flex-tools"
WSJTX : Available from "www.physics.pronceton.edu/pulsar/k1jt/wsjtx.html"

If you are sensibly running a firewall then the ports for DAX and Flexradio need to be set to permit traffic into the linux
machine running nCAT and nDAX.

The following ports need to be opened on the host machine:

4992/udp, 4992/tcp, 64001/udp, 64002/udp

e.g.
firewall-cmd --add-port 4992/udp && firewall-cmd --permanent --add-port 4992/udp
firewall-cmd --add-port 4992/tcp && firewall-cmd --permanent --add-port 4992/tcp
firewall-cmd --add-port 64001/udp && firewall-cmd --permanent --add-port 64001/udp
firewall-cmd --add-port 64002/udp && firewall-cmd --permanent --add-port 64002/udp

These scripts assume that the Radio station name is all Uppercase:

The station IP, CAT nad DAX ports are currently hardcoded into the scripts - so you will need to check/change these based
on your network setup.

start_radio.sh <STATION_NAME>

stop_radio.sh <STATION_NAME>

## Multiple instances of SmartSDR running on a single machine

The SmartSDR is a Windows only product and as such will need a windows platform to run on.
You can run multiple instances of the SmartSDR program but the standard CAT and DAX tools
can only be run once and can only be attached to a single instance of SmartSDR.

By using nCAT and nDAX you can run multiple copies of SmartSDR on the windows platform as long
as you do the following:

 1. When the SmartSDR instances are running manually set the STATION: name to be unique on each instance.
 2. Use the unique STATION names as set in (1) when altering the scripts.
 3. nDAX and nCAT run on a Linux platform
 4. Radio decoder software, e.g. WSJT-X will have to run on the Linux platform inorder to access the
   CAT and Audio ports provided bu nCAT and nDAX.
