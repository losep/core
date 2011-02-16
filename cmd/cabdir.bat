@ECHO OFF
if "%1"=="" goto usage

:makecab
echo cabarc -p -r -P %1\ n %~n1.cab %1\*.*
cabarc -p -r -P %1\ n %~n1.cab %1\*.*
if "%2"=="" goto :eof
shift
goto makecab

goto :eof
:usage
echo %0 - make cab 
echo Usage: %0 directory

