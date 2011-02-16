@ECHO OFF
if "%1"=="" goto no_target
SET AVDIR=%FS_APP%\system\antivir
SET TARGET=%~f1
echo "AVScan" "%AVDIR%\avscan.exe" /CFG="%AVDIR%\profiles\filescan.avp" /PATH="%*"
start "AVScan" "%AVDIR%\avscan.exe" /CFG="%AVDIR%\profiles\filescan.avp" /PATH="%TARGET%"
goto end
:no_target
echo AVScan: NO target specified
:end
