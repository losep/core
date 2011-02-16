@echo off
if "%~1" == "" Goto Usage
set cwd=%CD%
:Action
pushd %1
set name=%~n1.zbook
echo zip.exe -XDr9 "%cwd%\%name%" *
zip.exe -XDr9 "%cwd%\%name%" *
popd
shift
if "%1"=="" goto end
goto Action

:Usage
echo makezbook v0.1
echo     - Zip Folders
echo Usage:
echo %0 [folders...]
goto End

:End
set tmpzip=

