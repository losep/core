@ECHO OFF
set host=svn://localhost/repos
set src=%~1
if ""=="%src%" goto usage

set dst=%~2
if ""=="%dst%" set dst=%~n1/trunk

:import
echo svn import "%src%" "%host%/%dst%"
svn import "%src%" "%host%/%dst%" %3 %4 %5 %6 %7 %8 %9

:recheckout
echo svn checkout --force "%host%/%dst%" "%src%"
svn checkout --force "%host%/%dst%" "%src%"
goto end

:usage
echo %0
echo Usage: %0 source_directory svn_target_directory
:end

