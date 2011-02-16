@ECHO off
if "%~1"=="" exit /B 1
for %%i in (%PATH%) DO (if "%~1"=="%%i" exit /B 0)
exit /B 1
