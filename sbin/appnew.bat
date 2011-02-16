@ECHO OFF


IF !%1==! GOTO USAGE
if ""=="%FS_CONSOLE_EDITOR%" set FS_CONSOLE_EDITOR=notepad++.bat
set appname=%~n1
IF EXIST %FS_SYSTEM_CMD%\%appname%.BAT GOTO EDIT

:CREATE
echo Creating %appname% ...
echo @ECHO OFF>%FS_SYSTEM_CMD%\%appname%.bat
echo apprund + %1 %%*>>%FS_SYSTEM_CMD%\%appname%.bat
goto EDIT

:USAGE
echo USAGE:%0 ProgramPath
echo   Create %%FS_SYSTEM_CMD%%\ProgramNAME.BAT or edit it if exists.
goto END

:EDIT

CALL %FS_CONSOLE_EDITOR% %FS_SYSTEM_CMD%\%appname%.bat
set appname=
:END

