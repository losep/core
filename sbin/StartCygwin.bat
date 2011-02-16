@echo %DEBUG% off

setlocal
SET SHELL_CMD=
SET SHELL_DIR=
SET SHELL_INHERIT_PARENT=
SET SHELL_MODE_NOCMDS=
SET SHELL_D=%~d0
SET SHELL_P=%~p0
goto getopt

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
goto END


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
echo [SHELL] Root in "%FS_ROOT%"
rem SETX -m FS_ROOT "%FS_ROOT%"

@rem set USERNAME=xiaoranzzz
@rem set USER=%USERNAME%
@rem echo [SHELL] Username as "%USERNAME%"

set FS_Core=%FS_ROOT%\core
set FS_Core_APP=%FS_Core%\app
set FS_Core_Data=%FS_Core%\Data
set FS_Core_CMD=%FS_Core_APP%\cmd



Set FS_System=%FS_ROOT%\system
set FS_System_APP=%FS_System%\app
set FS_System_Data=%FS_System%\Data
set FS_System_CMD=%FS_System_APP%\cmd

set FS_APP=%FS_SYSTEM_APP%
set FS_BAT=%FS_SYSTEM_CMD%


REM Set FS_Local=%FS_ROOT%\Local
REM set FS_Local_APP=%FS_Local%\app
REM set FS_Local_Data=%FS_Local%\Data
REM set FS_Local_CMD=%FS_APP%\cmd



set FS_TMP=%FS_ROOT%\temp







@rem set LINUXROOT=%FS_ROOT%\linux

@rem set HOME=%LINUXROOT%\home\%USERNAME%
@rem echo [SHELL] Home in "%HOME%"


:PATH_S
SET SHELL_OLD_PATH=%PATH%
SET PATH=%FS_Core%\sbin;%FS_Core%\bin;%PATH%
@REM set UID=0
@REM set GID=0
@REM set TMP=%LINUXROOT%\tmp
@REM set TMPDIR=%TMP%

@rem set NEWPATH=%NEWPATH%;%LINUXROOT%\bin

REM windows path
set NEWPATH=%SYSTEMROOT%\system32
set NEWPATH=%NEWPATH%;%SYSTEMROOT%
set NEWPATH=%FS_Core%\sbin;%FS_Core%\bin;%FS_Core_Cmd%;%NEWPATH%


for /L %%i in (0,1,16) DO (
    for %%j in (%FS_Core_Cmd%\AUTO\%%i*.bat) DO call "%%~j"
)

if exist "%FS_ROOT%\Workspace\init.bat" call "%FS_ROOT%\Workspace\init.bat"

if exist %FS_System%\init.bat call "%FS_System%\init.bat"
if exist %FS_System%\bin\NUL set NEWPATH=%FS_SYSTEM%\bin;%NEWPATH%
if exist %FS_System%\sbin\NUL set NEWPATH=%FS_SYSTEM%\sbin;%NEWPATH%
if exist %FS_System_CMD%\NUL set NEWPATH=%FS_System_CMD%;%NEWPATH%
for /L %%i in (0,1,16) DO (
    for %%j in (%FS_System_Cmd%\AUTO\%%i*.bat) DO call "%%~j"
)



if exist "%FS_ROOT%\Local\init.bat" call "%FS_ROOT%\Local\init.bat"

REM for /L %%i in (0,1,16) DO (
    REM for %%j in (%FS_Local_Cmd%\AUTO\%%i*.bat) DO call "%%~j"
REM )

set PATH=%NEWPATH%
set NEWPATH=
call PATHADD.BAT "%SHELL_OLD_PATH%"

:PATH_E
if exist %FS_Core%\bin\sed.exe echo %PATH% | %FS_CORE%\bin\sed.exe -e "s/;\+/\n/g;s/\\\\/\\/g";
SET SHELL_OLD_PATH=

rem SETX -m PATH "%PATH%"


:CWD_S
SET SHELL_PWD=%CD%
if not "%SHELL_DIR%"=="" (echo [SHELL] Working under "%SHELL_DIR%"&CHDIR /D "%SHELL_DIR%")
:CWD_E
set SHELL_DIR=

:CMD_S

title Cygwin Shell 
SET FS_SHELL=CYGWIN
SET HOME=%FS_Core%\Data\Linux
SET USERNAME=xiaoranzzz
SET USER=xiaoranzzz

if not "%SHELL_MODE_NOCMDS%"=="" goto CMD_E
if "__BYCMD__" == "%SHELL_CMD%" goto CMD_E
if "" == "%SHELL_CMD%" SET SHELL_CMD=%FS_CORE_APP%\cygwin\bin\sh.exe --login -i



:SHELL_CMD
    echo [SHELL] Run %SHELL_CMD%
    %SHELL_CMD%
    CHDIR /D "%SHELL_PWD%"
:CMD_E
SET SHELL_PWD=
SET SHELL_MODE_NOCMDS=
SET SHELL_CMD=

:END
SET SHELL_INHERIT_PARENT=
endlocal