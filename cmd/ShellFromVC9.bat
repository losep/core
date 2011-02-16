@echo off
set SHELLDIR=%~dp0
call "%SHELLDIR%\Shell.bat" __BYCMD__
SET NEWPATH=%PATH%
SET PATH=%_ACP_PATH%
for %%i in (%NEWPATH%) do call "%SHELLDIR%\pathadd.bat" %%i
set NEWPATH=
set SHELLDIR=
