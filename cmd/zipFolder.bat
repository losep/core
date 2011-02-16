@echo off
if X%1==X goto end
set name=%~n1
if X%2==X set ext=zip
if not X%2==X set ext=%~2
pushd %1\..\
rem echo zip -u -r -9 "%name%.%ext%" *
zip -u -r -9 "%name%.%ext%" "%name%" %3 %4 %5 %6 %7 %8 %9
echo %name%.%ext% saved.
popd
:end