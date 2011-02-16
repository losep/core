@echo off
for %%i in (*.zhtm) do call unzhtm.bat "%%~fi"
pause
call zhtmAllfolder.bat