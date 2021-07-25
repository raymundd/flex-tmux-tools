@REM Start an instance of SmartSDR using a pre-determined settings file
@REM This is just so I can control the initial STATION name.

copy "%APPDATA%\FlexRadio Systems\SSDR.settings" "%APPDATA%\FlexRadio Systems\SSDR_Orig.settings"
copy "%APPDATA%\FlexRadio Systems\SSDR_RDX6500.settings" "%APPDATA%\FlexRadio Systems\SSDR.settings"
start "%PROGRAMFILES%\FlexRadio Systems\SmartSDR v2.7.6\SmartSDR.exe"