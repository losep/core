@echo off
if not exist %FS_APP%\develop\GTK\NUL goto _END
set GTK_DIR=%FS_APP%\DEVELOP\GTK
set NEWPATH=%NEWPATH%;%GTK_DIR%\BIN;%GTK_DIR%\lib
:_END