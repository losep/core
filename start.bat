@echo off

if "" == "%~1" goto empty
rem "%~dp0\core\sbin\shell.bat" -r "%~dp0" "%~1"
"%~dp0\sbin\shell.bat" "%~1"
goto end

:empty
rem "%~dp0\core\sbin\shell.bat" -r "%~dp0"
"%~dp0\sbin\shell.bat"
:end