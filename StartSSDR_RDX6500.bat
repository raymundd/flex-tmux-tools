@REM startSSDR_RDX6500.bat
@REM
@REM Copyright 2021 Ray Delaforce
@REM
@REM This program is free software: you can redistribute it and/or modify
@REM it under the terms of the GNU General Public License as published by
@REM the Free Software Foundation, either version 3 of the License, or
@REM (at your option) any later version.
@REM
@REM This program is distributed in the hope that it will be useful,
@REM but WITHOUT ANY WARRANTY; without even the implied warranty of
@REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@REM GNU General Public License for more details.
@REM
@REM You should have received a copy of the GNU General Public License
@REM along with this program.  If not, see <http://www.gnu.org/licenses/>.
@REM 
@REM Starting an instance of SmartSDR using a pre-determined settings file
@REM This is just so I can control the initial STATION name.
@REM Author: R.G.Delaforce G6UJB.
@REM
@REM N.B. Before using this script:
@REM Start SmartSDR and connect to first FlexRadio.
@REM Set the STATION name and then exit SmartSDR.
@REM Save the file %APPDATA%\FlexRadio Systems\SSDR.settings to another file with a unique name.
@REM Start SmartSDR and connect to the next FlexRadio.
@REM Set another unique STATION name and then exit SmartSDR.
@REM Save the file %APPDATA%\FlexRadio Systems\SSDR.settings to another file with a unique name.
@REM Now alter the script to match the location and names of the saved copies of settings file.

@REM Script now Copies the current settings to safer place - this is not entirely necessary since losing
@REM the settings file is not the end of the World, SmartSDR will just create a new one with defaults.
copy /Y "%APPDATA%\FlexRadio Systems\SSDR.settings" "%APPDATA%\FlexRadio Systems\SSDR_Orig.settings"

@REM Copy the pre-saved settings file as explained in the pre-amble above in to replace the current settings file.
copy /Y "%APPDATA%\FlexRadio Systems\SSDR_RDX6500.settings" "%APPDATA%\FlexRadio Systems\SSDR.settings"

@REM Launch a copy of SmartSDR - Please make sure that the path matches where your copy exists.
start "RDX6500" "%PROGRAMFILES%\FlexRadio Systems\SmartSDR v2.7.6\SmartSDR.exe"
