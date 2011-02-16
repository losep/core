@echo %DEBUG_SHELL% off
SETLOCAL
title MINGW32
set USER=
set USERNAME=
set HOME=
set PERL_DIR=
set GTK_DIR=
set SHELL_CMD=
set SHELL_PWD=
set LINUXROOT=

set MINGW32=%FS_ROOT%\program\develop\mingw
set PATH=%SYSTEMROOT%\system32;%SYSTEMROOT%;%MINGW32%\bin
set INCLUDE=%MINGW32%\INCLUDE
SET LIB=%MINGW32%\LIB
SET INFOPATH=%MINGW%\INFO
SET MANPATH=%MINGW%\MAN
call %~dp0\setenv_gtk.bat
SET PATH=%PATH%;%FS_ROOT%\program\commands
%SYSTEMROOT%\system32\cmd.exe
ENDLOCAL

