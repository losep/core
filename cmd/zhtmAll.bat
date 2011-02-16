@echo off
for /d %%i in (*) do call zhtmFolder.bat "%%~fi" %1
exit 0