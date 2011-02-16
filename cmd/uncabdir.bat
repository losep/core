@ECHO OFF
if "%1"=="" goto usage

:makecab
echo cabarc -p -o X %1 *.* %~n1\
cabarc -p -o X %1 *.* %~n1\
if "%2"=="" goto :eof
shift
goto makecab

goto :eof
:usage
echo %0 - extract cab 
echo Usage: %0 filename

