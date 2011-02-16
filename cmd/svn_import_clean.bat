@ECHO OFF
set host=svn://localhost/repos
set src=%~1
if ""=="%src%" goto usage

set dst=%~2
if ""=="%dst%" set dst=%~n1/trunk

:import
echo svn import "%src%" "%host%/%dst%"
svn import "%src%" "%host%/%dst%"

:recheckout
pause
echo Delete directory "%src%"
rmdir /s "%src%"
goto end

:usage
echo %0
echo Usage: %0 source_directory svn_target_directory
:end

