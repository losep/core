@echo off
if "x%1"=="x-u" goto DoUnReg
if "x%1"=="x-h" goto HelpMe
goto DoReg

:DoReg
set cmdline=call run_echo.bat regsvr32 /s
goto StartAction

:DoUnReg
set cmdline=call run_echo.bat regsvr32 /s /u
goto StartAction

:StartAction
for /r %%f in (*.dll *.ocx *.exe *.tlb) do (
	if exist "%systemRoot%\system32\%%~nxf" (%cmdline% "%systemRoot%\system32\%%~nxf" ) else (%cmdline% "%%f")
)
goto END

:HelpMe
echo %0 
echo    - Register or unregister dlls under current directory
echo Usage:
echo    %0 [Options]
echo Options:
echo    -h Display this text
echo    -u Unregister
echo    -r Register
goto END

:END
pause