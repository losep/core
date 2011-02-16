@ECHO OFF
if "%1"=="" goto usage

:arj
rem set n=%~n1
rem pushd "%1"
rem popd
rem echo arj a -jm -r -e1 "%n%.arj" %1
arj x -y -ht"%~n1" "%1"
rem arj x -n -o -ht"%~n1" "%1"
shift
if not "%1"=="" goto arj

goto end
:usage
echo $0 directories...
:end
