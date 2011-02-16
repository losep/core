@echo %DEBUG% off
setlocal
rem set EXECUTE=ECHO DEBUG:
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
    set dll_arg= /u
    set tlb_arg= -u
)
if not "%noquiet%"=="1" (
    set dll_arg= /s%dll_arg%
    set tlb_arg= -q%tlb_arg%
    set reg_arg= /s
) 


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
if "%~1" == "" GOTO :eof
if exist "%~1\*.*" goto is_dir
if /i "%~x1" == ".reg" call :execute regedit.exe%reg_arg% "%~1" &goto :eof
if /i "%~x1" == ".dll" call :execute regsvr32.exe%dll_arg% "%~1" &goto :eof
if /i "%~x1" == ".tlb" call :execute "%dp%\regtlibv12.exe"%tlb_arg% "%~1" &goto :eof
if /i "%~x1" == ".olb" call :execute "%dp%\regtlibv12.exe"%tlb_arg% "%~1" &goto :eof
goto :eof
:is_dir
for %%i in ("%~1\*.reg") do (
    call :execute regedit.exe%reg_arg% "%%~i"
)
for %%i in ("%~1\*.dll" "%~1\*.ocx") do (
    call :syscopy "%%~i"
    call :execute regsvr32.exe%dll_arg% "%SYSTEMROOT%\SYSTEM32\%%~nxi"
)
for %%i in ("%~1\*.tlb" "%~1\*.olb") do (
    call :syscopy "%%~i" "%%~nxi"
    call :execute "%dp%\regtlibv12.exe"%tlb_arg% "%SYSTEMROOT%\SYSTEM32\%%~nxi"
)
if "%r%"=="" GOTO :eof
for /d %%i in ("%~1\*") do (
    call :start "%%~i"
)
goto :eof


:END
endlocal
