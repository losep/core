@ECHO OFF
IF "x%1"=="x" goto NO_ARG

dir %FS_SYSTEM_CMD%\%1.bat

goto END

:NO_ARG
dir %FS_SYSTEM_CMD%\*.bat

:END


