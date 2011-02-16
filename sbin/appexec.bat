@echo off
if ""=="%~1" goto usage
if exist "%FS_APP%\%~1" goto fs_app
if exist "%FS_System_APP%\%~1" goto fs_sys
if exist "%FS_Core_APP%\%~1" goto fs_core
call %*
goto end

:usage
goto end

:fs_app
call %FS_APP%\%*
goto end

:fs_sys
call %FS_System_APP%\%*
goto end

:fs_core
call %FS_Core_APP%\%*
goto end

:end