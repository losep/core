@echo off
if not exist %FS_System_App%\devel\mingw\setenv.bat goto _END
call %FS_System_App%\devel\mingw\setenv.bat
:_END