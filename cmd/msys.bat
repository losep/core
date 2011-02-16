@echo %DEBUG% off
if not exist %FS_CORE_APP%\msys\msys.bat goto _END
set username=xiaoranzzz
set HOME=%FS_Core%\data\msys
%FS_CORE_APP%\msys\msys.bat
:_END
