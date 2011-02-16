@ECHO OFF
REM progrun DIRNAME EXENAME

if "%1"=="" goto help
if not "%2"=="" goto arg2

:arg1
imdisk -a -m a: -f %1 -v 1
goto end
:arg2
if not "%3"=="" goto arg3
imdisk -a -m a: -f %1 -v %2
goto end
:arg3
imdisk -a -m %3 -f %1 -v %2
goto end


:help
echo Usage:%0 img-file [partition_num] [mount_point]
goto end

:end
