@echo %DEBUG% off

goto BEGIN

REM setlocal
REM 开始批处理文件中环境改动的本地化操作。在执行 SETLOCAL 之后
REM 所做的环境改动只限于批处理文件。要还原原先的设置，必须执
REM 行 ENDLOCAL。达到批处理文件结尾时，对于该批处理文件的每个
REM 尚未执行的 SETLOCAL 命令，都会有一个隐含的 ENDLOCAL 被执行。

REM SETLOCAL

REM 如果命令扩展被启用，SETLOCAL 会如下改变:

REM SETLOCAL 批命令现在可以接受可选参数:
        REM ENABLEEXTENSIONS / DISABLEEXTENSIONS
            REM 启用或禁用命令处理器扩展。这些
            REM 参数比 CMD /E:ON 或 /E:OFF
            REM 开关有优先权。请参阅 CMD /? 获取详细信息。
        REM ENABLEDELAYEDEXPANSION / DISABLEDELAYEDEXPANSION
            REM 启用或禁用延缓环境变量
            REM 扩展。这些参数比 CMD
            REM /V:ON 或 /V:OFF 开关有优先权。请参阅 CMD /? 获取详细信息。
REM 无论在 SETLOCAL 命令之前它们的设置是什么，这些修改会一直
REM 保留到匹配的 ENDLOCAL 命令。

REM 如果有一个参数，
REM SETLOCAL 命令将设置 ERRORLEVEL 的值。如果有两个有效参数中的一个，
REM 该值则为零。
REM 用下列技巧，您可以在批脚本中
REM 使用这个来决定扩展是否可用:

    REM VERIFY OTHER 2>nul
    REM SETLOCAL ENABLEEXTENSIONS
    REM IF ERRORLEVEL 1 echo Unable to enable extensions

REM 这个方法之所以有效，是因为在 CMD.EXE 的旧版本上，SETLOCAL
REM 未设置 ERRORLEVEL 值。具有不正确参数的 VERIFY 命令将
REM ERRORLEVEL 值初始化成非零值。




:FS_INIT
if ""=="%~2" goto :eof
echo [SHELL] Initializing [%2]...
if not exist %FS_ROOT%\%1\NUL goto :eof
call :MY_SET FS_%2 %FS_ROOT%\%1
call :FS_SET %1 %2 cmd CMD
call :FS_SET %1 %2 app APP
call :FS_SET %1 %2 data DATA
for %%i in (cmd bin sbin) do if exist %FS_ROOT%\%1\%%i\NUL set NEWPATH=%FS_ROOT%\%1\%%~ni;!NEWPATH!
if exist %FS_ROOT%\%1\init.bat call %FS_ROOT%\%1\init.bat %*
for /L %%i in (0,1,25) DO (
    for %%j in (%FS_ROOT%\%1\cmd\auto\%%i*.bat) DO call "%%~j" 
)
goto :eof

:MY_SET
set FS_TEMP_STR=%2
set FS_TEMP_STR=%FS_TEMP_STR:\\=\%
set FS_TEMP_STR=%FS_TEMP_STR:\\=\%
set FS_TEMP_STR=%FS_TEMP_STR:\\=\%
set %1=%FS_TEMP_STR%
set FS_TEMP_STR=
goto :eof

:FS_SET
if exist %FS_ROOT%\%1\%3\NUL (
	call :MY_SET FS_%2_%4=%FS_ROOT%\%1\%3
)
goto :eof



:usage
echo Shell v1.0
echo        - xiaoranzzz@gmail.com
echo Usage:
echo    Shell [-r ROOT_DIR] [cmds...]
echo Option:
echo    -h      	Display this texts
echo    -r      	Set shell FS_ROOT directory
echo    -d      	Set shell working directory
echo	-i		Inherit parent FS_ROOT PATH...
echo	-s,--NO_CMDS	Set no cmd mode
pause
goto END


:BEGIN
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION 

