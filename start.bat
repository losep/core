@echo off
setlocal
set launcher=start "PowerShell" "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe"
set params=-NoLogo -File

if "" == "%~1" goto empty
rem "%~dp0\core\sbin\shell.bat" -r "%~dp0" "%~1"
%launcher% %params% "%~dp0\core\sbin\Shell.ps1" "%~1"
goto end

:empty
rem "%~dp0\core\sbin\shell.bat" -r "%~dp0"
rem "%~dp0\core\sbin\shell.bat"
%launcher% -NoExit %params%  "%~dp0\core\sbin\Shell.ps1"
:end
endlocal