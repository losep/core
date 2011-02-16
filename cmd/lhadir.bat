@echo off
if "%~1" == "" Goto Usage

:Action
set tmplha=%tmp%\%~1.lha
if exist "%tmplha%" del %tmplha%
pushd %1
lha.exe c -o6 -g "%tmplha%" *.*
popd
if exist "%tmplha%" move "%tmplha%" .
shift
if "%1"=="" goto end
goto Action

:Usage
echo lhadir v0.1
echo     - lha Folders
echo Usage:
echo %0 [folders...]
goto End

:End
set tmplha=