title Shell 
SET SHELL_CMD=
SET SHELL_DIR=
SET SHELL_INHERIT_PARENT=
SET SHELL_MODE_NOCMDS=
SET SHELL_D=%~d0
SET SHELL_P=%~p0


:getopt
if "%~1"=="" goto getopt_done
if /I "%~1"=="-h" goto usage
if /I "%~1"=="-i" (set SHELL_INHERIT_PARENT=1&shift&goto getopt)
if /I "%~1"=="-s" (set SHELL_MODE_NOCMDS=1&shift&goto getopt)
if /I "%~1"=="-r" (set SHELL_FS_ROOT=%~2&shift&shift&goto getopt)
if /I "%~1"=="-d" (set SHELL_DIR=%~2&shift&shift&goto getopt)
set SHELL_CMD=%SHELL_CMD% %1
shift
goto getopt
:getopt_done


:SET_S
IF "%SHELL_INHERIT_PARENT%"=="" (set FS_ROOT=&set PATH=)
SET SHELL_INHERIT_PARENT=
IF NOT "%SHELL_FS_ROOT%"=="" set FS_ROOT=%SHELL_FS_ROOT%
SET SHELL_FS_ROOT=

:FSROOT_S
IF NOT "%FS_ROOT%"=="" GOTO FSROOT_E
REM SET FS_ROOT=%SHELL_D%%SHELL_P%
SET FS_ROOT=%~DP0
SET FS_ROOT=%FS_ROOT:\core\sbin\=%
if exist "%FS_ROOT%\core\sbin\Shell.bat" goto FSROOT_E
SET FS_ROOT=%SHELL_D%
if exist "%FS_ROOT%\core\sbin\Shell.bat" goto FSROOT_E
SET FS_ROOT=%SHELL_D%%SHELL_P%
:FSROOT_E
SET SHELL_D=
SET SHELL_P=
call :MY_SET FS_ROOT %FS_ROOT%
echo [SHELL] Root in "%FS_ROOT%"
SET SHELL_OLD_PATH=%PATH%
set NEWPATH=%SYSTEMROOT%\system32
set NEWPATH=%NEWPATH%;%SYSTEMROOT%

call :FS_INIT core CORE
call :FS_INIT system SYSTEM
call :FS_INIT local LOCAL
call :FS_INIT workspace WORKSPACE
call :FS_INIT temp   TEMP
set FS_APP=%FS_SYSTEM_APP%
set FS_CMD=%FS_SYSTEM_CMD%
echo [SHELL] Initialized.

set PATH=%NEWPATH:\\=\%
set NEWPATH=
call PATHADD.BAT "%SHELL_OLD_PATH%"

:PATH_E
REM for %%i in (%PATH%) do echo %%i
REM if exist %FS_Core%\bin\sed.exe echo %PATH% | %FS_CORE%\bin\sed.exe -e "s/;\+/\n/g;s/\\\\/\\/g";
SET SHELL_OLD_PATH=

rem SETX -m PATH "%PATH%"


:CWD_S
REM SET SHELL_PWD=%CD%
if not "%SHELL_DIR%"=="" (echo [SHELL] Working under "%SHELL_DIR%"&CHDIR /D "%SHELL_DIR%")
:CWD_E
set SHELL_DIR=

:CMD_S
if not "%SHELL_MODE_NOCMDS%"=="" goto CMD_E
if "__BYCMD__" == "%SHELL_CMD%" goto CMD_E
if "" == "%SHELL_CMD%" SET SHELL_CMD=cmd.exe
:SHELL_CMD

title "%SHELL_CMD%"
echo [SHELL] %SHELL_CMD%
%SHELL_CMD%

REM    CHDIR /D "%SHELL_PWD%"
:CMD_E
SET SHELL_PWD=
SET SHELL_MODE_NOCMDS=
SET SHELL_CMD=

GOTO END




:END
SET SHELL_INHERIT_PARENT=
endlocal

