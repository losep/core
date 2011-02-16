@ECHO off
REM apprun CMDLINE
pushd %FS_APP%\games\kaixin_car

if "%1" == "help" goto Help
if "%1" == "save" goto Save
if not "X%1" == "X" goto Setting
goto START

:Setting
echo copy /Y "%~1.xml" data.xml ...
copy /Y "%~1.xml" data.xml
shift

:START
start kaixin_car.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
goto END

:Help
echo "Usage:%0 [save] profile_name"
goto END

:Save
if "%2" == "" goto HELP
echo copy /Y data.xml "%~2.xml" ...
copy /Y data.xml "%~2.xml"
:END
popd
