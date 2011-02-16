@echo off
if not exist %FS_APP%\develop\vctools\NUL goto _END
SET VCTOOLS=%FS_APP%\develop\vctools
if "%PROCESSOR_ARCHITECTURE%"=="" goto x86
goto %PROCESSOR_ARCHITECTURE%
goto end

:x86
if "%OS%"=="Windows_NT" set VCTOOLS=%VCTOOLS%\winnt;%VCTOOLS%
if not "%OS%"=="Windows_NT" set VCTOOLS=%VCTOOLS%\win9x;%VCTOOLS%
goto end

:x64
:i64
set VCTOOLS=%VCTOOLS%\winnt;%VCTOOLS%

:end
set NEWPATH=%NEWPATH%;%VCTOOLS%
set VCTOOLS=
:_END