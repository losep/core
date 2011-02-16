@echo off
if "x%1"=="x-u" goto DoUnReg
if "x%1"=="x-h" goto HelpMe
goto DoReg

:DoReg
shellreg -r Directory opensh "X:\Program\Commands\sh.bat \"%%1\"" "&MSys Here" goto END
goto END

:DoUnReg
shellreg -u Directory opensh
goto END

:HelpMe
echo %0 
echo    - Register or unregister directoies shell cmd
echo Usage:
echo    %0 [Options]
echo Options:
echo    -h Display this text
echo    -u Unregister
echo    -r Register
goto END

:END
