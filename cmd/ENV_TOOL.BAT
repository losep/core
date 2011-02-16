@ECHO %DEBUG% OFF
SetLocal EnableDelayedExpansion
if "%~1"=="" goto usage_s
if /i "%~1"=="-h" goto usage_s
set VARNAME=%~1
shift

:getopt_s
if /i "%~1"=="-h" goto usage_s
if /i "%~1"=="-a" (set ENV_MODE=APPEND&shift&goto getopt_s)
if /i "%~1"=="-p" (set ENV_MODE=PREPEND&shift&goto getopt_s)
if /i "%~1"=="-n" (set ENV_MODE=NEW&shift&goto getopt_s)
if /i "%~1"=="-\" (set ENV_PATH_MODE=1&shift&goto getopt_s)
if /i "%~1"=="-/" (set ENV_PATH_MODE=1&shift&goto getopt_s)
if /i "%~1"=="-d" (set ENV_MODE=DELETE&shift&goto getopt_s)
:getopt_e

if "%ENV_MODE%"=="" set ENV_MODE=APPEND
SET OLDVALUE=!%VARNAME%!

if "%ENV_MODE%"=="NEW" goto end
if not "%ENV_PATH_MODE%"=="" goto env_path_s
SET NEWVALUE=%~1
shift
if "%OLDVALUE%"=="" goto end
if "%ENV_MODE%"=="DELETE" (
    SET NEWVALUE=%OLDVALUE:%NEWVALUE%%
    goto end
)

if "%ENV_MODE%"==%PREPEND% (
    SET NEWVALUE=%NEWVALUE%%OLDVALUE%
)
else (
    SET NEWVALUE=%OLDVALUE%%NEWVALUE%
)
goto end

:env_path_s
:set_new_s
if "%~1"=="" goto set_new_e
if "%NEWVALUE%"=="" (
    set NEWVALUE=%~1
) else (
    set NEWVALUE=%NEWVALUE%;%~1
)
shift
goto set_new_s
:set_new_e
if "%OLDVALUE%"=="" goto end
SET _OLDVALUE=%OLDVALUE: =$_$%
SET OLDVALUE=
SET NEWVALUE=%NEWVALUE: =$_$%
for %%i in (%_OLDVALUE%) do (call :path_add_s %%i)
if "%ENV_MODE%"=="DELETE" (
    set NEWVALUE=%OLDVALUE%
    goto env_path_e
)
if "%ENV_MODE%"=="PREPEND" (
    set NEWVALUE=%NEWVALUE%;%OLDVALUE%
) else (
    set NEWVALUE=%OLDVALUE%;%NEWVALUE%
)
:env_path_e
set _OLDVALUE=
set NEWVALUE=%NEWVALUE:$_$= %
goto end

:path_add_s
for %%j in (%NEWVALUE%) do (
    if /i "%*"=="%%j" goto path_add_e
)
if "%OLDVALUE%"=="" (
    set OLDVALUE=%*
) else (
    SET OLDVALUE=%OLDVALUE%;%*
)
:path_add_e
goto :eof


:usage_e
echo %0 ENV_VARIABLE_NAME [options] Values...
echo - simple batch util for modifing Variable
echo    default to prefixing mode
echo    -a    Appending Mode
echo    -n    Replacing Mode
echo    -p    Prefix Mode
echo	-/    PATH like Mode
echo	-\    PATH like Mode
goto abort
:OK

:END
echo set %VARNAME%=%NEWVALUE%>%temp%\env_tool.bat
ENDLOCAL
%temp%\env_tool.bat
:Abort
set NEWVALUE=
set OLDVALUE=
set ENV_MODE=
set ENV_PATH_MODE=
set VARNAME=
