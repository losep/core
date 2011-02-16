@echo off
if X%1==X goto end
set name=%~n1
set folder=%~1
if not exist "%folder%" goto end
if X%2==X set ext=zip
if not X%2==X set ext=%~2
set zipfile="%folder%\..\%name%.%ext%"
pushd "%folder%"
rem echo zip -u -r -9 %zipfile% *
zip -u -r -9 "..\%name%.%ext%" * %3 %4 %5 %6 %7 %8 %9
echo %zipfile% saved.
popd
:end

