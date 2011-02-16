@ECHO OFF

IF "%2"=="" GOTO USAGE
IF "%1"=="" GOTO USAGE
IF "%FS_APP%"=="" GOTO ERRDIR

IF "%1"=="/C" GOTO CD_RUN


:NORMAL_RUN
IF NOT EXIST "%FS_APP%/%1" GOTO ERRDIR 
SET FULLPATH="%FS_APP%/%1/%2"
shift
shift
call %FULLPATH% %1 %2 %3 %4 %5 %6 %7 %8 %9
SET FULLPATH=
GOTO END


:CD_RUN
SHIFT
IF NOT EXIST "%FS_APP%/%1" GOTO ERRDIR 
pushd "%FS_APP%/%1"
SET FULLPATH="%2"
SHIFT
SHIFT
call %FULLPATH% %1 %2 %3 %4 %5 %6 %7 %8 %9
popd
GOTO END




:USAGE
ECHO %0 V0.1
ECHO Usage:
ECHO    %0 [/C] Programe_dir programe_name
ECHO    /C  -   Change to programe_dir first
GOTO END



:ERRDIR
echo Folder %FS_APP%/%1 NOT EXISTS
echo %0 Abort!

:END





