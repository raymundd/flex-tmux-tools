# g6ujb-flex-tools

A bunch of example scripts to use tmux with nCAT and nDAX and Multiple instances of SmartSDR.

These scripts are just wrappers for the following programs:

- Name : Installation source
- tmux : (RH/CentOS/Rocky/Alma) dnf install tmux
- nCAT : Available on GITHUB repository "kc2g-flex-tools"
- nDAX : Available on GITHUB repository "kc2g-flex-tools"
- WSJTX : Available from "www.physics.pronceton.edu/pulsar/k1jt/wsjtx.html"
- SmartSDR : Available when you own a FlexRadio from FlexRadio.

## Firewall

If you are sensibly running a firewall then the ports for DAX and Flexradio need to be set to permit traffic into the linux
machine running nCAT and nDAX, otherwise you can ignore this bit.

The following ports need to be opened on the host machine:

    4992/udp, 4992/tcp, 64001/udp, 64002/udp

e.g. on RedHat based Linux...
    firewall-cmd --add-port 4992/udp && firewall-cmd --permanent --add-port 4992/udp
    firewall-cmd --add-port 4992/tcp && firewall-cmd --permanent --add-port 4992/tcp
    firewall-cmd --add-port 64001/udp && firewall-cmd --permanent --add-port 64001/udp
    firewall-cmd --add-port 64002/udp && firewall-cmd --permanent --add-port 64002/udp

## Installing the scripts

Just take a copy of the release file and untar/zip it where you want it.

## Running the Scripts

These scripts assume that the Radio station name is all Uppercase:

The station IP, CAT nad DAX ports are currently hardcoded into the scripts - so you will need to check/change these based
on your network setup.

    start_radio.sh <STATION_NAME>

    stop_radio.sh <STATION_NAME>

## Running Multiple instances of SmartSDR with different STATION names on a single machine

### SmartSDR in a Virtual Machine

SmartSDR is a Windows only product and as such will need a windows platform to run on. This can be a physical or Virtual machine, however please be aware that the FlexRadio DAX utility does not take kindly to running in a VM environment due to Windows related latency issues that can become agrevated by the extra level of abstraction.

### Problems with Multiple instances of SmartSDR and utilities

You can run multiple instances of the SmartSDR program on the same Windows platform but running multiple instances of the FlexRadio provided CAT and DAX tools is not supported. These can only be run as a single instance and can only be attached to a single instance of SmartSDR, there is no way for FlexRadios DAX and CAT utilities to create multiple unique audio or CAT connections for multiple radios when running on the same windows machine.

Multiple instances of SmartSDR can be run but the operator will need to change the STATION name to a unique one for each instance.

### Linux to the rescue

However there is a way to get multiple instances of DAX and CAT running on a single machine by using **[kc2g-flex-tools](https://github.com/kc2g-flex-tools)** written by **[arodland](https://github.com/arodland)**.

In that repository you will find the nCAT and nDAX utlities. These are written for Linux and they support running multiple instances attached to multiple instances of SmartSDR. The instances of SmartSDR can be running on the same windows platform provided you undertake a few extra steps to set things up.

#### The following notes assume the following

- You have a Windows platform already with SmartSDR available and can control your FlexRadio(s) already using all the FlexRadio tools. This can be Windows running on a pyhsical machine or as a guest in a Virtual Machine.
- You have a Linux platform available, this could be a Virtual Machine running as a guest OS on the physical Windows platform, or You could have Linux running on a physical platform with a guest Windows Virtual machine to run SmartSDR.
- You know how to manipulate files in windows.
- %APPDATA% is set (usually by default to "C:\Users\<USERNAME>\AppData\Roaming")
- %APPDATA% is not hidden, if using Windows FileExplorer, you hopefully know how to make hidden items visble.

### Getting things ready

 1. Follow the information at **[kc2g-flex-tools](https://github.com/kc2g-flex-tools)** to install and the basic use of the nCAT and nDAX utilities.
 2. When the SmartSDR instances are running, manually set the "STATION:" name to be unique on each SmartSDR instance.
 3. Use the unique STATION names, as set in step (2), to run the nDAX and nCAT by altering the start and stop scripts in this repository to match.
 4. Radio demod/decoder software, e.g. WSJT-X will have to run on the Linux platform so that it can access the CAT and Audio ports provided by nCAT and nDAX.

## Starting multiple instances of SmartSDR with a pre-determined unique STATION name

### Background

When SmartSDR launches it gets parameters from the file %APPDATA%\FlexRadio Systems\SSDR.settings, this defines many things which includes the last known STATION name and radio serial number. By making use of multiple copies of this file it is possible to force the STATION name each time that SmartSDR launches to a pre-determined name for each instance.

### Getting things setup

1. Start an instance of SmartSDR and connect to your first FlexRadio.
2. Set the STATION name by double clicking the textbox near the **"STATION:"** label located at lower middle of the main window, press "Enter" when name is complete.
3. Under the SmartSDR settings menu, disable the options "Autostart CAT with SmartSDR" and "Autostart DAX with SmartSDR". (Assuming you are going to use nCAT and nDAX).
4. Exit the running SmartSDR - this is necessary to ensure settings are writted back to persistent storage.
5. Using your favourite windows file manager, copy the file **%APPDATA%\FlexRadio Systems\SSDR.settings** to a file with a different name, e.g. use the STATION name as a tag, i.e. %APPDATA%\FlexRadio Systems\SSDR_RDX6500.settings.
6. Start SmartSDR again and connect to your other FlexRadio, set the STATION: name to a different name to the first, again make any changes you need to this instance and disable "Autostart CAT with SmartSDR" and "Autostart DAX with SmartSDR" as required.
7. Exit this instance of SmartSDR.
8. Make another copy of **%APPDATA%\FlexRadio Systems\SSDR.settings** to another file with a unique name in same way as step 5.

## Switching the SmartSDR STATION name

Now changing the STATION name to alternative pre-determined named can be achieved by just copying the settings file with the STATION name you want back as %APPDATA%\FlexRadio Systems\SSDR.settings.

Here is a basic cmd.exe script example:

This script can be run in cmd.exe or as a .bat file, it copies one of the pre-saved version of the settings file into place and then starts the SmartSDR.

    copy /Y "%APPDATA%\FlexRadio Systems\SSDR_RDX6500.settings" "%APPDATA%\FlexRadio Systems\SSDR.settings"
    start "RDX6500" "%PROGRAMFILES%\FlexRadio Systems\SmartSDR v2.7.6\SmartSDR.exe"

> See StartSDR_RDX6500.bat and StartSSDR_RDX6600.bat files for more examples.

R.G.Delaforce
G6UJB
