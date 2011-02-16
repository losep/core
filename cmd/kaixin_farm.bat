@ECHO off
REM apprun CMDLINE
pushd %FS_APP%\games\kaixin_farm

if "%1" == "help" goto Help
if "%1" == "save" goto Save
if not "X%1" == "X" goto Setting
goto START

:Setting
echo copy /Y "%~1.xml" GardenSetting.xml ...
copy /Y "%~1.xml" GardenSetting.xml
shift

:START
echo start kaixin_farm.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
start kaixin_farm.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
goto END

:Help
echo "Usage:%0 [save] profile_name"
goto END

:Save
if "%2" == "" goto HELP
echo copy /Y GardenSetting.xml "%~2.xml" ...
copy /Y GardenSetting.xml "%~2.xml"
:END
popd
