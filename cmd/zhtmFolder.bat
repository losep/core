@echo off
if X%1==X goto end
if X%2==X (
	set ext=zhtm
) else (
set ext=%2
)
call zipInfolder.bat "%~f1" %ext%
set name=%~n1
set folder=%~f1
set zipfile="%folder%\..\%name%.%ext%"
if not exist %zipfile% goto end
echo rmdir /s /q "%folder%"
rmdir /s /q "%folder%"
:end