@ECHO OFF
if not "%1"=="" goto arg2
imdisk -d -m a:
goto end

arg2:
imdisk -d -m %1

goto end

:help
echo Usage %0 mount_point

:end


