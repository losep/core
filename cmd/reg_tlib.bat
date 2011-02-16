@echo %DEBUG% off
setlocal
rem set EXECUTE=ECHO DEBUG:
set dp=%~dp0

:check_opt
if "%~1"=="-u" set u=1&shift
if "%~1"=="-r" set r=1&shift&goto check_opt
if "%~1"=="-q" set noquiet=1&shift&goto check_opt
:check_opt_end
set tlb_arg=
if "%u%"=="1" (
    set tlb_arg= -u
)
if not "%noquiet%"=="1" (
REM    set tlb_arg=-q%tlb_arg%
) 


call :start "%~1"
goto end

:execute
echo %*
%EXECUTE% %*
goto :eof


:syscopy
if exist "%SYSTEMROOT%\system32\%~nx1" goto :eof
call :execute copy "%~1" "%SYSTEMROOT%\system32\%~nx1"
goto :eof


:start
if "%~1"=="" goto :eof
if exist "%~1\*.*" goto reg_dir
call :syscopy "%~1"
call :execute "%dp%regtlibv12.exe"%tlb_arg% "%SYSTEMROOT%\SYSTEM32\%~nx1"
goto :start_end
:reg_dir
for %%i in ("%~1\*.*") do (

    call :syscopy "%%~i" "%%~nxi"
    call :execute "%dp%regtlibv12.exe"%tlb_arg% "%SYSTEMROOT%\SYSTEM32\%%~nxi"
)
if "%r%"=="" goto :eof
for /d %%i in ("%d%\*") do (
    call :start "%%~i"
)
:start_end
goto :eof

:END
endlocal
