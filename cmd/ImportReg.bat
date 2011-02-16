@echo off
if "x%1"=="x-h" goto HelpMe
goto DoReg

:DoReg
set cmdline=regedit /s
goto StartAction


:StartAction
@echo on
for /r %%f in (*.reg) do %cmdline% "%%f"
@echo off
goto END

:HelpMe
echo %0 
echo    - Import registry files
echo Usage:
echo    %0 [Options]
echo Options:
echo    -h Display this text
goto END

:END
pause