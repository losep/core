
Param (
    [alias("r","root")][parameter(Position=1)][String][AllowEmptyString()]$FS_ROOT,
    [alias("w","working-dir")][parameter(Position=2)][String]$OPT_WDIR,
    [alias("h","help")][parameter(Position=3)][switch]$OPT_HELP,
    [alias("n","no-cmds")][parameter(Position=4)][switch]$OPT_NO_CMDS,
    [alias("c","commands")][parameter(Position=0)][String[]]$CMDS
)
"==================================================="
foreach ($arg in $psboundparameters.keys) {
    $arg + " = " + $psboundparameters[$arg]
}
"==================================================="
$APP_NAME = 'Shell'
$APP_VERSION = '1.0'

function message([string]$title,[string[]]$text) {
    #$title = $args[0]
    #$text = $args[1]
    for($i = 2;$i -lt $args.Count;$i++) {
        #$text += " " + $args[$i]
    }
   Write-Output ("[" + $title + "] " + $text)
}
$CWD = Get-Location
$FILE = Get-Item($MyInvocation.InvocationName)
$CORE_NAME = '\core'
$COMPONENTS = ("core","system","local","workspace","temp")
$EXEC_NAMES = ("sbin","cmd","bin")
$SUB_COMPS = ("app","data")
$AUTO_INIT_DIR = 'auto.d'
$INIT_FILENAME = "init.ps1"



<#
设定 FS_ROOT, 1.参数指定 2.脚本父目录上溯至 $CORE_NAME 3.脚本父目录的父目录
#>
if(! $FS_ROOT) {
    $FS_ROOT = $FILE.Directory.Fullname
    $i = $FS_ROOT.lastIndexOf($CORE_NAME)
    if($i) {
        $FS_ROOT = $FS_ROOT.Remove($i);
    }
    else {
        $FS_ROOT = $FILE.Directory.Parent.Fullname
    }
}
message $APP_NAME "ROOT in",$FS_ROOT
$FILE.FullName

foreach ($c in $COMPONENTS) {
    message $APP_NAME "Initializing $c"
    $fs_comp = Get-Item ($FS_ROOT + "\" + $c)
    if($fs_comp) {
        $fs_name = "FS_" + $c
        set-item -path ("env:"+ $fs_name) -value $fs_comp.Fullname
        get-item -path ("env:" + $fs_name)
    }
    #init_component($c)
}

<#    

:FS_INIT
if ""=="%~2" goto :eof
echo [SHELL] Initializing [%2]...
if not exist %FS_ROOT%\%1\NUL goto :eof
call :MY_SET FS_%2 %FS_ROOT%\%1
call :FS_SET %1 %2 cmd CMD
call :FS_SET %1 %2 app APP
call :FS_SET %1 %2 data DATA
for %%i in (sbin bin cmd) do if exist %FS_ROOT%\%1\%%i\NUL set NEWPATH=%FS_ROOT%\%1\%%~ni;!NEWPATH!
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

#>
