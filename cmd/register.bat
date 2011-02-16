@echo off
setlocal
set dp=%~dp0

:check_opt
if "%~1"=="-u" set u=1&shift
if "%~1"=="-r" set r=1&shift&goto check_opt
if "%~1"=="-q" set noquiet=1&shift&goto check_opt
:check_opt_end
set dll_arg=
set tlb_arg=
set reg_arg=
if "%u%"=="1" (
    set dll_arg=/u
    set tlb_arg=-u
)
if not "%noquiet%"=="1" (
    set dll_arg=/s %dll_arg%
    set tlb_arg=-q %tlb_arg%
    set reg_arg=/s
) 
set regtlib=regtlibv12.exe
if exist "%dp%regtlibv12.exe" set regtlib=%dp%regtlibv12.exe
if exist "%dp%bin\regtlibv12.exe" set regtlib=%dp%bin\regtlibv12.exe
if exist "%dp%..\bin\regtlibv12.exe" set regtlib=%dp%..\bin\regtlibv12.exe
if exist "%dp%..\utils\regtlibv12.exe" set regtlib=%dp%..\utils\regtlibv12.exe

call :start "%~1"
goto END

:execute
echo %*
%EXECUTE% %*
goto :eof


:syscopy
if exist "%SYSTEMROOT%\system32\%~nx1" goto :eof
call :execute copy "%~1" "%SYSTEMROOT%\system32\%~nx1"
goto :eof


:start
if "%~1" == "" GOTO goto :eof
if not "" == "%u%" goto skip_reg
for %%i in ("%~1\*.reg") do (
    call :execute regedit %reg_arg% "%%~fi"
)
:skip_reg
for %%i in ("%~1\*.dll" "%~1\*.ocx") do (
    call :execute regsvr32 %dll_arg% "%%~fi"
)
for %%i in ("%~1\*.tlb" "%~1\*.olb") do (
    call :execute "%regtlib%" %tlb_arg% "%%~fi"
)
if "%r%"=="" goto :eof
for /d %%i in ("%~1\*") do (
    call :start "%%~i"
)
goto :eof

:END
endlocal

