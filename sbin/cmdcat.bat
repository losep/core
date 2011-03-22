@ECHO OFF
setlocal

if X%1X==XX GOTO USAGE
for %%d in ("%FS_SYSTEM_CMD%" "%FS_CORE_CMD%" "%FS_CORE%\sbin") do (
    if exist "%%~d\%~1" call :edit "%%~d\%~1"&goto end
    if exist "%%~d\%~1.bat" call :edit "%%~d\%~1.bat"&goto end
)
echo Command not found: %1
goto end

:edit
type "%~1"
goto :eof

GOTO END
:USAGE
echo USAGE: %0 command_name

:end
endlocal