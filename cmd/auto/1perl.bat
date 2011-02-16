@echo off
if not exist %FS_Core_App%\perl\setenv.bat goto _END
call %FS_CORE_APP%\perl\setenv.bat
:_END