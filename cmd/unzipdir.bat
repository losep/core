@ECHO OFF
if "%1"=="" goto usage
set n=%~n1
echo unzip -o %1 -d "%n%"
unzip -o %1 -d "%n%"
set n=
goto end
:usage
echo Usage:%0 filename.zip
:end

