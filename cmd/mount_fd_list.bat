@ECHO OFF
if "%1"=="" goto usage
if not "%2"=="" goto mount

for %%i in (%1) do (
    call mountfd "%%~i"
    echo ------ About to unmount "%%~i" ------
    pause
    call umountfd "%%~i"
)
goto end


:mount
if "%1"=="" goto end
call mountfd "%1"
:umount
echo ------ About to unmount "%%~i" ------
pause
call umountfd "%1"
shift
goto mount


:usage
echo Usage: %0 filename ...
:end


