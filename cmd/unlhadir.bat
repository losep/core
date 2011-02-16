@ECHO OFF
if "%1"=="" goto usage
set n=%~n1
lha x -f -w="%n%" %1
set n=
goto end
:usage
echo Usage:%0 filename.zip
:end

