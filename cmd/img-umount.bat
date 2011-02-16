@ECHO OFF
if "%1"=="" goto help

imdisk -d -m %1

goto end

:help
echo Usage %0 mount_point

:end


