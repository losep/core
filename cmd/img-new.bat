@ECHO OFF
if "%1"=="" goto USAGE
qemu-img create -f raw %*
goto end
:usage
echo Usage:
echo   %0 filename size
:end
